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
  auth_url         = var.auth_url
  tenant_id        = var.tenant_id
  user_domain_name = "users"
  region           = "RegionOne"
}

# # Сгенерирует пару ключей
# resource "openstack_compute_keypair_v2" "test-keypair" {
#  name = "my-keypair"
# }

# # Чтение существующих ресурсов
# data "openstack_networking_network_v2" "tech_network" {
#  name = "network_tech"
# }
#
# data "openstack_networking_subnet_v2" "tech_subnet" {
#  name = "subnet_9757"
# }
#
# data "openstack_networking_network_v2" "extnet" {
#   name = "ext-net"
# }

# создаем ключевую пару
resource "openstack_compute_keypair_v2" "terraform_keypair" {
  name       = "terraform-keypair"
  public_key = file("/home/fga/.ssh/id_rsa_mcs.pub")
}

# создаем сеть с именем "terraform-web-net"
resource "openstack_networking_network_v2" "terraform-net" {
  name           = "tech_network"
  admin_state_up = "true"
}

# создаем подсеть "terraform-subnet"
resource "openstack_networking_subnet_v2" "terraform-sbnt" {
  name       = "subnet_9757"
  network_id = openstack_networking_network_v2.terraform-net.id
  cidr       = "10.0.0.0/24"
  ip_version = 4
  dns_nameservers = [
    "8.8.8.8",
  "4.4.4.4"]
}

# роутер "terraform-router"
resource "openstack_networking_router_v2" "terraform-rt" {
  name           = "terraform-router"
  admin_state_up = "true"
  # id сети из которой добавляются внешние IP-адреса
  external_network_id = "298117ae-3fa4-4109-9e08-8be5602be5a2"
}

resource "openstack_networking_router_interface_v2" "terraform" {
  router_id = openstack_networking_router_v2.terraform-rt.id
  subnet_id = openstack_networking_subnet_v2.terraform-sbnt.id
}

//создаем группу безопасности, разрешающую входящие подключения по ssh/http
resource "openstack_compute_secgroup_v2" "ssh-and-http" {
  name        = "allow-ssh-and-http"
  description = "Allow ssh and http traffic from everywhere"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}

# выделяем внешний IP-адрес из пула "ext-net"
resource "openstack_compute_floatingip_v2" "vm_floating_ip" {
  pool = "ext-net"
}

resource "openstack_compute_instance_v2" "instance" {
  name       = var.vm-instance-name
  image_name = var.vm-image-name
  # id образа "Ubuntu-18.04-Standard"
  image_id = var.vm-image-id

  flavor_name       = var.vm-flavor-name
  availability_zone = "DP1"

  key_pair = openstack_compute_keypair_v2.terraform_keypair.name
  security_groups = [
  "${openstack_compute_secgroup_v2.ssh-and-http.name}"]

  network {
    uuid = openstack_networking_network_v2.terraform-net.id
  }

  # используем внешний cloud config
  user_data = file("cloudconfig.conf")

  block_device {
    # id образа "Ubuntu-20.04.1-202008"
    uuid                  = var.vm-image-id
    source_type           = "image"
    volume_size           = var.vm-volume-size
    boot_index            = 0
    destination_type      = "volume"
    delete_on_termination = true
  }

}

resource "openstack_compute_floatingip_associate_v2" "this" {
  floating_ip = openstack_compute_floatingip_v2.vm_floating_ip.address
  instance_id = openstack_compute_instance_v2.instance.id

  # исполняем inline-команды сразу после назначения белого IP
  provisioner "remote-exec" {

    # для этого подключаемся к инстансу по ssh
    connection {
      host        = openstack_compute_floatingip_v2.vm_floating_ip.address
      user        = "ubuntu"
      private_key = file("/home/fga/.ssh/id_rsa_mcs")
    }

    inline = [
      "echo ${openstack_compute_floatingip_v2.vm_floating_ip.address}",
      "cat /etc/hosts"
    ]
  }

  # В качестве альтернативы, можно скопировать локальный скрипт на виртуальную машину
  provisioner "file" {

    connection {
      host        = openstack_compute_floatingip_v2.vm_floating_ip.address
      user        = "ubuntu"
      private_key = file(var.ssh-key-path)
    }

    source      = "script.sh"
    destination = "/tmp/script.sh"
  }

  # и выполнить его
  provisioner "remote-exec" {

    connection {
      host        = openstack_compute_floatingip_v2.vm_floating_ip.address
      user        = "ubuntu"
      private_key = file(var.ssh-key-path)
    }

    # перед выполнением меняем атрибуты файла на исполняемые
    inline = [
      "chmod +x /tmp/script.sh",
      "/tmp/script.sh args",
    ]
  }
}


//На выходе возвращаем публичный IP-адрес виртуальной машины VM
output "web-instances" {
  value = join(",", openstack_compute_floatingip_associate_v2.this.*.floating_ip)
}
