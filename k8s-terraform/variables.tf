variable "ssh-private-key-path" {
  type        = string
  description = "Path to ssh private key"
  default = "~/.ssh/id_rsa"
}

variable "ssh-public-key-path" {
  type        = string
  description = "Path to ssh public key"
  default = "~/.ssh/id_rsa.pub"
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

# K8s cluster variables -----------------------------------------------------------------

variable "k8s-flavor-name" {
  type        = string
  description = "Type VM of k8s cluster"
  default = "Standard-2-4-20"
}

variable "k8s-instance-name" {
  type        = string
  description = "Name K8s cluster"
  default = "terracluster"
}

variable "k8s-master_count" {
  type        = string
  description = "Count masters in K8s cluster"
  default = "1"
}

variable "k8s-node_count" {
  type        = string
  description = "Count node in K8s cluster"
  default = "1"
}

variable "k8s-node-flavor-id" {
  type        = string
  description = "Node flavor"
  default = "Basic-1-2-20"
}

variable "k8s-node-disk-size" {
  type        = string
  description = "Node disk size"
  default = "20"
}

variable "k8s-node-disk-type" {
  type        = string
  description = "Node disk type"
  default = "hdd"
}
