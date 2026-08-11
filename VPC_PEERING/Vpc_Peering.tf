#===============================================VPC PEERING A-to-B========================================================
resource "aws_vpc_peering_connection" "A_Peering"{
    vpc_id        = aws_vpc.A_VPC.id
    peer_vpc_id   = aws_vpc.B_VPC.id
    auto_accept   = true

    tags = {
        Name = "REQUESTER-MRX"
    }
}

#===============================================VPC PEERING B-to-A========================================================
resource "aws_vpc_peering_connection_accepter" "B_Peering"{
    vpc_peering_connection_id = aws_vpc_peering_connection.A_Peering.id
    auto_accept               = true

    tags = {
        Name = "ACCEPTER-B"
    }
}