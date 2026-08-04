#==================SECURITY GROUP==================#
resource "aws_security_group" "ec2_security_group" {
  vpc_id      = aws_vpc.Data_engineering.id
  description = "Security group for EC2 instances"

  #inbound rule to allow SSH access from public subnet
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }
  # allow HTTP access from public subnet
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["10.0.1.0/24"]
  }

  egress {
    description = "Allow outbound traffic only to public subnets"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name       = "ABX-EC2-private-SG"
    managed_by = "Terraform"
  }

}

#==================EC2 INSTANCE==================#
resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.ubuntu_2604.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.private_subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = aws_key_pair.key_pair_for_all_instances.key_name #attach the key pair to the instance

  user_data = templatefile("${path.module}/templates/user_data_ec2.tftpl", {
    server_title = "Deployed via Terraform: NGINX on Ubuntu 26.04"
  })

  tags = {
    Name = "NGINX Web Server"
  }
}



