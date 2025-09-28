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
  value = "Web LB running: http://localhost:8082, Web IPs: 192.168.56.101-102, DB IP: 192.168.56.20"
}
