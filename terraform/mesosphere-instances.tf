resource "openstack_compute_instance_v2" "instance-orchestrator" {
    name = "orchestrator"
    image_name = "ubuntu-14.04_x86_64"
    flavor_name = "1_vCPU_RAM_512M_HD_10G"
    key_pair = "${var.keypair_name}"
    floating_ip = "${openstack_networking_floatingip_v2.orchestrator_floating_ip.address}"
    network = {
        uuid = "${openstack_networking_network_v2.mesosphere-admin-net.id}"
    }
    depends_on = ["openstack_networking_router_interface_v2.mesosphere-admin-router-interface"]
    depends_on = ["openstack_networking_floatingip_v2.orchestrator_floating_ip.address"]
}

resource "openstack_compute_instance_v2" "instance-mesos-master-1" {
    name = "mesos-master-1"
    image_name = "ubuntu-14.04_x86_64"
    flavor_name = "1_vCPU_RAM_2G_HD_10G"
    key_pair = "${var.keypair_name}"
    network = {
        uuid = "${openstack_networking_network_v2.mesosphere-admin-net.id}"
    }
    depends_on = ["openstack_networking_router_interface_v2.mesosphere-admin-router-interface"]
}

resource "openstack_compute_instance_v2" "instance-mesos-master-2" {
    name = "mesos-master-2"
    image_name = "ubuntu-14.04_x86_64"
    flavor_name = "1_vCPU_RAM_2G_HD_10G"
    key_pair = "${var.keypair_name}"
    network = {
        uuid = "${openstack_networking_network_v2.mesosphere-admin-net.id}"
    }
    depends_on = ["openstack_networking_router_interface_v2.mesosphere-admin-router-interface"]
}

resource "openstack_compute_instance_v2" "instance-mesos-master-3" {
    name = "mesos-master-3"
    image_name = "ubuntu-14.04_x86_64"
    flavor_name = "1_vCPU_RAM_2G_HD_10G"
    key_pair = "${var.keypair_name}"
    network = {
        uuid = "${openstack_networking_network_v2.mesosphere-admin-net.id}"
    }
    depends_on = ["openstack_networking_router_interface_v2.mesosphere-admin-router-interface"]
}

resource "openstack_compute_instance_v2" "instance-mesos-private-slave-1" {
    name = "mesos-private-slave-1"
    image_name = "ubuntu-14.04_x86_64"
    flavor_name = "1_vCPU_RAM_2G_HD_10G"
    key_pair = "${var.keypair_name}"
    network = {
        uuid = "${openstack_networking_network_v2.mesosphere-private-net.id}"
    }
    depends_on = ["openstack_networking_router_interface_v2.mesosphere-private-router-interface"]
}

resource "openstack_compute_instance_v2" "instance-mesos-private-slave-2" {
    name = "mesos-private-slave-2"
    image_name = "ubuntu-14.04_x86_64"
    flavor_name = "1_vCPU_RAM_2G_HD_10G"
    key_pair = "${var.keypair_name}"
    network = {
        uuid = "${openstack_networking_network_v2.mesosphere-private-net.id}"
    }
    depends_on = ["openstack_networking_router_interface_v2.mesosphere-private-router-interface"]
}

resource "openstack_compute_instance_v2" "instance-mesos-private-slave-3" {
    name = "mesos-private-slave-3"
    image_name = "ubuntu-14.04_x86_64"
    flavor_name = "1_vCPU_RAM_2G_HD_10G"
    key_pair = "${var.keypair_name}"
    network = {
        uuid = "${openstack_networking_network_v2.mesosphere-private-net.id}"
    }
    depends_on = ["openstack_networking_router_interface_v2.mesosphere-private-router-interface"]
}

output "orchestrator" {
    value = "${openstack_networking_floatingip_v2.orchestrator_floating_ip.address}"
}

output "output" {
    value = "mesosphere-masters: ${openstack_compute_instance_v2.instance-mesos-master-1.network.0.fixed_ip_v4},${openstack_compute_instance_v2.instance-mesos-master-2.network.0.fixed_ip_v4},${openstack_compute_instance_v2.instance-mesos-master-3.network.0.fixed_ip_v4}\nmesosphere-slaves: ${openstack_compute_instance_v2.instance-mesos-private-slave-1.access_ip_v4},${openstack_compute_instance_v2.instance-mesos-private-slave-2.access_ip_v4},${openstack_compute_instance_v2.instance-mesos-private-slave-3.access_ip_v4}"
}
