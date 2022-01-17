provider "yandex" {
  version                  = "0.35"
  service_account_key_file = var.service-account-key-file
  cloud_id                 = var.cloud-id
  folder_id                = var.folder-id
  zone                     = var.zone-id
}

resource "yandex_storage_bucket" "otus-storage-bucket" {
  bucket        = var.bucket-name
  access_key    = var.access-key
  secret_key    = var.secret-key
  force_destroy = "true"
}
