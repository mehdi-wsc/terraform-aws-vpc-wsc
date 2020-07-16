variable "group" {
  description = "the group they are working"
}
variable "map_ip" {
  default     = true
  description = " map ip"
  type        = bool
}
variable "env" {
  description = "the Environnement where you are (dev/prod for example)"
}
variable "region" {
  description = "Aws Region you are working in"
}
variable "vpc_cidr" {
  description = "Vpc IPV4 address with CIDR notation"
}
variable "public_subnet_count" {
  description = "number of public subnet"
}
variable "private_subnet_count" {
  description = "number of private subnet"
}
variable "cidr_block_private" {
  type = list(string)
}
variable "cidr_block_public" {
  type = list(string)
}

variable "owner" {
  description = "the owner of the account "
  default     = ""

}
variable "firstname" {
  description = "the firstname of builder"
  default     = ""

}
variable "lastname" {
  description = "the last name of builder"
  default     = ""

}


