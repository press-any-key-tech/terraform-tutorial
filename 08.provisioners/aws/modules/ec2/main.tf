

################################################################################
# BASTION EC2
################################################################################



resource "aws_security_group" "bastion-sg" {
  description = "EC2 security group"
  name        = format("%s/%s", var.instance_name, "SG")

  tags = merge(
    { "Name" = format("%s/%s", var.instance_name, "sg") },
    var.tags
  )

  vpc_id = var.vpc_id

  dynamic "ingress" {
    for_each = var.instance_ingress
    content {
      cidr_blocks = ingress.value.cidr_blocks
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
    }
  }

  egress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
    from_port = 0
    protocol  = "-1"
    to_port   = 0
  }
}


resource "aws_instance" "ec2_instance" {

  ami               = var.instance_ami
  instance_type     = var.instance_type
  key_name          = var.ec2_key_name
  availability_zone = var.az
  subnet_id         = var.subnet_id
  tenancy           = "default"
  ebs_optimized     = false
  vpc_security_group_ids = [
    "${aws_security_group.bastion-sg.id}"
  ]

  user_data = try(var.user_data, null)

  source_dest_check = true

  root_block_device {
    volume_size           = 8
    volume_type           = "gp2"
    delete_on_termination = true
  }

  associate_public_ip_address          = "true"
  instance_initiated_shutdown_behavior = "stop"

  metadata_options {
    http_endpoint               = "enabled"
    http_put_response_hop_limit = "1"
    http_tokens                 = "optional"
    instance_metadata_tags      = "disabled"
  }

  monitoring = "false"

  private_dns_name_options {
    enable_resource_name_dns_a_record    = "true"
    enable_resource_name_dns_aaaa_record = "false"
    hostname_type                        = "ip-name"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum -y install httpd -y",
      "sudo service httpd start",
      "sudo bash -c 'echo \"Hello world from EC2 $(hostname -f)\" > /var/www/html/index.html'"
    ]
  }

  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ec2-user"
    private_key = file("provisioner-kp.pem")
    timeout     = "4m"
  }

  tags = merge(
    { "Name" = var.instance_name },
    var.tags,
  )

  depends_on = [
    aws_security_group.bastion-sg
  ]

}


