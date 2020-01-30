provider "digitalocean" {
}

variable "region" {
  default = "fra1"
}

resource "digitalocean_droplet" "dev" {
  name     = "dev"
  image    = "ubuntu-19-04-x64"
  size     = "s-2vcpu-4gb"
  region   = var.region
  backups  = false
  ipv6     = true
  ssh_keys = [26345156] # doctl compute ssh-key list

  provisioner "file" {
    source      = "bootstrap.sh"
    destination = "/tmp/bootstrap.sh"

    connection {
      type        = "ssh"
      user        = "root"
      private_key = file("~/.ssh/id_rsa")
      timeout     = "2m"
      host        = digitalocean_droplet.dev.ipv4_address
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
      private_key = file("~/.ssh/id_rsa")
      timeout     = "2m"
      host        = digitalocean_droplet.dev.ipv4_address
    }
  }
}

resource "digitalocean_firewall" "dev" {
  name = "dev"

  droplet_ids = [digitalocean_droplet.dev.id]

  inbound_rule {
    protocol         = "tcp"
    port_range       = "22"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "60000-60010"
    source_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = ["0.0.0.0/0", "::/0"]
  }
}

output "public_ip" {
  value = digitalocean_droplet.dev.ipv4_address
}

