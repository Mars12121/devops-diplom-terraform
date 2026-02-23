resource "yandex_vpc_network" "diplom-vpc" {
    name        = "cloud-sanchez12121-vpc"
    description = "Diplom"
}

resource "yandex_vpc_subnet" "subnet_a" {
    name = "subnet_a"
    v4_cidr_blocks = ["10.1.0.0/24"]
    zone           = "ru-central1-a"
    network_id     = yandex_vpc_network.diplom-vpc.id
    depends_on = [ yandex_vpc_network.diplom-vpc ]
}

resource "yandex_vpc_subnet" "subnet_b" {
    name = "subnet_b"
    v4_cidr_blocks = ["10.2.0.0/24"]
    zone           = "ru-central1-b"
    network_id     = yandex_vpc_network.diplom-vpc.id
    depends_on = [ yandex_vpc_network.diplom-vpc ]
}

resource "yandex_vpc_subnet" "subnet_d" {
    name = "subnet_d"
    v4_cidr_blocks = ["10.3.0.0/24"]
    zone           = "ru-central1-d"
    network_id     = yandex_vpc_network.diplom-vpc.id
    depends_on = [ yandex_vpc_network.diplom-vpc ]
}

resource "yandex_vpc_subnet" "subnet_server" {
    name = "subnet_server"
    v4_cidr_blocks = ["10.4.0.0/24"]
    zone           = "ru-central1-b"
    network_id     = yandex_vpc_network.diplom-vpc.id
    depends_on = [ yandex_vpc_network.diplom-vpc ]
}

resource "yandex_vpc_address" "static_ip" {
  name = "static_ip"
  deletion_protection = true
  external_ipv4_address {
    zone_id = "ru-central1-b"
  }
}