variable "vms" {
  default = [
    {
      name    = "lb"
      ip      = "192.168.56.5"
      type    = "loadbalancer"
      forward = [80, 8083]
    },
    {
      name    = "web1"
      ip      = "192.168.56.101"
      type    = "web"
      message = "<h1>Web Server 1</h1>"
      forward = [80, 8084]
    },
    {
      name    = "web2"
      ip      = "192.168.56.102"
      type    = "web"
      message = "<h1>Web Server 2</h1>"
      forward = [80, 8086]
    },
    {
      name    = "db"
      ip      = "192.168.56.20"
      type    = "db"
      forward = [22, 2230]
    }
  ]
}
