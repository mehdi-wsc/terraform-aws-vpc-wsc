# terraform-aws-vpc
- Terraform module to provision a VPC with all elements(subnets ,internet getway,nat getway,routes tables).
- it's an opensource module under GPL license
## Features

## Usage
```
module "vpc-wsc" {
  source               = "mehdi-wsc/vpc-wsc/aws"
  version              = "0.0.3"
  group                = "group"
  env                  = "dev"
  region               = "eu-west-1"
  vpc_cidr             = "10.0.0.0/16"
  public_subnet_count  = "1"
  private_subnet_count = "1"
  cidr_block_private   = ["10.0.1.0/24"]
  cidr_block_public    = ["10.0.2.0/24"]

}
```
## Features:

- The module will create the following AWS resources:
    * Aws Subnet :  subnet is a logical subdivision of an IP network.
    * Internet Getway IGW :An Internet Gateway is a logical connection between an Amazon VPC and the Internet.
    * Nat Getway :A NAT getway configures to forward traffic to the Internet.
    * Route Tables: it's list of routes .


## Input Variables:

| name                 | description                                             | type         |
|----------------------|---------------------------------------------------------|--------------|
| group                | the group they are working.                             | string       |
| env                  | the Environnement where you are (dev/prod for example). | string       |
| region               | Aws Region u are working in.                            | string       |
| vpc_cidr             | Type your Vpc address with CIDR notation.               | string       |
| public_subnet_count  | Number of public subnets you would.                     | number       |
| private_subnet_count | Number of private subnets you would.                    | number       |
| cidr_block_public    | Type your Privates addresses for your subnets.          | list(string) |
| cidr_block_private   | Type your Public addresses for your subnets.            | list(string) |

## Output Variables:

| name               | description         |
|--------------------|---------------------|
| vpc_id             | VPC id              |
| public_subnet_ids  | Public Subnets IDs  |
| private_subnet_ids | Private Subnets IDs |

## License
```
                    GNU GENERAL PUBLIC LICENSE
                       Version 3, 29 June 2007

 Copyright (C) 2007 Free Software Foundation, Inc. <https://fsf.org/>
 Everyone is permitted to copy and distribute verbatim copies
 of this license document, but changing it is not allowed.

                            Preamble

  The GNU General Public License is a free, copyleft license for
software and other kinds of works.

  The licenses for most software and other practical works are designed
to take away your freedom to share and change the works.  By contrast,
the GNU General Public License is intended to guarantee your freedom to
share and change all versions of a program--to make sure it remains free
software for all its users.  We, the Free Software Foundation, use the
GNU General Public License for most of our software; it applies also to
any other work released this way by its authors.  You can apply it to
your programs, too.
```
