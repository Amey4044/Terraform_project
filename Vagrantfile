VAGRANT_API_VERSION = "2"

Vagrant.configure(VAGRANT_API_VERSION) do |config|
  config.vm.box = "ubuntu/jammy64"
  config.vm.boot_timeout = 600   # allow longer boot

  # Load Balancer VM
  config.vm.define "lb" do |lb|
    lb.vm.hostname = "lb"
    lb.vm.network "private_network", ip: "192.168.56.5"
    lb.vm.network "forwarded_port", guest: 80, host: 8081
    lb.vm.network "forwarded_port", guest: 22, host: 2221
  end

  # Web VMs
  (1..2).each do |i|
    config.vm.define "web#{i}" do |web|
      web.vm.hostname = "web#{i}"
      web.vm.network "private_network", ip: "192.168.56.10#{i}"
      web.vm.network "forwarded_port", guest: 80, host: 8081 + i   # web1 => 8082, web2 => 8083
      web.vm.network "forwarded_port", guest: 22, host: 2221 + i   # web1 => 2222, web2 => 2223
    end
  end

  # DB VM
  config.vm.define "db" do |db|
    db.vm.hostname = "db"
    db.vm.network "private_network", ip: "192.168.56.20"
    db.vm.network "forwarded_port", guest: 22, host: 2230
  end
end
