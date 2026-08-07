resource "aws_vpc" "MrX_VPC" {
    cidr_block = "10.1.0.0/16"
    tags = {
        Name = "MrX-VPC"
    }
  
}

#attach an internet gateway to the VPC
resource "aws_internet_gateway" "MrX_IGW" {
    vpc_id = aws_vpc.MrX_VPC.id
    tags = {
        Name = "MrX-IGW"
    }
}

#the two vpcs we need for the left part , chech the imegi in the read me file 

resource "aws_subnet" "MrX_Public_Subnet" {
    vpc_id                  = aws_vpc.MrX_VPC.id
    cidr_block              = "10.1.1.0/24"
    map_public_ip_on_launch = true 

    tags = {
        Name = "MrX-Public-Subnet"
    }
}

resource "aws_subnet" "MrX_Private_Subnet" {
    vpc_id                  = aws_vpc.MrX_VPC.id
    cidr_block              = "10.1.2.0/24"
    map_public_ip_on_launch = false

    tags = {
        Name = "MrX-Private-Subnet"
    }
}


#==================================ROUTE TABLES========================================================
resource "aws_route_table" "MrX_Public_Route_Table" {
    vpc_id = aws_vpc.MrX_VPC.id 
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.MrX_IGW.id
    }

    tags = {
        Name = "MrX-Public-Route-Table"
    }
}

resource "aws_route_table_association" "MrX_Public_Route_Table_Association" {
    subnet_id      = aws_subnet.MrX_Public_Subnet.id
    route_table_id = aws_route_table.MrX_Public_Route_Table.id
}

#route to the vpc peering connection
resource "aws_route_table" "MrX_Private_Route_Table" {
    vpc_id = aws_vpc.MrX_VPC.id 
    route { 
        cidr_block = "

    }
}
resource "aws_route_table_association" "MrX_Private_Route_Table_Association" {
    subnet_id      = aws_subnet.MrX_Private_Subnet.id
    route_table_id = aws_route_table.MrX_Private_Route_Table.id
}