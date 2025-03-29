#VPC
resource "aws_vpc" "main" {
  cidr_block = var.cidr
  tags = {
    Name="${var.env}-vpc"
    "kubernets.io/cluster/${var.env}-eks"="owned"
  }
}

## Peering
resource "aws_vpc_peering_connection" "main" {
  peer_vpc_id = aws_vpc.main.id
  vpc_id = var.default_vpc_id
  auto_accept = true
}
# route for peering
resource "aws_route" "default-vpc-peer-route" {
  route_table_id = var.default_vpc_rt
  destination_cidr_block = var.cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}
## subnets
resource "aws_subnet" "public" {
  count = length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.public_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name= "public-subnet-${split("-",var.availability_zones[count.index])[2]}"
    "kubernets.io/cluster/${var.env}-eks"="owned"
    "kubernets.io/role/elb"=1 # for public 1
  }
}
resource "aws_subnet" "web" {
  count = length(var.web_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.web_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name= "web-subnet-${split("-",var.availability_zones[count.index])[2]}"
    "kubernets.io/cluster/${var.env}-eks"="owned"
     
  }
}
resource "aws_subnet" "app" {
  count = length(var.app_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.app_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name= "app-subnet-${split("-",var.availability_zones[count.index])[2]}"
    "kubernets.io/cluster/${var.env}-eks"="owned"
     "kubernets.io/role/internal-elb"=1 # for private 1
  }
}
resource "aws_subnet" "db" {
  count = length(var.db_subnets)
  vpc_id = aws_vpc.main.id
  cidr_block = var.db_subnets[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name= "db-subnet-${split("-",var.availability_zones[count.index])[2]}"
    "kubernets.io/cluster/${var.env}-eks"="owned"
  }
}
# route tables
resource "aws_route_table" "public" {
  count=length(var.public_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block="0.0.0.0/0"
     gateway_id = aws_internet_gateway.main.id
  }

  route{
    cidr_block=var.default_vpc_cidr
    vpc_peering_connection_id=aws_vpc_peering_connection.main.id
  }
  tags = {
    Name="public-route-table-${split("-",var.availability_zones[count.index])[2]}"
  }
}
resource "aws_route_table" "db" {
  count=length(var.db_subnets)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block="0.0.0.0/0"
    nat_gateway_id= aws_nat_gateway.main.*.id[count.index]
  }
  route  {
    cidr_block=var.default_vpc_cidr
    vpc_peering_connection_id=aws_vpc_peering_connection.main.id
  }
  tags = {
    Name="db-route-table-${split("-",var.availability_zones[count.index])[2]}"
  }
}

resource "aws_route_table" "web" {
  count=length(var.web_subnets)
  vpc_id = aws_vpc.main.id
  route{
    cidr_block="0.0.0.0/0"
    nat_gateway_id= aws_nat_gateway.main.*.id[count.index]
  }
  route{
    cidr_block=var.default_vpc_cidr
    vpc_peering_connection_id=aws_vpc_peering_connection.main.id
  }
  tags = {
    Name="web-route-table-${split("-",var.availability_zones[count.index])[2]}"
  }
}
resource "aws_route_table" "app" {
  count=length(var.app_subnets)
  vpc_id = aws_vpc.main.id
   route {
    cidr_block="0.0.0.0/0"
    nat_gateway_id= aws_nat_gateway.main.*.id[count.index]
  }
  route{
    cidr_block=var.default_vpc_cidr
    vpc_peering_connection_id=aws_vpc_peering_connection.main.id
  }
  tags = {
    Name="app-route-table-${split("-",var.availability_zones[count.index])[2]}"
  }
}
# route table association
resource "aws_route_table_association" "public" {
  count = length(var.public_subnets)
  subnet_id = aws_subnet.public.*.id[count.index]
  route_table_id = aws_route_table.public.*.id[count.index]
}
resource "aws_route_table_association" "web" {
  count = length(var.web_subnets)
  subnet_id = aws_subnet.web.*.id[count.index]
  route_table_id = aws_route_table.web.*.id[count.index]
}
resource "aws_route_table_association" "app" {
  count = length(var.app_subnets)
  subnet_id = aws_subnet.app.*.id[count.index]
  route_table_id = aws_route_table.app.*.id[count.index]
}
resource "aws_route_table_association" "db" {
  count = length(var.db_subnets)
  subnet_id = aws_subnet.db.*.id[count.index]
  route_table_id = aws_route_table.db.*.id[count.index]
}

# internet gate way
resource "aws_internet_gateway" "main" {
  vpc_id=aws_vpc.main.id 
  tags={
    Name="${var.env}-igw"
  }
}
## Nat gateway
resource "aws_eip" "ngw-ip" {
  count=length(var.availability_zones)
  domain = "vpc"
  
}
resource "aws_nat_gateway" "main" {
  count = length(var.availability_zones)
  allocation_id = aws_eip.ngw-ip.*.id[count.index]
  subnet_id = aws_subnet.public.*.id[count.index]
  tags={
    Name="nat-gw-${split("-",var.availability_zones[count.index])[2]}"
  }
}


# vpc flow logs security
resource "aws_cloudwatch_log_group" "vpc-flow-logs" {
  name= "vpc-flow-logs-${var.env}"
  kms_key_id = var.kms_key_id
  tags={
    env= "dev"
    Name = "vpc-flow-logs-${var.env}"
  }
}
resource "aws_flow_log" "vpc-flow-logs" {
  iam_role_arn = aws_iam_role.vpc-flow-log-role.arn
  log_destination = aws_cloudwatch_log_group.vpc-flow-logs.arn
  traffic_type = "ALL"
  vpc_id = aws_vpc.main.id
}


# inline policy role for vpc log

resource "aws_iam_role" "vpc-flow-log-role" {
  name="${var.env}-vpc-flow-log-role"
  assume_role_policy = jsondecode({
    Version ="2012-10-17"
    Statement=[
        {
            "Effect": "Allow",
            "Principal": {
                "Service": [
                    "vpc-flow-logs.amazonaws.com"
                ]
            },
            "Action": [
                "sts:AssumeRole",
                
            ]
        }
    ]
  })
  inline_policy {
    name = "cloudwatch-logs"
    policy = jsondecode(
      {
          "Version": "2012-10-17",
          "Statement": [
        
            {
              "Effect": "Allow",
              "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
              ],
              "Resource": [
                "*"
              ]
            }
          ]
}
    )
  }
}
