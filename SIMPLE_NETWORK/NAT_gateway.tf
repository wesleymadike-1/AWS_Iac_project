
resource "aws_eip" "nat_eip" {
  depends_on = [aws_internet_gateway.igw]
  domain     = "vpc"

  tags = {
    Name       = "ABX-NAT-EIP"
    managed_by = "Terraform"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on    = [aws_internet_gateway.igw]
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name       = "ABX-NAT-Gateway"
    managed_by = "Terraform"
  }

}