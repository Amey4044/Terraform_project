VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/jammy64-devops.box"  # Prebuilt box
  config.vm.boot_timeout = 1200

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 2048
    vb.cpus = 2
  end

  # Load Balancer
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.5"
    lb.vm.network "forwarded_port", guest: 80, host: 8083
    lb.vm.provision "shell", inline: <<-SHELL
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
    SHELL
  end

  # Web1
  config.vm.define "web1" do |web|
    web.vm.hostname = "web1"
    web.vm.network "private_network", ip: "192.168.56.101"
    web.vm.provision "shell", inline: "echo '<h1>Web Server 1</h1>' | sudo tee /var/www/html/index.html; sudo systemctl start nginx"
  end

  # Web2
  config.vm.define "web2" do |web|
    web.vm.hostname = "web2"
    web.vm.network "private_network", ip: "192.168.56.102"
    web.vm.provision "shell", inline: "echo '<h1>Web Server 2</h1>' | sudo tee /var/www/html/index.html; sudo systemctl start nginx"
  end

  # Database
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.provision "shell", inline: <<-SHELL
      sudo systemctl start mysql
      sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"
    SHELL
  end
end
