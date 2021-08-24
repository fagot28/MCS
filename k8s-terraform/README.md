# Deploy Kubernetes into MSC using Terraform

https://mcs.mail.ru/help/ru_RU/k8s-api/k8s-terraform-qs

* **main.tf** --> create resources

* **variables.tf** --> variables file

* **terraform.tfvars** --> update MCS credentials and other settings

**Для запуска добавить файл с паролем для доступа в MCS**
* содержимое secret.tfvars: mcspassword = "пароль"

**Выполнить:**
* terraform plan 
* terraform apply
