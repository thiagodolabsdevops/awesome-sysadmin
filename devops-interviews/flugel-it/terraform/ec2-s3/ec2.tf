resource "aws_instance" "runc-prod" {
  ami           = data.aws_ami.image.id
  instance_type = "t3a.small"
  subnet_id     = aws_subnet.prod.id
  vpc_security_group_ids      = [aws_security_group.ingress.id]
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash -ue

apt update -y
apt install -y git runc podman

EOF

  tags = {
    Name = "runc-prod"
    Environment = "Prod"
    InUse = "Yes"
  }
}

resource "aws_instance" "runc-test" {
  ami           = data.aws_ami.image.id
  instance_type = "t3a.small"
  subnet_id     = aws_subnet.test.id
  vpc_security_group_ids      = [aws_security_group.ingress.id]
  associate_public_ip_address = true
  user_data = <<EOF
#!/bin/bash -ue

apt update -y
apt install -y git runc podman

EOF

  tags = {
    Name = "runc-test"
    Environment = "Test"
    InUse = "No"
  }
}
