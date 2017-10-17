variable "vm_keyname" {
  description = "SSH key"
}

variable "floating_ip" {
  description = "Floating IP"
}

variable "external_network_id" {
  description = "External network ID"
}

module "idr" {
  source = "kubernetes"
  idr_environment = "kube"
  vm_keyname = "${var.vm_keyname}"
  vm_image = "CentOS-7-1708"
  external_network_id = "${var.external_network_id}"
  floating_ip = "${var.floating_ip}"
}
