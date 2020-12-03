resource "aws_instance" "frontend" {
  ami           = data.aws_ami.image.id
  instance_type = var.instance_type
  subnet_id     = aws_subnet.frontend_subnet.id
  vpc_security_group_ids      = [aws_security_group.frontend_sg.id]
  associate_public_ip_address = true
  key_name = var.ssh_key_pair
  user_data = <<EOF
#!/bin/bash -ue

yum update -y

yum install -y git podman runc

git clone https://github.com/tmagalhaes1985/infosys-assignment.git
cd infosys-assignment/scripts/nginx/ && docker image build -t infosys-assignment .
podman run --name nginx -d -p 80:80 infosys-assignment

EOF

  tags = {
    Name = "frontend"
    Owner = "devops"
  }
}

resource "aws_security_group" "frontend_sg" {
  name        = "frontend_sg"
  description = "Allow HTTP and HTTPS traffic from everywhere"
  vpc_id      = aws_vpc.main.id
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
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}