resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "${var.group}-${var.env}-vpc1"
  }
}


data "aws_availability_zones" "available" {
  state = "available"
}

###ELastic IP




resource "aws_eip" "nat_instance" {
  vpc = true
}

## Nat Getway


resource "aws_nat_gateway" "nat_instance" {
  allocation_id = aws_eip.nat_instance.id
  subnet_id=aws_subnet.public.1.id
}

#Internet Getway

resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "IGW"
  }
}


############# Public Subnet


resource "aws_subnet" "public" {
  count = var.public_subnet_count
  vpc_id     = aws_vpc.vpc.id
  cidr_block = element(var.cidr_block_public,count.index)
  availability_zone = element(data.aws_availability_zones.available.names,  count.index)
  tags = {
   Name = "${var.group}-${var.env}-vpc1-${element(data.aws_availability_zones.available.names, 1)}-${count.index}-public"
  }
}



############# Private subnet
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.vpc.id
  count = var.private_subnet_count

  cidr_block = element(var.cidr_block_private,count.index)

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
   Name = "${var.group}-${var.env}-vpc1-${element(data.aws_availability_zones.available.names, 2)}-${count.index}-private"
  }
}




# Creating Routing Table

resource "aws_route_table" "Routing_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW.id
  }

  tags = {
    Name = "Routing_table_IGW "
  }
}


resource "aws_route_table" "Routing_table_nat" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_instance.id
  }


  tags = {
    Name = "Routing_table_nat"
  }
}

#Association of routes

resource "aws_route_table_association" "table_1" {
  count=var.public_subnet_count
  subnet_id      = element(split(",", join(",", aws_subnet.public.*.id)), count.index)
  route_table_id = aws_route_table.Routing_table.id
}
resource "aws_route_table_association" "table_2" {
    count=var.private_subnet_count

  subnet_id      = element(split(",", join(",", aws_subnet.private.*.id)), count.index)
  route_table_id = aws_route_table.Routing_table_nat.id
}

