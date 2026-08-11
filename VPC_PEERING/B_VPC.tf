resource "aws_vpc" "B_VPC" {
    cidr_block = "10.2.0.0/16"
    tags = {
        Name = "B-VPC"
    }
  
}
resource "aws_subnet" "B_Private_Subnet" {
    vpc_id                  = aws_vpc.B_VPC.id
    cidr_block              = "10.2.2.0/24"
    map_public_ip_on_launch = false
    availability_zone       = "af-south-1b"

    tags = {
        Name = "B-Private-Subnet"
    }
}



#==================================ROUTE TABLES========================================================
resource "aws_route_table" "B_Private_Route_Table" {
    vpc_id = aws_vpc.B_VPC.id
    route {
        cidr_block = "10.2.0.0/16"
        vpc_peering_connection_id = aws_vpc_peering_connection.B_MrX_Peering.id
    }

    tags = {
        Name = "B-Private-Route-Table"
    }
}

resource "aws_route_table_association" "B_Private_Route_Table_Association" {
    subnet_id      = aws_subnet.B_Private_Subnet.id
    route_table_id = aws_route_table.B_Private_Route_Table.id
}   
