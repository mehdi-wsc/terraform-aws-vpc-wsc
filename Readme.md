# Terraform Module
One of the best practise to create reused code is to utilize modules , terraform offers this way to avoid repitition.<br>
So I will introduce my VPC Module ,it's structure ,the inputs and the outputs.
<br>
- Structure of the module is simple , I avail this simplicity and I put just three files : <br>
1. variables.tf : Contains variables necessary to launch the module, they are :
    - group : the group they are working.
    - env   : the Environnement where you are (dev/prod for example).
    - region : Aws Region u are working in.
    - vpc_cidr : Type your Vpc address with CIDR notation.
    - public_subnet_count : Number of public subnets you would.
    - private_subnet_count : NUmber of private subnets you would.

    - cidr_block_private : Type your Public addresses for your subnets.
    - cidr_block_public : Type your Privates addresses for your subnets.

2. Main.tf : Contains configurations to create  elements of VPC decribed below :

    - Subnet :  subnet is a logical subdivision of an IP network.

    - Internet Getway :An Internet Gateway is a logical connection between an Amazon VPC and the Internet.

    - Nat Getway :A NAT getway configures to forward traffic to the Internet.

    - Route Tables: it's list of routes.

3. Output.tf : it includes sunets output.
