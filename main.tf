resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name           = "${var.group}-${var.env}-vpc1-vpc"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}

# Public Subnet

resource "aws_subnet" "public" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = element(var.cidr_block_public, count.index)
  availability_zone       = element(data.aws_availability_zones.available.names, count.index)
  map_public_ip_on_launch = var.map_ip
  tags = {
    Name           = "${var.group}-${var.env}-vpc-${element(data.aws_availability_zones.available.names, 1)}-${count.index}-nginx-public"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"
  }

}

# Private subnet
resource "aws_subnet" "private" {
  vpc_id = aws_vpc.vpc.id
  count  = var.private_subnet_count

  cidr_block = element(var.cidr_block_private, count.index)

  availability_zone = element(data.aws_availability_zones.available.names, count.index)

  tags = {
    Name           = "${var.group}-${var.env}-vpc-${element(data.aws_availability_zones.available.names, 2)}-${count.index}-nginx-private"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"
  }
}

#ELastic IP

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name           = "${var.group}-${var.env}-nginx-eip"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"
  }
}

# Nat Getway

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public.0.id
  tags = {
    Name           = "${var.group}-${var.env}-nginx-ngw"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"
  }
}

#Internet Getway

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name           = "${var.group}-${var.env}-vpc1-igw"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"
  }
}
# Creating Routing Table

resource "aws_route_table" "table-1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name           = "${var.group}-${var.env}-bastion-public-rt"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"
  }
}

resource "aws_route_table" "table-2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name           = "${var.group}-${var.env}-ngiinx-private-rt"
    owner          = var.owner
    account        = terraform.workspace
    createdBy      = var.firstname
    taggingVersion = "1.0.0"

  }
}

#Association of routes

resource "aws_route_table_association" "table_1" {
  count          = var.public_subnet_count
  subnet_id      = element(split(",", join(",", aws_subnet.public.*.id)), count.index)
  route_table_id = aws_route_table.table-1.id
}
resource "aws_route_table_association" "table_2" {
  count = var.private_subnet_count

  subnet_id      = element(split(",", join(",", aws_subnet.private.*.id)), count.index)
  route_table_id = aws_route_table.table-2.id
}
