resource "yandex_compute_instance" "k8s-master-1" {
  name        = "k8s-master-1"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kiogst6b2vj84enm8"
    }
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.subnet_a.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "administrator:${file("id_ed25519.pub")}"
  }
  depends_on = [ yandex_vpc_subnet.subnet_a ]
}

resource "yandex_compute_instance" "k8s-worker-1" {
  name        = "k8s-worker-1"
  platform_id = "standard-v1"
  zone        = "ru-central1-b"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kiogst6b2vj84enm8"
    }
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.subnet_b.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "administrator:${file("id_ed25519.pub")}"
  }
  depends_on = [ yandex_vpc_subnet.subnet_b ]
}

resource "yandex_compute_instance" "k8s-worker-2" {
  name        = "k8s-worker-2"
  platform_id = "standard-v4a"
  zone        = "ru-central1-d"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd8kiogst6b2vj84enm8"
    }
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.subnet_d.id
    nat       = true
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "administrator:${file("id_ed25519.pub")}"
  }
  depends_on = [ yandex_vpc_subnet.subnet_d ]
}

resource "yandex_compute_instance" "jenkins" {
  name        = "jenkins"
  platform_id = "standard-v4a"
  zone        = "ru-central1-b"

  resources {
    cores  = 4
    memory = 8
  }

  boot_disk {
    initialize_params {
      image_id = "fd8mgd3qkbv291qq429a"
    }
  }

  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.subnet_server.id
    nat       = true
    nat_ip_address = yandex_vpc_address.static_ip.external_ipv4_address[0].address
  }

  scheduling_policy {
    preemptible = true
  }

  metadata = {
    ssh-keys = "administrator:${file("id_ed25519.pub")}"
    user-data: "#cloud-config\nusers:\n  - name: administrator\n    groups: sudo\n    shell: /bin/bash\n    sudo: 'ALL=(ALL) NOPASSWD:ALL'\n    ssh_authorized_keys:\n      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAa/w4Mxz/3l+2UNS7XNhySmNV/s3ZYkoGj5xCoYM8yg admin@MacBook-Pro-admin.local"
  }
  depends_on = [ yandex_vpc_subnet.subnet_server ]
}