# Deploy Kubernetes into MSC using Terraform

https://mcs.mail.ru/help/ru_RU/k8s-api/k8s-terraform-qs

* **main.tf** --> create resources

* **variables.tf** --> variables file

* **terraform.tfvars** --> update MCS k8s settings

**Перед запуском выполнить** 
```bash
source msc*-openrc.sh
```
* пример msc*-openrc.sh в template-openrc.sh

**Выполнить:**
```bash
terraform plan
terraform apply
```
