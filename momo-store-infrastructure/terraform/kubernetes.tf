
resource "yandex_vpc_network" "main" {
  name = var.vpc_network
}

resource "yandex_vpc_subnet" "subnet-a" {
  zone           = var.vpc_subnet.zone
  network_id     = yandex_vpc_network.main.id
  v4_cidr_blocks = [var.vpc_subnet.cidr]
}

# ##########################

resource "yandex_kubernetes_cluster" "kubernetes" {
  name        = "clontroller"
  description = "mykubernetes"

  network_id = yandex_vpc_network.main.id

  master {
    version = var.cluster.version
    zonal {
      zone      = yandex_vpc_subnet.subnet-a.zone
      subnet_id = yandex_vpc_subnet.subnet-a.id
    }

    public_ip = var.cluster.public_ip

  }

  service_account_id      = yandex_iam_service_account.sa.id
  node_service_account_id = yandex_iam_service_account.sa.id
}


# ###################

resource "yandex_kubernetes_node_group" "node_group" {

  cluster_id = yandex_kubernetes_cluster.kubernetes.id

  scale_policy {
    auto_scale {
      min     = var.auto_scale.min
      max     = var.auto_scale.max
      initial = var.auto_scale.initial
    }
  }

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.subnet-a.id}"]
    }

    resources {
      memory = var.resources.memory
      cores  = var.resources.cores
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }

    container_runtime {
      type = "containerd"
    }

    metadata = {
      ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
    }
  }
}