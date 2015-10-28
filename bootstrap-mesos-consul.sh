#!/bin/bash
# $1 : private key to access instances
# $2 : user 

set -eux
base_directory=$(cd `dirname $0` && pwd)
terraform_directory=$base_directory/terraform
ansible_directory=$base_directory/ansible

cd $terraform_directory && terraform apply --input=false
cd $base_directory && terraform output -state=terraform/terraform.tfstate output | python gen_inventory.py
ip=$(terraform output -state=terraform/terraform.tfstate orchestrator)

sleep 10

ssh -i $1 $2@$ip 'sudo rm -f ~/key.pem'
scp -i $1 $1 $2@$ip:~/key.pem
scp -i $1 inventory $2@$ip:~/inventory

ssh -i $1 $2@$ip 'sudo sed -i "s/localhost$/localhost orchestrator/" /etc/hosts'
scp -i $1 $ansible_directory/provision.yml $2@$ip:~/provision.yml
ssh -i $1 $2@$ip 'sudo apt-get install -y python-pip && sudo pip install -U ansible'

ssh -i $1 $2@$ip "echo 'localhost' > localhost; export ANSIBLE_HOST_KEY_CHECKING=False; ansible-playbook -i localhost ~/provision.yml --connection=local --private-key=~/key.pem"
ssh -i $1 $2@$ip "export ANSIBLE_HOST_KEY_CHECKING=False; cd ansible-mesos-playbook && ansible-playbook -i ~/inventory --private-key=~/key.pem playbook.yml"

