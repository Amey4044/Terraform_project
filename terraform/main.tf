provider "null" {}

resource "null_resource" "vagrant_multi_vm" {
  count = length(var.vms)

  provisioner "local-exec" {
    command = <<EOT
      cd prebuilt_box
      vagrant up ${var.vms[count.index].name} --provider=virtualbox
    EOT
  }
}

resource "null_resource" "vm_configure" {
  count = length(var.vms)

  depends_on = [null_resource.vagrant_multi_vm]

  provisioner "local-exec" {
    command = <<EOT
      vagrant ssh ${var.vms[count.index].name} -c "
        if [[ '${var.vms[count.index].type}' == 'loadbalancer' ]]; then
          sudo tee /etc/nginx/sites-available/loadbalancer <<EOF
upstream backend {
    server 192.168.56.101;
    server 192.168.56.102;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF
          sudo ln -sf /etc/nginx/sites-available/loadbalancer /etc/nginx/sites-enabled/loadbalancer
          sudo rm -f /etc/nginx/sites-enabled/default
          sudo systemctl restart nginx
        elif [[ '${var.vms[count.index].type}' == 'web' ]]; then
          echo '${var.vms[count.index].message}' | sudo tee /var/www/html/index.html
          sudo systemctl start nginx
        elif [[ '${var.vms[count.index].type}' == 'db' ]]; then
          sudo systemctl start mysql
          sudo mysql -e \"ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;\"
        fi
      "
    EOT
  }
}
