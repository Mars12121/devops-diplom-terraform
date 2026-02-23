terraform {
  backend "s3" {
    endpoints = {
      s3 = "http://storage.yandexcloud.net"
    }
    bucket     = "cloud-sanchez12121-terraform-state"
    region     = "ru-central1"
    key        = "createBucket/terraform.tfstate"
    access_key = file("${path.module}/access_key")
    secret_key = file("${path.module}/secret_key")
 
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true # Необходимая опция Terraform для версии 1.6.1 и старше.
    skip_s3_checksum            = true # Необходимая опция при описании бэкенда для Terraform версии 1.6.3 и старше.
  }
}

resource "yandex_storage_bucket" "netology_bucket" {
  bucket = "cloud-sanchez12121-terraform-state"
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  folder_id = var.folder_id
  depends_on = [ yandex_iam_service_account_static_access_key.sa-static-key ]
}

resource "yandex_iam_service_account" "sa" {
  folder_id = var.folder_id
  name      = "sa-bucket"
}

resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
  folder_id = var.folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}

resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = yandex_iam_service_account.sa.id
  description        = "Static access key for object storage"
}

resource "local_file" "access_key" {
    content  = yandex_iam_service_account_static_access_key.sa-static-key.access_key
    filename = "access_key"
}

resource "local_file" "secret_key" {
    content  = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
    filename = "secret_key"
}