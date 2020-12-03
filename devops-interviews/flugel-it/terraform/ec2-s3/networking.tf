
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "prod" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_subnet" "test" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block  = "0.0.0.0/0"
    gateway_id  = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "subnet-prod" {
  subnet_id      = aws_subnet.prod.id
  route_table_id = aws_route_table.main.id
}

resource "aws_route_table_association" "subnet-test" {
  subnet_id      = aws_subnet.test.id
  route_table_id = aws_route_table.main.id
}