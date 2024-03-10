resource "aws_key_pair" "liorm-pem-key" {
  key_name   = "liorm-tf-key"
  public_key = file(var.public_key_path)
}

resource "aws_instance" "liorm-EC2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.liorm-pem-key.id
  availability_zone      = var.availability_zone
  vpc_security_group_ids = [ aws_security_group.liorm-SG.id ]
  subnet_id = aws_subnet.us-east-subnets.id
  iam_instance_profile = var.iam_instance_profile

  user_data = file(var.user_data_path)
  
  tags = {
    Name = "Prometheus-Server"
  }

  depends_on = [
    aws_security_group.liorm-SG
  ]
}

resource "aws_security_group" "liorm-SG" {
  name        = "liorm-SG"
  description = "Allow incoming HTTP traffic from your IP"
  vpc_id      = aws_vpc.liorm-nanox.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic_cidr_block]

  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic_cidr_block]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = [var.all_traffic_cidr_block]
  }

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "all"
    cidr_blocks = ["${var.KARMI_IP}", "${var.HOME_IP}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.all_traffic_cidr_block]
  }

  depends_on = [
    aws_subnet.us-east-subnets
  ]

}
