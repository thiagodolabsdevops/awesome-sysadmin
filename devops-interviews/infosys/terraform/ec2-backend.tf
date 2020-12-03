resource "aws_instance" "backend" {
  ami           = data.aws_ami.image.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.backend_subnet.id
  vpc_security_group_ids      = [aws_security_group.backend_sg.id]
  key_name = var.ssh_key_pair
#   user_data = <<EOF
# #!/bin/bash -ue

# hostnamectl set-hostname backend

# EOF

  tags = {
    Name = "backend"
    Owner = "devops"
  }
}

resource "aws_security_group" "backend_sg" {
  name        = "backend_sg"
  description = "Allow SSH inbound traffic from frontend instances"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_subnet.frontend_subnet.cidr_block]
  }
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}