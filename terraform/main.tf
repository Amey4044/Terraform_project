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
  value = <<EOT
Load Balancer:  http://localhost:8083  (SSH: localhost:2223)
Web1:           http://localhost:8084  (SSH: localhost:2223)
Web2:           http://localhost:8085  (SSH: localhost:2224)
Database:       SSH: localhost:2230
Private IPs:    LB=192.168.56.5, Web1=192.168.56.101, Web2=192.168.56.102, DB=192.168.56.20
EOT
}
