resource "aws_key_pair" "liorm-pem-key" {
  key_name   = "liorm-tf-key"
  public_key = "${file("~/.ssh/liorm-tf-key_rsa.pub")}"
}

resource "aws_instance" "liorm-EC2-1a" {
  ami                    = "ami-07d9b9ddc6cd8dd30"
  instance_type          = "t3a.micro"
  key_name               = aws_key_pair.liorm-pem-key.id
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [ aws_security_group.liorm-SG.id ]
  subnet_id = aws_subnet.us-east-subnets.id
  iam_instance_profile = "liorm-nanox"

  user_data = file("../prometheus/userdata.sh")

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
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.KARMI_IP}", "${var.HOME_IP}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  depends_on = [
    aws_subnet.us-east-subnets
  ]

}
