#login key pair for all instances

resource "aws_key_pair" "key_pair_for_all_instances" {
  key_name   = "SSH-Key-Pair"
  public_key = file(pathexpand("~/.ssh/aws_key.pub"))
}

#ip address for both instances to use for SSH access (terraform output)
output "public_EC2_ip" {
  value       = aws_instance.ec2_public_instance.public_ip
  description = "ip address for public ec2 instance "
}

output "A_private_ec2_ip" {
  value       = aws_instance.A_private_instance.private_ip
  description = "ip for private ec2 instance"
}

output "B_private_ec2_ip" {
  value       = aws_instance.B_private_instance.private_ip
  description = "public ip for private ec2 instance"
}