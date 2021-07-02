terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.74.0"
    }
  }
}

provider "google" {
  # Configuration options

credentials = "${file("/opt/credentials.json")}"
project = "principal-rope-318517"
region = "europe-west2"
zone   = "europe-west2-c"
}

resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-medium"
  zone         = "europe-west2-c"

  tags = ["foo", "bar"]

  boot_disk {
    initialize_params {
      image = "ubuntu-2004-focal-v20210623"
    }
  }

  
  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

# metadata = {
#    ssh-keys = "test:${file("/home/test/.ssh/id_rsa.pub")}"
#  }

 metadata_startup_script = "${file("startup.sh")}"

 provisioner "file" {
  source = "/root/111"
  destination = "/tmp/111"

  connection {
    type = "ssh"
    user = "test"
    private_key = "${file("/home/test/.ssh/id_rsa")}"
    agent = "false"
    host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
      }
  }
}
 
  output "ip" {
  value = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
     }



