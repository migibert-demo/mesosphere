#!/bin/bash
# $1 : private key to access instances
# $2 : user 

set -eux
base_directory=$(cd `dirname $0` && pwd)
terraform_directory=$base_directory/terraform
provision_directory=$base_directory/provision

cd $terraform_directory && terraform apply --input=false
cd $base_directory && terraform output -state=terraform/terraform.tfstate output | python gen_inventory.py
ip=$(terraform output -state=terraform/terraform.tfstate orchestrator)

ssh -i $1 $2@$ip 'sudo rm -f ~/key.pem'
scp -i $1 $1 $2@$ip:~/key.pem
scp -i $1 inventory $2@$ip:~/inventory

ssh -i $1 $2@$ip 'sudo sed -i "s/localhost$/localhost orchestrator/" /etc/hosts'

ssh -i $1 $2@$ip 'sudo rm -rf provision && mkdir -p provision'
scp -r -i $1 $provision_directory/* $2@$ip:~/provision
ssh -i $1 $2@$ip 'sudo apt-get update && sudo apt-get install -y python-dev python-pip && sudo pip install -U ansible'
ssh -i $1 $2@$ip 'sudo ansible-galaxy install mhamrah.java8 --force'
ssh -i $1 $2@$ip "export ANSIBLE_HOST_KEY_CHECKING=False; cd provision && ansible-playbook -i ~/inventory --private-key=~/key.pem playbook.yml"

