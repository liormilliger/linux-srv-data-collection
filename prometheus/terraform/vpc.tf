resource "aws_vpc" "liorm-nanox" {
  cidr_block = "10.1.0.0/16"

  tags = {
    Name = "liorm-nanox"
  }
}

resource "aws_subnet" "us-east-subnets" {
  vpc_id                  = aws_vpc.liorm-nanox.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = var.availability_zone
  tags = {
    Name = var.availability_zone
  }
}

resource "aws_internet_gateway" "liorm" {
  vpc_id = aws_vpc.liorm-nanox.id
  tags = {
    Name = aws_vpc.liorm-nanox.tags.Name
  }
}

resource "aws_route_table" "liorm" {
  vpc_id = aws_vpc.liorm-nanox.id

  tags = {
    Name = aws_vpc.liorm-nanox.tags.Name
  }
}

resource "aws_route" "default_route" {
  route_table_id         = aws_route_table.liorm.id
  destination_cidr_block = var.all_traffic_cidr_block
  gateway_id             = aws_internet_gateway.liorm.id
}

resource "aws_route_table_association" "liorm-pub" {
  subnet_id = aws_subnet.us-east-subnets.id
  route_table_id = aws_route_table.liorm.id
}
