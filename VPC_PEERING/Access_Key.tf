#login key pair for all instances

resource "aws_key_pair" "key_pair_for_all_instances" {
  key_name   = "SSH-Key-Pair"
  public_key = file(pathexpand("~/.ssh/aws_key.pub"))
}

#ip address for both instances to use for SSH access (terraform output)
output "my_public_ip" {
  value       = aws_instance.ec2_public_instance.public_ip
  description = "ip address for public ec2 instance "
}

output "private_ec2_ip" {
  value       = aws_instance.A_private_instance.private_ip
  description = "ip for private ec2 instance"
}

output "private_ec2_public_ip" {
  value       = aws_instance.B_private_instance.private_ip
  description = "public ip for private ec2 instance"
}