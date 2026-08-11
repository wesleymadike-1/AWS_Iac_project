#==================EC2 INSTANCE==================#
resource "aws_instance" "ec2_public_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.A_Public_Subnet.id
  vpc_security_group_ids = [aws_security_group.ec2_public_security_group.id]

  key_name = aws_key_pair.key_pair_for_all_instances.key_name #attach the key pair to the instance

  tags = {
    Name = "login host"
  }
}

data "http" "my_public_ip" {
  url = "https://checkip.amazonaws.com"
}


resource "aws_security_group" "ec2_public_security_group" {
  vpc_id      = aws_vpc.A_VPC.id
  description = "Security group for EC2 instances"

  #inbound rule to allow SSH access from my ip address
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${chomp(data.http.my_public_ip.response_body)}/32"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.2.0/24"]
  }
  #ping rule to private subnet of A VPC
  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.1.2.0/24"]
  }


  #allow all outbound traffic to the internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  tags = {
    Name       = "A-EC2-public-SG"
    managed_by = "Terraform"
  }
}
