resource "opentelekomcloud_identity_agency_v3" "enable_cce_auto_creation" {
  name                  = "cce_admin_trust"
  description           = "For terraform auto create CCE"
  delegated_domain_name = "op_svc_cce"
  dynamic "project_role" {
    for_each = var.projects
    content {
      project = project_role.value
      roles = [
        "Tenant Administrator"
      ]
    }
  }
}

resource "opentelekomcloud_cce_cluster_v3" "cluster" {
  name                   = "fine-tune-cluster"
  region                 = "eu-de"
  vpc_id                 = opentelekomcloud_vpc_v1.fine_tune_vpc.id
  subnet_id              = opentelekomcloud_vpc_subnet_v1.fine_tune_subnet.id
  cluster_type           = "VirtualMachine"
  flavor_id              = var.flavor_name
  container_network_type = "overlay_l2"
  authentication_mode    = "rbac"
  kube_proxy_mode        = "ipvs"
  annotations            = { "cluster.install.addons.external/install" = "[{\"addonTemplateName\":\"icagent\"}]" }
  depends_on             = [opentelekomcloud_identity_agency_v3.enable_cce_auto_creation]
  }

resource "opentelekomcloud_ecs_instance_v1" "instance_1" {
  name     = "Cluster_instance_1"
  image_id = "Sample_Image_ID"
  flavor   = var.flavor_name
  vpc_id   = opentelekomcloud_vpc_subnet_v1.fine_tune_subnet.vpc_id

  nics {
    network_id = opentelekomcloud_vpc_subnet_v1.fine_tune_subnet.network_id
  }

  availability_zone = "eu-de-01"
  data_disks {
    type = "SSD"
    size = 60
  }

  password                    = "Secret@123"
  delete_disks_on_termination = true

  lifecycle {
    ignore_changes = [
      name,
      image_id,
      password,
      key_name,
      tags,
      nics
    ]
  }
}

resource "opentelekomcloud_cce_node_attach_v3" "instance_1_attach" {
  cluster_id = opentelekomcloud_cce_cluster_v3.cluster.id
  server_id  = opentelekomcloud_ecs_instance_v1.instance_1.id
  key_pair   = "Test_ssh_key"
  os         = "EulerOS 2.5"

  tags = {
    ENV = "NAK-Test"
    cluster = "K8S"
  }
}
output "k8s_cluster_endpoint" {
  value = opentelekomcloud_cce_cluster_v3.cluster.id
}