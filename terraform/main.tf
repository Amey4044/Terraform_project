variable "prebuilt_box_path" {
  default = "C:\\Users\\AMEY\\Desktop\\terraform-gcp-ansible\\terraform\\prebuilt_box"
}

locals {
  vms = ["lb", "web1", "web2", "db"]
}

# -------------------------
# Provision VMs with Vagrant in parallel
# -------------------------
resource "null_resource" "vagrant_multi_vm" {
  count = length(local.vms)

  triggers = {
    vm_name = local.vms[count.index]
  }

  provisioner "local-exec" {
    command     = "start /b cmd /c \"cd /d ${var.prebuilt_box_path} && vagrant up ${local.vms[count.index]} --provider=virtualbox --provision\""
    interpreter = ["cmd", "/c"]
  }
}

# -------------------------
# Configure VMs after boot in parallel
# -------------------------
resource "null_resource" "vm_configure" {
  count = length(local.vms)

  triggers = {
    vm_name = local.vms[count.index]
  }

  provisioner "local-exec" {
    command     = "start /b cmd /c \"cd /d ${var.prebuilt_box_path} && vagrant ssh ${local.vms[count.index]} -c \\\"echo VM ${local.vms[count.index]} is up\\\"\""
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
