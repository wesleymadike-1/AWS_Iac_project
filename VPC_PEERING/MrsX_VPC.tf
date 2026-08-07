resource "aws_vpc" "MrsX_VPC" {
    cidr_block = "10.2.0.0/16"
    tags = {
        Name = "MrsX-VPC"
    }
  
}
#update the route rable to vpc peering connection
resource "aws_route_table" "MrsX_Public_Route_Table" {
    vpc_id = aws_vpc.MrsX_VPC.id 
    route {
        cidr_block = "

resource "aws_route_table_association" "MrsX_Public_Route_Table_Association" {
    subnet_id      = aws_subnet.MrsX_Public_Subnet.id
    route_table_id = aws_route_table.MrsX_Public_Route_Table.id
}