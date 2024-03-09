# variable "vpc_name" {
#   description = "Your vpc name"
#   type        = string
# }

# # variable "subnets" {
# #   description = "Subnets"
# #   type = list(string)
# # }

# variable "availability_zone" {
#   description = "Availability zone list"
#   type        = list(string)
# }

# variable "az_name" {
#   description = "Availability zone name list"
#   type        = list(string)
# }

variable KARMI_IP {
  description = "Karmi House IP"
  type = string
  default = "147.235.208.149/32"
}

variable HOME_IP {
  description = "Home IP"
  type = string
  default = "89.138.143.239/32"
}