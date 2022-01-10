terraform {
  required_providers {
    yandex = {
      version = "~> 0.35"
    }
  }
}

provider "yandex" {
  token     = "AQAAAAAMZMhBAATuwamLlOgVyUoNoaKTbtzEo54"
  cloud_id  = "b1g1pmd1srv113b35h52"
  folder_id = "b1gcaact1bh30f0jmbkt"
  zone      = "ru-central1-a"
}

resource "yandex_compute_instance" "app" {
  name = "reddit-app"

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      # Указать id образа созданного в предыдущем домашем задании
      image_id = "fd8e66hr2jdlf8olspkh"
    }
  }

  network_interface {
    # Указан id подсети default-ru-central1-a
    subnet_id = "e9bi6t4kakg8oshloqtm"
    nat       = true
  }

  metadata = {
ssh-keys = "ubuntu:${file("~/.ssh/appuser.pub")}"
  }

  connection {
    type  = "ssh"
    host = yandex_compute_instance.app.network_interface.0.nat_ip_address
    user  = "ubuntu"
    agent = false
    # путь до приватного ключа
    private_key = file("~/.ssh/appuser")
  }

  provisioner "file" {
    source      = "files/puma.service"
    destination = "/tmp/puma.service"
  }

  provisioner "remote-exec" {
    script = "files/deploy.sh"
  }
}