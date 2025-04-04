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


output "k8s_cluster_endpoint" {
  value = opentelekomcloud_cce_cluster_v3.cluster.id
}