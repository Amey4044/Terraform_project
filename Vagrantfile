VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/jammy64"

  # Load Balancer VM
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.5"
    lb.vm.network "forwarded_port", guest: 80, host: 8083
    lb.vm.network "forwarded_port", guest: 22, host: 2223   # SSH unique
  end

  # Web VMs
  config.vm.define "web1" do |web|
    web.vm.hostname = "web1"
    web.vm.network "private_network", ip: "192.168.56.101"
    web.vm.network "forwarded_port", guest: 80, host: 8084
    web.vm.network "forwarded_port", guest: 22, host: 2224   # SSH unique
  end

  config.vm.define "web2" do |web|
    web.vm.hostname = "web2"
    web.vm.network "private_network", ip: "192.168.56.102"
    web.vm.network "forwarded_port", guest: 80, host: 8085
    web.vm.network "forwarded_port", guest: 22, host: 2225   # SSH unique
  end

  # DB VM
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.network "forwarded_port", guest: 22, host: 2230    # SSH unique
  end
end
