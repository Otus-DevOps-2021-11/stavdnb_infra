terraform {
  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "test-01234511"
    region     = "ru-central1-a"
    key        = "terraform.tfstate"
    access_key = "ZM7-RXh7PTf9tAwKXFc3"
    secret_key = "dToQOb8uxdAkZZNZdGfU7azeTUNqX9zXqOvgCwpb"

    skip_region_validation      = true
    skip_credentials_validation = true
  }
}