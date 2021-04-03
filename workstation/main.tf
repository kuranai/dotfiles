terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone            = "fr-par-1"
  region          = "fr-par"
}

locals {
  image   = "ubuntu_focal"
  type    = "DEV1-L"
}

resource "scaleway_instance_ip" "ip" {}

resource "scaleway_instance_server" "dev" {
  name     = "dev"
  image    = local.image
  type     = local.type
  #location = var.region
  #backups  = false
  ip_id    = scaleway_instance_ip.ip.id

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_ed25519")
      timeout     = "2m"
      host        = scaleway_instance_server.dev.public_ip
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh initialize",
    ]

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_ed25519")
      timeout     = "2m"
      host        = scaleway_instance_server.dev.public_ip
    }
  }
}

output "server" {
  sensitive = true
  value     = scaleway_instance_server.dev.public_ip
}