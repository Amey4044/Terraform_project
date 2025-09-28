VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 1200  # 20 minutes

  # Remove default NAT SSH port (2222) to avoid conflicts
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natpf1", "delete", "ssh"]
  end

  # --- Load Balancer (Nginx reverse proxy) ---
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.5"
    lb.vm.network "forwarded_port", guest: 80, host: 8083
    lb.vm.network "forwarded_port", guest: 22, host: 2223
    lb.ssh.port = 2223

    lb.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y nginx
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
      sudo systemctl enable nginx
      sudo systemctl restart nginx
    SHELL
  end

  # --- Web 1 ---
  config.vm.define "web1" do |web|
    web.vm.hostname = "web1"
    web.vm.network "private_network", ip: "192.168.56.101"
    web.vm.network "forwarded_port", guest: 80, host: 8084
    web.vm.network "forwarded_port", guest: 22, host: 2224
    web.ssh.port = 2224

    web.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y nginx
      echo "<h1>Web Server 1</h1>" | sudo tee /var/www/html/index.html
      sudo systemctl enable nginx
      sudo systemctl start nginx
    SHELL
  end

  # --- Web 2 ---
  config.vm.define "web2" do |web|
    web.vm.hostname = "web2"
    web.vm.network "private_network", ip: "192.168.56.102"
    web.vm.network "forwarded_port", guest: 80, host: 8086
    web.vm.network "forwarded_port", guest: 22, host: 2225
    web.ssh.port = 2225

    web.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y nginx
      echo "<h1>Web Server 2</h1>" | sudo tee /var/www/html/index.html
      sudo systemctl enable nginx
      sudo systemctl start nginx
    SHELL
  end

  # --- Database ---
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.network "forwarded_port", guest: 22, host: 2230
    db.ssh.port = 2230

    db.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo apt-get install -y mysql-server
      sudo systemctl enable mysql
      sudo systemctl start mysql
      sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"
    SHELL
  end
end
