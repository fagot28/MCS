#===========================#
# VMware vCenter connection #
#===========================#

variable "mcs-username" {
  type        = string
  description = "MCS user name"
}

variable "mcs-password" {
  type        = string
  description = "MCS password"
  sensitive   = true
}

variable "mcs-project-id" {
  type        = string
  description = "MCS project id"
}

variable "mcs-auth-url" {
  type        = string
  description = "MCS auth_url"
}

variable "mcs-template-folder" {
  type        = string
  description = "Template folder"
  default = "terraform-template"
}

#================================#
# MCS virtual machine #
#================================#

variable "vm-master-count" {
  type        = string
  description = "Number of VM"
  default     =  1
}

variable "vm-worker-count" {
  type        = string
  description = "Number of VM"
  default     =  1
}

variable "vm-name-prefix" {
  type        = string
  description = "Name of VM prefix"
  default     =  "k8s"
}

variable "vm-network" {
  type        = string
  description = "Network used for the mcs virtual machines"
  default     = "VM Network"
}

variable "vm-linked-clone" {
  type        = string
  description = "Use linked clone to create the mcs virtual machine from the template (true/false). If you would like to use the linked clone feature, your template need to have one and only one snapshot"
  default     = "false"
}

variable "vm-cpu" {
  type        = string
  description = "Number of vCPU for the mcs virtual machines"
  default     = "2"
}

variable "vm-ram" {
  type        = string
  description = "Amount of RAM for the mcs virtual machines (example: 2048)"
  default     = "1024"
}

variable "vm-hdd-master" {
  type        = string
  description = "Disk size HDD for the mcs virtual machines (example: 25)"
  default     = "16"
}

variable "vm-hdd" {
  type        = string
  description = "Disk size HDD for the mcs virtual machines (example: 25)"
  default     = "16"
}

variable "vm-scsi" {
  type        = string
  description = "The common type of all SCSI controllers on this virtual machine."
  default     = "pvscsi"
}

variable "vm-master-name" {
  type        = string
  description = "The name of the mcs virtual machines and the hostname of the machine"
  default     = "master"
}

variable "vm-worker-name" {
  type        = string
  description = "The name of the mcs virtual machines and the hostname of the machine"
  default     = "worker"
}

variable "vm-guest-id" {
  type        = string
  description = "The ID of virtual machines operating system"
}

variable "vm-template-name" {
  type        = string
  description = "The template to clone to create the VM"
}

variable "vm-master-template-name" {
  type        = string
  description = "The template to clone to create the VM"
}

variable "vm-domain" {
  type        = string
  description = "Linux virtual machine domain name for the machine. This, along with host_name, make up the FQDN of the virtual machine"
  default     = ""
}
