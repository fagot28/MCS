terraform {
  required_providers {
    mcs = {
      source  = "MailRuCloudSolutions/mcs"
      version = "~> 0.3.0"
    }
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

# Connect to mcs
provider "mcs" {
  username   = var.username
  password   = var.password
  project_id = var.tenant_id
  auth_url   = var.auth_url
}

# Connect to openstack
provider "openstack" {
  user_name        = var.username
  password         = var.password
  tenant_id        = var.tenant_id
  auth_url         = var.auth_url
  user_domain_name = "users"
  region           = "RegionOne"
}

data "mcs_kubernetes_clustertemplate" "clst1" {
  # версия кластера Kubernetes
  version = "1.20.4"
}

data "openstack_compute_flavor_v2" "k8s" {
  # тип виртуальной машины
  name = var.k8s-flavor-name
}

# описывает сам кластер
resource "mcs_kubernetes_cluster" "mycluster" {
  name                = var.k8s-instance-name
  cluster_template_id = data.mcs_kubernetes_clustertemplate.clst1.id
  subnet_id           = openstack_networking_subnet_v2.k8s-subnetwork.id
  network_id          = openstack_networking_network_v2.k8s.id
  master_flavor       = data.openstack_compute_flavor_v2.k8s.id
  keypair             = "terraform_keypair"
  availability_zone   = "MS1"
  floating_ip_enabled = true
  master_count        = var.k8s-master_count
  # volume_type         = var.k8s-type-disk
}

# описывает Node Group кластера
resource "mcs_kubernetes_node_group" "myng" {
  cluster_id  = mcs_kubernetes_cluster.mycluster.id
  node_count  = var.k8s-node_count
  flavor_id   = var.k8s-node-flavor-id
  volume_size = var.k8s-node-disk-size
  volume_type = var.k8s-node-disk-type
}

# создаем ключевую пару
resource "openstack_compute_keypair_v2" "terraform_keypair" {
  name       = "terraform-keypair"
  public_key = file(var.ssh-public-key-path)
}

# Создание новых ресурсов
resource "openstack_networking_network_v2" "k8s" {
  name           = "k8s-net"
  admin_state_up = true
}

resource "openstack_networking_subnet_v2" "k8s-subnetwork" {
  name            = "k8s-subnet"
  network_id      = openstack_networking_network_v2.k8s.id
  cidr            = "10.100.0.0/24"
  ip_version      = 4
  dns_nameservers = ["8.8.8.8", "8.8.4.4"]
}

data "openstack_networking_network_v2" "extnet" {
  name = "ext-net"
}

resource "openstack_networking_router_v2" "k8s" {
  name                = "k8s-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.extnet.id
}

resource "openstack_networking_router_interface_v2" "k8s" {
  router_id = openstack_networking_router_v2.k8s.id
  subnet_id = openstack_networking_subnet_v2.k8s-subnetwork.id
}
