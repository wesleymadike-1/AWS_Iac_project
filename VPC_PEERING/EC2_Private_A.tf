#==================EC2 INSTANCE==================#
resource "aws_instance" "A_private_instance" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.A_Private_Subnet.id
  vpc_security_group_ids = [aws_security_group.A_Private_SG.id]

  key_name = aws_key_pair.key_pair_for_all_instances.key_name #attach the key pair to the instance

  tags = {
    Name = "A-private-instance"
  }
}


resource "aws_security_group" "A_Private_SG" {
  vpc_id      = aws_vpc.A_VPC.id
  description = "Security group for A private EC2 instance"

  #inbound rule to allow SSH access from public ec2 instance
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.1.1.0/24"]
  }
  #allow ping from public ec2 instance    
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.1.1.0/24"]
  }

  egress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.2.2.0/24"]
  }

  egress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.2.2.0/24"]
  }

  tags = {
    Name       = "A-Private-SG"
    managed_by = "Terraform"
  }


}