variable "vms" {
  type = list(object({
    name      = string
    ip        = string
    ssh_port  = number
    http_port = number
    role      = string
  }))
  default = [
    { name = "lb", ip = "192.168.56.5", ssh_port = 2223, http_port = 8083, role = "loadbalancer" },
    { name = "web1", ip = "192.168.56.101", ssh_port = 2224, http_port = 8084, role = "webserver" },
    { name = "web2", ip = "192.168.56.102", ssh_port = 2225, http_port = 8086, role = "webserver" },
    { name = "db", ip = "192.168.56.20", ssh_port = 2230, http_port = 0, role = "database" }
  ]
}

variable "prebuilt_box_path" {
  default = "C:/Users/AMEY/Desktop/terraform-gcp-ansible/prebuilt_box"
}
