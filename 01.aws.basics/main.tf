

resource "aws_instance" "example" {
  ami           = var.instance_image
  instance_type = var.instance_type
  key_name      = aws_key_pair.example.key_name

  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum -y install httpd -y
sudo service httpd start
sudo bash -c 'echo "Hello world from EC2 $(hostname -f)" > /var/www/html/index.html'
EOF

  tags = {
    Name = join("-", [var.prefix, var.instance_name])
  }
  vpc_security_group_ids = [aws_security_group.instance.id]
}

resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "example" {
  key_name   = join("-", [var.prefix, var.instance_key_name])
  public_key = tls_private_key.example.public_key_openssh
}


resource "aws_security_group" "instance" {
  name = join("-", [var.prefix, "terraform-tcp-security-group"])

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
