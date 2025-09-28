terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

# Local-exec null resource to manage Vagrant VMs
resource "null_resource" "vagrant_multi_vm" {
  # Force recreation if Vagrantfile changes
  triggers = {
    vagrantfile_sha = filesha1("../Vagrantfile")
  }

  provisioner "local-exec" {
    command = "cd ./.. && vagrant up --provision"
  }
}

# Output VM info
output "vagrant_vm_info" {
  value = "Web LB running: http://localhost:8082, Web IPs: 192.168.56.101-102, DB IP: 192.168.56.20"
}
