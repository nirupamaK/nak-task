variable "username" {
  default = "TestUser"
}

variable "password" {
  default = "TestSecret123"
}

variable "domain_name" {
  default = "test-private"
}

variable "tenant_name" {
  default = "eu-de"
}

variable "endpoint" {
  default = "https://iam.eu-de.otc.t-systems.com:443/v3"
}

variable "external_network" {
  default = "admin_external_net"
}

variable "projects" {
  default = ["fine-tune-app"]
}

variable "subnet_cidr" {
  default = "192.168.10.0/24"
}
### DNS Settings
variable "dnszone" {
  default = "fine-tune-app.test"
}
### VM (Instance) Settings
variable "instance_count" {
  default = "1"
}

variable "flavor_name" {
  default = "cce.s1.small"
}
