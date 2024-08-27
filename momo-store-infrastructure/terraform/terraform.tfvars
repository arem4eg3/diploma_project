########## SA ##########
sa-role         = ["admin"]
service_account = "tf-sa"

########## Network #########
vpc_network = "k8s-network"

vpc_subnet = {
  zone = "ru-central1-a"
  cidr = "10.5.0.0/24"
}

####### Bucket ##########
storage_bucket = {
  bucket = "momo-store-std-028-38"
  acl    = "public-read"
}

########## DNS ####################
dns_zone = {
  name   = "artem4eg-cc"
  zone   = "artem4eg.cc."
  public = true
}

########### K8S #########
auto_scale = {
  min     = 1
  max     = 3
  initial = 1
}

resources = {
  memory = 16
  cores  = 2
}
