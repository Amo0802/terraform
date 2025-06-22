resource "aws_vpc_peering_connection" "this" {
  vpc_id        = var.main_vpc_id
  peer_vpc_id   = var.secondary_vpc_id
  auto_accept   = true

  tags = merge({
    Name = "vpc-peering"
  }, var.tags)
}

resource "aws_route" "main_to_secondary" {
  count = length(var.main_route_table_ids)

  route_table_id            = var.main_route_table_ids[count.index]
  destination_cidr_block    = var.secondary_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}

resource "aws_route" "secondary_to_main" {
  count = length(var.secondary_route_table_ids)

  route_table_id            = var.secondary_route_table_ids[count.index]
  destination_cidr_block    = var.main_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.this.id
}
