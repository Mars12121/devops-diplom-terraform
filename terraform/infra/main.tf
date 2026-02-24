terraform {
  backend "s3" {
    endpoints = {
      s3 = "http://storage.yandexcloud.net"
    }
    bucket     = "cloud-sanchez12121-terraform-state"
    region     = "ru-central1"
    key        = "infra/terraform.tfstate"
    access_key = file("access_key")
    secret_key = file("secret_key")
 
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
}