resource "aws_vpc" "A_VPC" {
  cidr_block = "10.1.0.0/16"
  tags = {
    Name = "A-VPC"
  }

}

#attach an internet gateway to the VPC
resource "aws_internet_gateway" "A_IGW" {
  vpc_id = aws_vpc.A_VPC.id
  tags = {
    Name = "A-IGW"
  }
}

#the two vpcs we need for the left part , chech the imegi in the read me file 

resource "aws_subnet" "A_Public_Subnet" {
  vpc_id                  = aws_vpc.A_VPC.id
  cidr_block              = "10.1.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "af-south-1a"
  tags = {
    Name = "A-Public-Subnet"
  }
}

resource "aws_subnet" "A_Private_Subnet" {
  vpc_id                  = aws_vpc.A_VPC.id
  cidr_block              = "10.1.2.0/24"
  map_public_ip_on_launch = false
  availability_zone       = "af-south-1a"

  tags = {
    Name = "A-Private-Subnet"
  }
}


#==================================ROUTE TABLES========================================================
resource "aws_route_table" "A_Public_Route_Table" {
  vpc_id = aws_vpc.A_VPC.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.A_IGW.id
  }

  tags = {
    Name = "A-Public-Route-Table"
  }
}

resource "aws_route_table_association" "A_Public_Route_Table_Association" {
  subnet_id      = aws_subnet.A_Public_Subnet.id
  route_table_id = aws_route_table.A_Public_Route_Table.id
}

#route to the vpc peering connection
resource "aws_route_table" "A_Private_Route_Table" {
  vpc_id = aws_vpc.A_VPC.id
  route {
    cidr_block                = "10.2.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.A_Peering.id
  }

  tags = {
    Name = "A-Private-Route-Table"
  }
}
resource "aws_route_table_association" "A_Private_Route_Table_Association" {
  subnet_id      = aws_subnet.A_Private_Subnet.id
  route_table_id = aws_route_table.A_Private_Route_Table.id
}