terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
    local = { 
      source = "hashicorp/local" }
  }
  required_version = ">=1.8.4"
}

provider "yandex" {
  cloud_id  = file("cloud_id")
  folder_id = file("folder_id")
  zone      = var.default_zone
  service_account_key_file = file("authorized_key.json")
}