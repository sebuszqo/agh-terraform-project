resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-Internet-Gateway"
  }
}

resource "aws_eip" "nat" {
  vpc = true
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[0].id

  tags = {
    Name = "${var.name}-NAT-Gateway"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-Public-Route-Table"
  }
}

resource "aws_route_table" "bastion" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.name}-Public-Subnet-Route-Table"
  }
}

resource "aws_route_table" "private_ec2" {
  vpc_id = aws_vpc.this.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.name}-Private-EC2-Route-Table"
  }
}

resource "aws_route_table" "private_rds" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.name}-Private-RDS-Route-Table"
  }
}


resource "aws_route_table_association" "public" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "bastion" {
  subnet_id      = aws_subnet.bastion.id
  route_table_id = aws_route_table.bastion.id
}

resource "aws_route_table_association" "private_ec2" {
  count          = length(aws_subnet.private_ec2)
  subnet_id      = aws_subnet.private_ec2[count.index].id
  route_table_id = aws_route_table.private_ec2.id
}

resource "aws_route_table_association" "private_rds" {
  count          = length(aws_subnet.private_rds)
  subnet_id      = aws_subnet.private_rds[count.index].id
  route_table_id = aws_route_table.private_rds.id
}
