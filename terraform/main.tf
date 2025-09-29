terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

variable "prebuilt_box_path" {
  default = "C:/Users/AMEY/Desktop/terraform-gcp-ansible/prebuilt_box"
}

# Bring up Vagrant VMs
resource "null_resource" "vagrant_up" {
  count = 4

  triggers = {
    vm_name = element(["lb", "web1", "web2", "db"], count.index)
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "Push-Location '${var.prebuilt_box_path}'; vagrant up ${self.triggers.vm_name} --provider=virtualbox --provision; Pop-Location"
  }
}

# Output VM Info
output "vm_info" {
  value = <<EOT
Load Balancer:  http://localhost:8083  (SSH: localhost:2223)
Web1:           http://localhost:8084  (SSH: localhost:2224)
Web2:           http://localhost:8086  (SSH: localhost:2225)
Database:       SSH: localhost:2230
Private IPs:    LB=192.168.56.5, Web1=192.168.56.101, Web2=192.168.56.102, DB=192.168.56.20
EOT
}
