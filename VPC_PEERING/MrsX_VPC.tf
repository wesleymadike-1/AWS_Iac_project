resource "aws_vpc" "MrsX_VPC" {
    cidr_block = "10.2.0.0/16"
    tags = {
        Name = "MrsX-VPC"
    }
  
}
resource "aws_subnet" "MrsX_Private_Subnet" {
    vpc_id                  = aws_vpc.MrsX_VPC.id
    cidr_block              = "10.2.2.0/24"
    map_public_ip_on_launch = false
    availability_zone       = "af-south-1b"

    tags = {
        Name = "MrsX-Private-Subnet"
    }
}

#===============================================VPC PEERING========================================================
resource "aws_vpc_peering_connection_accepter" "MrsX_MrX_Peering"{
    vpc_peering_connection_id = aws_vpc_peering_connection.MrX_MrsX_Peering.id
    auto_accept               = true

    tags = {
        Name = "ACCEPTER-MRSX"
    }
}

#==================================ROUTE TABLES========================================================
resource "aws_route_table" "MrsX_Private_Route_Table" {
    vpc_id = aws_vpc.MrsX_VPC.id
    route {
        cidr_block = "10.1.0.0/16"
        vpc_peering_connection_id = aws_vpc_peering_connection.MrX_MrsX_Peering.id
    }
}

resource "aws_route_table_association" "MrsX_Private_Route_Table_Association" {
    subnet_id      = aws_subnet.MrsX_Private_Subnet.id
    route_table_id = aws_route_table.MrsX_Private_Route_Table.id
}   
