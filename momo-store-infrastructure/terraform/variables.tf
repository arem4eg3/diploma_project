variable "dns_zone" {
  description = "DNS zone"
  type = object({
    name   = string
    zone   = string
    public = bool
  })

  default = {
    name   = "artem4eg-cc"
    zone   = "artem4eg.cc."
    public = true
  }
}

variable "folder_id" {
  description = "Yandex cloud folder ID"
  type        = string
}


variable "storage_bucket" {
  description = "Bucket params"
  type = object({
    bucket = string
    acl    = string
  })
  default = {
    bucket = "momo-store-std-028-38"
    acl    = "private"

  }
}

variable "service_account" {
  description = "Service Account"
  type        = string
  default     = "tf-sa"
}

variable "sa-role" {
  description = "Service Account role"
  type        = set(string)
  default     = ["editor"]
}

variable "vpc_network" {
  type    = string
  default = "my-network"
}

variable "vpc_subnet" {
  description = "VPC subnet params"
  type = object({
    zone = string
    cidr = string
  })

  default = {
    zone = "ru-central1-a"
    cidr = "10.5.0.0/24"
  }
}

variable "cluster" {
  description = "K8s cluster params"
  type = object({
    version   = string
    public_ip = bool
  })

  default = {
    version   = "1.27"
    public_ip = true
  }
}

variable "auto_scale" {
  description = "Node group auto-scale"
  type = object({
    min     = number
    max     = number
    initial = number
  })

  default = {
    min     = 1
    max     = 3
    initial = 1
  }
}
variable "resources" {
  description = "Node group resources"
  type = object({
    memory = number
    cores  = number
  })

  default = {
    memory = 2
    cores  = 2
  }
}
