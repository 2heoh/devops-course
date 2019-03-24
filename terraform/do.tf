variable "do_token" {}

provider "digitalocean" {
  token = "${var.do_token}"
}

resource "digitalocean_droplet" "blink1" {
  image  	= "ubuntu-18-04-x64"
  name   	= "blink-1"
  region 	= "nyc1"
  size   	= "s-1vcpu-1gb"
  tags		= ["hexlet"]
  ssh_keys 	= ["43:9c:31:3b:50:5c:bb:33:bf:eb:21:b5:05:f8:f3:6b"]
}

resource "digitalocean_droplet" "blink2" {
  image  	= "ubuntu-18-04-x64"
  name   	= "blink-2"
  region 	= "nyc1"
  size   	= "s-1vcpu-1gb"
  tags		= ["hexlet"]
  ssh_keys 	= ["43:9c:31:3b:50:5c:bb:33:bf:eb:21:b5:05:f8:f3:6b"]
}

resource "digitalocean_domain" "blink1" {
  name       = "blink1.sergeylobin.ru"
  ip_address = "${digitalocean_droplet.blink1.ipv4_address}"
}

resource "digitalocean_domain" "blink2" {
  name       = "blink2.sergeylobin.ru"
  ip_address = "${digitalocean_droplet.blink2.ipv4_address}"
}

resource "digitalocean_loadbalancer" "public" {
  name = "blink-loadbalancer"
  region = "nyc1"

  forwarding_rule {
    entry_port = 80
    entry_protocol = "http"

    target_port = 80
    target_protocol = "http"
  }

  healthcheck {
    port = 80
    protocol = "http"
    path = "/"
  }

  droplet_tag = "hexlet"
}

resource "digitalocean_domain" "blink" {
  name       = "blink.sergeylobin.ru"
  ip_address = "${digitalocean_loadbalancer.public.ip}"
}
