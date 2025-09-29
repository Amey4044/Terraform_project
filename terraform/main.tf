terraform {
  required_providers {
    null = {
      source  = "hashicorp/null"
      version = "3.2.4"
    }
  }
}

# Step 1: Bring up all Vagrant VMs dynamically
resource "null_resource" "vagrant_up" {
  for_each = { for vm in var.vms : vm.name => vm }

  triggers = {
    vm_name = each.key
    vm_ip   = each.value.ip
  }

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "cd '${var.prebuilt_box_path}'; vagrant up ${each.key} --provider=virtualbox --provision"
  }
}

# Step 2: Generate dynamic Ansible inventory
resource "local_file" "ansible_inventory" {
  content = join("\n", flatten([
    ["[loadbalancer]"],
    [for vm in var.vms : "${vm.name} ansible_host=127.0.0.1 ansible_port=${vm.ssh_port} ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key" if vm.role == "loadbalancer"],
    ["\n[webservers]"],
    [for vm in var.vms : "${vm.name} ansible_host=127.0.0.1 ansible_port=${vm.ssh_port} ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key" if vm.role == "webserver"],
    ["\n[databases]"],
    [for vm in var.vms : "${vm.name} ansible_host=127.0.0.1 ansible_port=${vm.ssh_port} ansible_user=vagrant ansible_ssh_private_key_file=C:/Users/AMEY/.vagrant.d/insecure_private_key" if vm.role == "database"]
  ]))
  filename   = "${path.module}/../ansible/inventory.ini"
  depends_on = [null_resource.vagrant_up]
}

# Step 3: Run Ansible Playbook
resource "null_resource" "ansible_provision" {
  depends_on = [local_file.ansible_inventory]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command     = "cd '${path.module}/../ansible'; ansible-playbook -i inventory.ini playbook.yml"
  }
}

# Output
output "vm_info" {
  value = <<EOT
Load Balancer:  http://localhost:8083  (SSH: localhost:2223)
Web1:           http://localhost:8084  (SSH: localhost:2224)
Web2:           http://localhost:8086  (SSH: localhost:2225)
Database:       SSH: localhost:2230
Private IPs:    LB=192.168.56.5, Web1=192.168.56.101, Web2=192.168.56.102, DB=192.168.56.20
EOT
}
