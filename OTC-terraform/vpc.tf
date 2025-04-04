resource "opentelekomcloud_networking_secgroup_v2" "fine_tune_security_group" {
  name = "app-security-grp"
}

resource "opentelekomcloud_vpc_v1" "fine_tune_vpc" {
  name   = "vpc_fine_tune"
  cidr   = "192.168.0.0/16"
  #shared = true
}

resource "opentelekomcloud_vpc_subnet_v1" "fine_tune_subnet" {
  name        = "subnet_fine_tune"
  cidr        = "192.168.0.0/16"
  gateway_ip  = "192.168.0.1"
  vpc_id      = opentelekomcloud_vpc_v1.fine_tune_vpc.id
  dhcp_enable = true
  dns_list    = ["100.125.4.25", "1.1.1.1"]
}

output "fine_tune_security_group_id" {
  value = opentelekomcloud_networking_secgroup_v2.fine_tune_security_group.id
}

output "fine_tune_vpc" {
  value = opentelekomcloud_vpc_v1.fine_tune_vpc
}

output "fine_tune_subnet" {
  value = opentelekomcloud_vpc_subnet_v1.fine_tune_subnet
}