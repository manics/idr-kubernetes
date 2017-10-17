#

resource "openstack_networking_network_v2" "kubenet" {
  name           = "${var.idr_environment}"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "kubesubnet" {
  name       = "${var.idr_environment}-subnet"
  network_id = "${openstack_networking_network_v2.kubenet.id}"
  cidr       = "${var.subnet_cidr}"
  ip_version = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

/*data "openstack_networking_network_v2" "externalnetwork" {
  name = "${var.external_network}"
}*/

resource "openstack_networking_router_v2" "kuberouter" {
  name = "${var.idr_environment}-router"
  admin_state_up = "true"
  #external_gateway = "${data.openstack_networking_network_v2.externalnetwork.id}"
  external_gateway = "${var.external_network_id}"
}

resource "openstack_networking_router_interface_v2" "kuberouterif" {
  router_id = "${openstack_networking_router_v2.kuberouter.id}"
  subnet_id = "${openstack_networking_subnet_v2.kubesubnet.id}"
}

# If terraform allocates the IP it will automatically release it back
# to the pool on destroy
/*resource "openstack_networking_floatingip_v2" "floating_ip" {
  pool = "${var.external_network}"
}*/

data "openstack_images_image_v2" "centos" {
  name = "${var.vm_image}"
  most_recent = true
}

resource "openstack_compute_instance_v2" "kubemaster" {
  name = "${var.idr_environment}-master-${count.index}"
  image_name = "${var.vm_image}"
  flavor_name = "${var.vm_flavor_master}"
  key_pair = "${var.vm_keyname}"
  security_groups = ["default", "all"]

  count = 1
  #stop_before_destroy = true

  block_device {
    uuid = "${data.openstack_images_image_v2.centos.id}"
    source_type = "image"
    volume_size = 100
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.idr_environment}"
  }

  metadata {
    # Ansible groups
    groups = "${var.idr_environment}-kubemaster-hosts,kubemaster-hosts,${var.idr_environment}-hosts"
  }
}

resource "openstack_compute_floatingip_associate_v2" "floating_ip" {
  #floating_ip = "${openstack_networking_floatingip_v2.floating_ip.address}"
  floating_ip = "${var.floating_ip}"
  instance_id = "${openstack_compute_instance_v2.kubemaster.id}"
}

resource "openstack_compute_instance_v2" "kubeworker" {
  name = "${var.idr_environment}-worker-${count.index}"
  image_name = "${var.vm_image}"
  flavor_name = "${var.vm_flavor_worker}"
  key_pair = "${var.vm_keyname}"
  security_groups = ["default", "all"]

  count = 2
  #stop_before_destroy = true

  block_device {
    uuid = "${data.openstack_images_image_v2.centos.id}"
    source_type = "image"
    volume_size = 100
    boot_index = 0
    destination_type = "volume"
    delete_on_termination = true
  }

  network {
    name = "${var.idr_environment}"
  }

  metadata {
    # Ansible groups
    groups = "${var.idr_environment}-kubeworker-hosts,kubeworker-hosts,${var.idr_environment}-hosts"
  }
}
