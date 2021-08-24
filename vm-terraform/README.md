# Deploy VM into MSC using Terraform
https://mcs.mail.ru/help/en_US/create-vm/vm-create-tf
https://github.com/MailRuCloudSolutions/terraform-demo

1. Create network and subnet
2. Create router
3. Create keypair
4. Create security group
5. Create VM instance with non-ephemeral disk
6. Apply cloud config which creates a new user and installs nginx
7. Assign Floating IP to the instance
8. Execute bootstrap scrpits during instance provisioning over ssh

* **main.tf** --> create resources

* **variables.tf** --> variables file

* **terraform.tfvars** --> update MCS credentials and other settings

**Выполнить:**

source ../mcs3931659099-openrc.sh

* terraform plan
* terraform apply
