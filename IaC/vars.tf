variable "instance_count" {
  default = "2"
}

variable "instance_tags" {
  default = ["EC-1", "EC-2"]
}
variable "sub_PRIV"{
  default = ["SUB-PRIV"]
}
variable "sub_PUB"{
  default = ["SUB-PUB"]
}
variable "VPC_tags" {
  default = ["VPC-PUB", "VPC-PRIV"]
}
