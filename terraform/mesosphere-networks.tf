provider "openstack" {
    insecure = true
}

variable "region" {
    default = "tr2"
}

variable "router_id" {
    default = {
        tr2 = "3292fe33-0243-4bca-8acc-b7731ec4298e"
    }
}

variable "keypair_name" {
    default = "mesosphere-demo"
}

variable "floatingip_pool" {
    default = "PublicNetwork-02"
}

resource "openstack_networking_network_v2" "mesosphere-admin-net" {
    name = "mesosphere-admin-net"
}

resource "openstack_networking_subnet_v2" "mesosphere-admin-subnet" {
    network_id = "${openstack_networking_network_v2.mesosphere-admin-net.id}"
    cidr = "192.168.10.0/24"
    ip_version = 4
}

resource "openstack_networking_router_interface_v2" "mesosphere-admin-router-interface" {
    router_id = "${lookup(var.router_id, var.region)}"
    subnet_id = "${openstack_networking_subnet_v2.mesosphere-admin-subnet.id}"
}

resource "openstack_networking_network_v2" "mesosphere-public-net" {
    name = "mesosphere-public-net"
}

resource "openstack_networking_subnet_v2" "mesosphere-public-subnet" {
    network_id = "${openstack_networking_network_v2.mesosphere-public-net.id}"
    cidr = "192.168.20.0/24"
    ip_version = 4
}

resource "openstack_networking_router_interface_v2" "mesosphere-public-router-interface" {
    router_id = "${lookup(var.router_id, var.region)}"
    subnet_id = "${openstack_networking_subnet_v2.mesosphere-public-subnet.id}"
}


resource "openstack_networking_network_v2" "mesosphere-private-net" {
    name = "mesosphere-private-net"
}

resource "openstack_networking_subnet_v2" "mesosphere-private-subnet" {
    network_id = "${openstack_networking_network_v2.mesosphere-private-net.id}"
    cidr = "192.168.30.0/24"
    ip_version = 4
}

resource "openstack_networking_router_interface_v2" "mesosphere-private-router-interface" {
    router_id = "${lookup(var.router_id, var.region)}"
    subnet_id = "${openstack_networking_subnet_v2.mesosphere-private-subnet.id}"
}

resource "openstack_networking_floatingip_v2" "orchestrator_floating_ip" {
    pool = "${var.floatingip_pool}"
}
