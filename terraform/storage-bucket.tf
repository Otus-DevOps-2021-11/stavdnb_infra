provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}
                                 #account_id
resource "yandex_storage_bucket" "aje6jl90av4eks8dijeo" {
  bucket        = "test-01234511"
  access_key    = "I9SiLnOKwjItyNB0tTrM" #access_key
  secret_key    = "7uogZEgN6qrLpeauq4ER5NBKXRpppRVtJNgBHBPF" #secret_key
  force_destroy = "true"
}