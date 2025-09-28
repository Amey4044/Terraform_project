VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 1200  # 20 minutes timeout for slow boots

  # Remove default NAT SSH port (2222) globally to prevent conflicts
  config.vm.provider "virtualbox" do |vb|
    vb.customize ["modifyvm", :id, "--natpf1", "delete", "ssh"]
  end

  # Enable parallel boot for all VMs
  config.vm.define :all do |all|
    all.vm.boot_timeout = 1200
  end

  # -----------------------------
  # Load Balancer
  # -----------------------------
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.5"
    lb.vm.network "forwarded_port", guest: 80, host: 8083
    lb.vm.network "forwarded_port", guest: 22, host: 2223
    lb.ssh.port = 2223
    lb.vm.provider "virtualbox" do |vb|
      vb.name = "lb"
    end
  end

  # -----------------------------
  # Web 1
  # -----------------------------
  config.vm.define "web1" do |web|
    web.vm.hostname = "web1"
    web.vm.network "private_network", ip: "192.168.56.101"
    web.vm.network "forwarded_port", guest: 80, host: 8084
    web.vm.network "forwarded_port", guest: 22, host: 2224
    web.ssh.port = 2224
    web.vm.provider "virtualbox" do |vb|
      vb.name = "web1"
    end
  end

  # -----------------------------
  # Web 2
  # -----------------------------
  config.vm.define "web2" do |web|
    web.vm.hostname = "web2"
    web.vm.network "private_network", ip: "192.168.56.102"
    web.vm.network "forwarded_port", guest: 80, host: 8086
    web.vm.network "forwarded_port", guest: 22, host: 2225
    web.ssh.port = 2225
    web.vm.provider "virtualbox" do |vb|
      vb.name = "web2"
    end
  end

  # -----------------------------
  # DB
  # -----------------------------
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.network "forwarded_port", guest: 22, host: 2230
    db.ssh.port = 2230
    db.vm.provider "virtualbox" do |vb|
      vb.name = "db"
    end
  end
end
