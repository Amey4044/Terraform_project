terraform {
  required_providers {
    null = {
      source = "hashicorp/null"
    }
  }
}

variable "prebuilt_box_path" {
  default = "C:/Users/AMEY/Desktop/terraform-gcp-ansible/terraform/prebuilt_box"
}

# -------------------------
# Provision VMs with Vagrant
# -------------------------
resource "null_resource" "vagrant_multi_vm" {
  count = 4

  triggers = {
    vm_name = element(["lb", "web1", "web2", "db"], count.index)
  }

  provisioner "local-exec" {
    command     = "pushd ${var.prebuilt_box_path} & vagrant up ${element(["lb", "web1", "web2", "db"], count.index)} --provider=virtualbox --provision & popd"
    interpreter = ["cmd", "/c"]
  }
}

# -------------------------
# Configure VMs after boot
# -------------------------
resource "null_resource" "vm_configure" {
  count = 4

  triggers = {
    vm_name = element(["lb", "web1", "web2", "db"], count.index)
  }

  provisioner "local-exec" {
    command     = "pushd ${var.prebuilt_box_path} & vagrant ssh ${element(["lb", "web1", "web2", "db"], count.index)} -c \"echo VM ${element(["lb", "web1", "web2", "db"], count.index)} is up\" & popd"
    interpreter = ["cmd", "/c"]
  }
}

# -------------------------
# Output VM Info
# -------------------------
output "vagrant_vm_info" {
  value = <<EOT
Load Balancer:  http://localhost:8083  (SSH: localhost:2223)
Web1:           http://localhost:8084  (SSH: localhost:2224)
Web2:           http://localhost:8086  (SSH: localhost:2225)
Database:       SSH: localhost:2230
Private IPs:    LB=192.168.56.5, Web1=192.168.56.101, Web2=192.168.56.102, DB=192.168.56.20
EOT
}
