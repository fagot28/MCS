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
  username   = var.mcs-username
  password   = var.mcs-password
  project_id = var.mcs-project-id
  auth_url   = var.mcs-auth-url

}

# Connect to openstack
provider "openstack" {
    user_name        = var.mcs-username
    password         = var.mcs-password
    auth_url         = var.mcs-auth-url
    tenant_id        = var.mcs-project-id
    user_domain_name = "users"
    region           = "RegionOne"
}

data "mcs_kubernetes_clustertemplate" "ct1" {
  # версия кластера Kubernetes
  version = "1.20.4"
}

data "openstack_compute_flavor_v2" "k8s" {
  # тип виртуальной машины
  name = "Standard-2-4-40"
}

# Прочитает существующую ключевую пару, для доступа к атрибутам используйте `data.openstack_compute_keypair_v2.kp`
# data "openstack_compute_keypair_v2" "kp" {
#  name = "my-keypair"
# }

# Создание с существующей парой ключей
# resource "openstack_compute_keypair_v2" "test-keypair" {
#  name       = "my-keypair"
#  public_key = "ssh-rsa your_public_key"
# }

# Сгенерирует пару ключей
resource "openstack_compute_keypair_v2" "test-keypair" {
 name = "my-keypair"
}

# описывает Node Group кластера. У одного кластера может быть много Node Groups, но в крайнем случае может и не быть ни одной Node Group
resource "mcs_kubernetes_node_group" "myng" {
  cluster_id = mcs_kubernetes_cluster.mycluster.id
  node_count = 1
}

# Чтение существующих ресурсов
# data "openstack_networking_network_v2" "k8s_network" {
#  name = "your_network_name"
# }
#
# data "openstack_networking_subnet_v2" "k8s_subnet" {
#  name = "your_subnet_name"
# }

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

# описывает сам кластер
resource "mcs_kubernetes_cluster" "mycluster" {
  name                = "terracluster"
  cluster_template_id = data.mcs_kubernetes_clustertemplate.ct1.id
  subnet_id           = "k8s-subnet"
  network_id          = "k8s-net"
  master_flavor       = data.openstack_compute_flavor_v2.k8s.id
  keypair             = "my-keypair"
  availability_zone   = "MS1"
  floating_ip_enabled = true
}
