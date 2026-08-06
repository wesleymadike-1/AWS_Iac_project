resource "aws_vpc" "MrsX_VPC" {
    cidr_block = "10.2.0.0/16"
    tags = {
        Name = "MrsX-VPC"
    }
  
}

resource "aws_route_table" "MrsX_Public_Route_Table" {
    vpc_id = aws_vpc.MrsX_VPC.id 
    route {
        cidr_block = "
