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

# Dynamic VM SSH ports mapping
locals {
  vm_ports = {
    lb   = 2223
    web1 = 2224
    web2 = 2225
    db   = 2230
  }
}

# Generate dynamic Ansible inventory
resource "local_file" "ansible_inventory" {
  content = <<EOT
[loadbalancer]
lb ansible_host=127.0.0.1 ansible_port=${local.vm_ports.lb} ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key

[webservers]
web1 ansible_host=127.0.0.1 ansible_port=${local.vm_ports.web1} ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key
web2 ansible_host=127.0.0.1 ansible_port=${local.vm_ports.web2} ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key

[databases]
db ansible_host=127.0.0.1 ansible_port=${local.vm_ports.db} ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key
EOT

  filename   = "../ansible/inventory.ini"
  depends_on = [null_resource.vagrant_up]
}

# Run Ansible playbook after VMs are up
resource "null_resource" "ansible_provision" {
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "Push-Location '../ansible'; ansible-playbook -i inventory.ini playbook.yml; Pop-Location"
  }
}

# Output VM Info
output "vm_info" {
  value = <<EOT
Load Balancer:  http://localhost:${local.vm_ports.lb}  (SSH: localhost:${local.vm_ports.lb})
Web1:           http://localhost:${local.vm_ports.web1}  (SSH: localhost:${local.vm_ports.web1})
Web2:           http://localhost:${local.vm_ports.web2}  (SSH: localhost:${local.vm_ports.web2})
Database:       SSH: localhost:${local.vm_ports.db}
Private IPs:    LB=192.168.56.5, Web1=192.168.56.101, Web2=192.168.56.102, DB=192.168.56.20
EOT
}
