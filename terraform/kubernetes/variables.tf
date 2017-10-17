variable "idr_environment" {
  description = "IDR environment/deployment"
}

variable "vm_image" {
  default = "CentOS 7"
}

variable "vm_keyname" {
  description = "SSH key"
}

variable "vm_flavor_master" {
  default = "m1.medium"
}

variable "vm_flavor_worker" {
  default = "m1.large"
}

variable "external_network" {
  default = "external_network"
}

variable "external_network_id" {
  description = "ID of the external network"
}

variable "floating_ip" {
  description = "Floating IP address (must already belong to the project)"
}

variable "subnet_cidr" {
  default = "192.168.210.0/24"
}
