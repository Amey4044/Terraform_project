VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/jammy64"

  # Disable auto port mapping on NAT
  config.vm.network "forwarded_port", guest: 22, host: nil, auto_correct: false

  # Load Balancer
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.5"
    lb.vm.network "forwarded_port", guest: 80, host: 8083
    lb.vm.network "forwarded_port", guest: 22, host: 2223
  end

  # Web 1
  config.vm.define "web1" do |web|
    web.vm.hostname = "web1"
    web.vm.network "private_network", ip: "192.168.56.101"
    web.vm.network "forwarded_port", guest: 80, host: 8084
    web.vm.network "forwarded_port", guest: 22, host: 2224
  end

  # Web 2
  config.vm.define "web2" do |web|
    web.vm.hostname = "web2"
    web.vm.network "private_network", ip: "192.168.56.102"
    web.vm.network "forwarded_port", guest: 80, host: 8086   # change from 8085 → 8086
    web.vm.network "forwarded_port", guest: 22, host: 2225
  end

  # DB
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.network "forwarded_port", guest: 22, host: 2230
  end
end
