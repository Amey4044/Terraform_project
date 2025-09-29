resource "null_resource" "generate_ansible_inventory" {
  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command     = <<EOT
      $inventory = @"
[loadbalancer]
lb ansible_host=192.168.56.5 ansible_user=vagrant

[webservers]
web1 ansible_host=192.168.56.101 ansible_user=vagrant
web2 ansible_host=192.168.56.102 ansible_user=vagrant

[database]
db ansible_host=192.168.56.20 ansible_user=vagrant
"@
      $inventory | Out-File -Encoding UTF8 ..\ansible\inventory.ini
EOT
    interpreter = ["PowerShell", "-Command"]
  }
}
