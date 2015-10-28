resource "openstack_fw_firewall_v1" "mesosphere-firewall" {
    name = "cd-firewall"
    policy_id = "${openstack_fw_policy_v1.mesosphere-policy.id}"
}

resource "openstack_fw_policy_v1" "mesosphere-policy" {
    name = "Open bar"
    rules = [
        "${openstack_fw_rule_v1.out-allow-tcp.id}",
        "${openstack_fw_rule_v1.out-allow-udp.id}",
        "${openstack_fw_rule_v1.in-allow-ssh.id}",
        "${openstack_fw_rule_v1.in-allow-dns.id}"
    ]
}

resource "openstack_fw_rule_v1" "out-allow-udp" {
    name = "out-allow-dns"
    protocol = "udp"
    action = "allow"
}

resource "openstack_fw_rule_v1" "out-allow-tcp" {
    name = "out-allow-tcp"
    protocol = "tcp"
    action = "allow"
}

resource "openstack_fw_rule_v1" "in-allow-ssh" {
    name = "in-allow-ssh"
    protocol = "tcp"
    action = "allow"
    destination_port = "22"
}

resource "openstack_fw_rule_v1" "in-allow-dns" {
    name = "in-allow-dns"
    protocol = "udp"
    action = "allow"
    destination_port = "53"
}

