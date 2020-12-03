# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

# Subnets
resource "aws_subnet" "frontend_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "backend_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}

# Internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

# Route Table
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.main.id
  }
}

# Route Table association to frontend_subnet subnet
resource "aws_route_table_association" "frontend_subnet" {
  subnet_id      = aws_subnet.frontend_subnet.id
  route_table_id = aws_route_table.main.id
}

# Route Table association to backend_subnet subnet
resource "aws_route_table_association" "backend_subnet" {
  subnet_id      = aws_subnet.backend_subnet.id
  route_table_id = aws_route_table.main.id
}