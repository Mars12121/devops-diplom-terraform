resource "yandex_lb_network_load_balancer" "k8s-nlb" {
  name = "k8s-nlb"

  listener {
    name = "k8s-api"
    port = 6443
    target_port = 6443
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  # listener {
  #   name = "jenkins"
  #   port = 8080
  #   target_port = 8080
  #   external_address_spec {
  #     ip_version = "ipv4"
  #   }
  # }

  listener {
    name = "k8s-worker-nodes"
    port = 80
    target_port = 31936
    external_address_spec {
      ip_version = "ipv4"
    }
  }

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-nlb-target.id

    healthcheck {
      name = "k8s-api"
      healthy_threshold = 2
      interval = 60
      timeout = 61s
      unhealthy_threshold = 3
      http_options {
        port = 10256
        path = "/healthz"
      }
    }
  } 

  attached_target_group {
    target_group_id = yandex_lb_target_group.k8s-worker-nodes.id

    healthcheck {
      name = "k8s-nodes"
      healthy_threshold = 2
      interval = 60
      timeout = 61s
      unhealthy_threshold = 3
      http_options {
        port = 10256
        path = "/healthz"
      }
    }
  }
}

resource "yandex_lb_target_group" "k8s-nlb-target" {
  name      = "k8s-nlb-target"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.subnet_a.id
    address   = yandex_compute_instance.k8s-master-1.network_interface.0.ip_address
  }
}

resource "yandex_lb_target_group" "k8s-worker-nodes" {
  name      = "k8s-worker-nodes"
  region_id = "ru-central1"

  target {
    subnet_id = yandex_vpc_subnet.subnet_b.id
    address   = yandex_compute_instance.k8s-worker-1.network_interface.0.ip_address
  }

  target {
    subnet_id = yandex_vpc_subnet.subnet_d.id
    address   = yandex_compute_instance.k8s-worker-2.network_interface.0.ip_address
  }
}