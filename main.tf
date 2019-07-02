# Create ubuntu droplet with docker and docker compose installed.
# Run custom docker container image running Nginx and Bootstrap Blog Site from smcmrk/nginx-bootblog.

provider "digitalocean" {
    token = "${var.token}"
}

resource "digitalocean_droplet" "web" {
    name  = "dodocker2"
    image = "ubuntu-18-04-x64"
    region = "nyc1"
    size   = "512mb"
    ssh_keys = [
    "${var.ssh_keys}"
    ]

connection {
        user = "root"
        type = "ssh"
        private_key = "${file("~/.ssh/id_rsa_msa")}"
        timeout = "2m"
    }
    provisioner "remote-exec" {
        inline = [
          "sleep 25",
          "sudo apt-get update",
          "sudo apt-get -y install docker-engine",
          "sudo apt-get -y install docker-compose",
          "sudo docker run -itd -p 80:80 smcmrk/nginx-bootblog"

        ]
    }


}

output "ip" {
    value = "${digitalocean_droplet.web.ipv4_address}"
}