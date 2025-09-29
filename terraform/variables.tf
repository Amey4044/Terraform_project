variable "prebuilt_box_path" {
  default = "C:/Users/AMEY/Desktop/terraform-gcp-ansible/prebuilt_box"
}

variable "vms" {
  default = [
    { name = "lb", ip = "192.168.56.5", ports = [8083, 2223] },
    { name = "web1", ip = "192.168.56.101", ports = [8084, 2224] },
    { name = "web2", ip = "192.168.56.102", ports = [8086, 2225] },
    { name = "db", ip = "192.168.56.20", ports = [2230] }
  ]
}
