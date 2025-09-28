terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = ">= 3.0.0"
    }
  }
  required_version = ">= 1.0"
}

provider "null" {}

resource "null_resource" "vagrant_multi_vm" {
  triggers = {
    vagrantfile_sha = filesha256("${path.module}/../Vagrantfile")
  }

  provisioner "local-exec" {
    command = "cd ${path.module}/.. && vagrant up --provision"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "cd ${path.module}/.. && vagrant destroy -f"
  }
}

output "vagrant_vm_info" {
  value = "Web VM running: http://localhost:8082, DB VM IP: 192.168.56.20"
}
