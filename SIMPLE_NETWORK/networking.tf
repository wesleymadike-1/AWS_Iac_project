
# =====================================NETWORK_LAYER=======================================

resource "aws_vpc" "Data_engineering" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name       = "ABX-VPC"
    managed_by = "Terraform"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.Data_engineering.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "af-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name       = "ABX-Public-Subnet"
    managed_by = "Terraform"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.Data_engineering.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "af-south-1a"
  map_public_ip_on_launch = false

  tags = {
    Name       = "ABX-Private-Subnet"
    managed_by = "Terraform"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Data_engineering.id

  tags = {
    Name       = "ABX-Internet-Gateway"
    managed_by = "Terraform"
  }
}




# ==============================================================================================

# ==========================================ROUTE_LAYER========================================
# create a route table for the public subnet and associate it with the internet gateway
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.Data_engineering.id

  #update the public subnet route table to add a route to the internet gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name       = "ABX-Public-Route-Table"
    managed_by = "Terraform"
  }
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.Data_engineering.id

  #update the private subnet route table to add a route to the NAT gateway
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name       = "ABX-Private-Route-Table"
    managed_by = "Terraform"
  }
}

resource "aws_route_table_association" "public_route_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_route_table.id

}

resource "aws_route_table_association" "private_route_association" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_route_table.id
}
# ==============================================================================================