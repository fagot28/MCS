variable "ssh-key-path" {
  type        = string
  description = "Path to ssh private key"
  default     = "~/.ssh/id_rsa"
}

# Эти параметры получаются через переменные окружения, задаваемыми в msc*-openrc.sh

variable "instance_name" {
  # название создаваемого инстанса
  default = "terraform-test-1"
}

variable "password" {
  # значение OS_PASSWORD. Запрашивается отдельно у mcs support
  # default = ""
}
variable "username" {
  # default = "user@mail.ru"
}

variable "user_domain_id" {
  # значение OS_USER_DOMAIN_ID
  # default = ""
}

variable "tenant_id" {
  # значение OS_PROJECT_ID
  # default = ""
}

variable "auth_url" {
  # значение OS_AUTH_URL
  # default = ""
}

# VM variables -----------------------------------------------------------------

variable "vm-image-id" {
  type        = string
  description = "ID image"
  # default = ""
}

variable "vm-image-name" {
  type        = string
  description = "Name image"
  default     = ""
}

variable "vm-flavor-name" {
  type        = string
  description = "Flavor VM"
  default     = ""
}

variable "vm-instance-name" {
  type        = string
  description = "Name VM"
  default     = "test-vm1"
}

variable "vm-volume-size" {
  type        = string
  description = "Volume Size"
  default     = "5"
}
