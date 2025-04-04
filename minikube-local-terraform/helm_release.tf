provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
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
  depends_on = [ null_resource.minikube_install ]
}
