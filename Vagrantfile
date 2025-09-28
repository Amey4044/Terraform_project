VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 1800  # 30 minutes for slower provisioning

  config.vm.provider "virtualbox" do |vb|
    vb.memory = 1024
    vb.cpus = 1
    vb.customize ["modifyvm", :id, "--natpf1", "delete", "ssh"]
  end

  # -------------------------
  # Common provision script
  # -------------------------
  common_provision = <<-SHELL
    sudo apt-get update -y
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y nginx curl git software-properties-common
  SHELL

  # --- Load Balancer ---
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.5"
    lb.vm.network "forwarded_port", guest: 80, host: 8083
    lb.vm.network "forwarded_port", guest: 22, host: 2223
    lb.ssh.port = 2223

    lb.vm.provision "shell", inline: <<-SHELL
      #{common_provision}
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

  # --- Web Servers ---
  ["web1","web2"].each_with_index do |web_name, idx|
    config.vm.define web_name do |web|
      ip = idx == 0 ? "192.168.56.101" : "192.168.56.102"
      port = idx == 0 ? 8084 : 8086
      ssh_port = idx == 0 ? 2224 : 2225

      web.vm.hostname = web_name
      web.vm.network "private_network", ip: ip
      web.vm.network "forwarded_port", guest: 80, host: port
      web.vm.network "forwarded_port", guest: 22, host: ssh_port
      web.ssh.port = ssh_port

      web.vm.provision "shell", inline: <<-SHELL
        #{common_provision}
        echo "<h1>Web Server #{idx+1}</h1>" | sudo tee /var/www/html/index.html
        sudo systemctl enable nginx
        sudo systemctl start nginx
      SHELL
    end
  end

  # --- Database ---
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.network "forwarded_port", guest: 22, host: 2230
    db.ssh.port = 2230

    db.vm.provision "shell", inline: <<-SHELL
      sudo apt-get update -y
      sudo DEBIAN_FRONTEND=noninteractive apt-get install -y mysql-server
      sudo systemctl enable mysql
      sudo systemctl start mysql
      sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'root'; FLUSH PRIVILEGES;"
    SHELL
  end
end
