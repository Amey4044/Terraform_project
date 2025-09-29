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

# Generate dynamic Ansible inventory
resource "local_file" "ansible_inventory" {
  content = <<EOT
[loadbalancer]
lb ansible_host=127.0.0.1 ansible_port=2223 ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key

[webservers]
web1 ansible_host=127.0.0.1 ansible_port=2224 ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key
web2 ansible_host=127.0.0.1 ansible_port=2225 ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key

[databases]
db ansible_host=127.0.0.1 ansible_port=2230 ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key
EOT

  filename   = "../ansible/inventory.ini"
  depends_on = [null_resource.vagrant_up]
}

# Run Ansible playbook after VMs are up
resource "null_resource" "ansible_provision" {
  depends_on = [null_resource.vagrant_up, local_file.ansible_inventory]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "Push-Location '../ansible'; ansible-playbook -i inventory.ini playbook.yml; Pop-Location"
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
