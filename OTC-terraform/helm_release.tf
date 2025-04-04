
# Configure Helm Provider
provider "helm" {
  kubernetes {
    host                   = opentelekomcloud_cce_cluster_v3.cluster.id
    token                  = "TestSecret"
  }
}

resource "helm_release" "fine-tune-app" {
  name       = "fine-tune-app"
  chart      = "./fine-tune-app"
  version    = "0.1.0"
  namespace  = "default"
  timeout    = 900 # For safe side set to 15 Mins as docker image is 6+GB takes around 11+mins for image Pulling from Dockerhub. 
  set {
    name  = "image.repository"
    value = "nirupamak/fine-tune"
  }
  set {
    name  = "image.tag"
    value = "latest"
  }
  depends_on = [ opentelekomcloud_cce_cluster_v3.cluster ]
}
