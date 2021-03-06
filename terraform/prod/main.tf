provider "yandex" {
  service_account_key_file = var.service_account_key_file
  cloud_id                 = var.cloud_id
  folder_id                = var.folder_id
  zone                     = var.zone
}

data "yandex_compute_image" "app_image" {
  name = var.app_disk_image
}

data "yandex_compute_image" "db_image" {
  name = var.db_disk_image
}

module "app" {
  source           = "../modules/app"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  app_disk_image   = "${data.yandex_compute_image.app_image.id}"
  subnet_id        = var.subnet_id
  db_ipaddr        = module.db.internal_ip_address_db
  enable_provision = var.enable_provision
}
module "db" {
  source           = "../modules/db"
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  db_disk_image    = "${data.yandex_compute_image.db_image.id}"
  subnet_id        = var.subnet_id
  enable_provision = var.enable_provision
}
