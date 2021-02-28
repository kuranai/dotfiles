terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.24.1"
    }
  }
}

provider "hcloud" {
  # Configuration options
}

variable "region" {
  default = "nbg1"
}

data "hcloud_ssh_keys" "all_keys" {
}

resource "hcloud_server" "dev" {
  name     = "dev"
  image    = "ubuntu-20.04"
  server_type = "cpx31"
  location = var.region
  backups  = false
  ssh_keys = data.hcloud_ssh_keys.all_keys.ssh_keys.*.name

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_ed25519")
      timeout     = "2m"
      host        = hcloud_server.dev.ipv4_address
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
      host        = hcloud_server.dev.ipv4_address
    }
  }
}

output "public_ip" {
  value = hcloud_server.dev.ipv4_address
}

