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
  name         = "build"
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

 metadata = {
    ssh-keys = "test:${file("/my_test_key.pub")}"
  }

 

 provisioner "file" {
  source = "/opt/credentials.json"
  destination = "/home/test/credentials.json"

  connection {
    type = "ssh"
    user = "test"
    private_key = "${file("/my_test_key")}"
    agent = "false"
    host = "${google_compute_instance.default.network_interface.0.access_config.0.nat_ip}"
      }
  }


metadata_startup_script = "${file("startup.sh")}"


}

resource "google_compute_instance" "default1" {
  name         = "prod"
  machine_type = "e2-medium"
  zone         = "europe-west2-c"

  tags = ["foo", "bar"]
  
  depends_on = [google_compute_instance.default]

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

 metadata = {
    ssh-keys = "test:${file("/my_test_key.pub")}"
  }

 

 provisioner "file" {
  source = "/opt/credentials.json"
  destination = "/home/test/credentials.json"

  connection {
    type = "ssh"
    user = "test"
    private_key = "${file("/my_test_key")}"
    agent = "false"
    host = "${google_compute_instance.default1.network_interface.0.access_config.0.nat_ip}"
      }
  }


metadata_startup_script = "${file("startup_prod.sh")}"


}
 
  output "ip" {
  value = "${google_compute_instance.default1.network_interface.0.access_config.0.nat_ip}"
     }







