variable "public_key_path" {
  description = "Path to the public key file"
  default     = "~/.ssh/liorm-tf-key_rsa.pub"
}

variable "user_data_path" {
  description = "Path to the user data script file"
  default     = "../prometheus/userdata.sh"
}

variable "ami_id" {
  description = "ID of the AMI to use for the instance"
  default     = "ami-07d9b9ddc6cd8dd30"
}

variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t3a.micro"
}

variable "availability_zone" {
  description = "Availability zone for the instance"
  default     = "us-east-1a"
}

variable "iam_instance_profile" {
  description = "IAM instance profile name"
  default     = "liorm-nanox"
}

variable "all_traffic_cidr_block" {
  description = "CIDR block to allow traffic from"
  default     = "0.0.0.0/0"
}

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