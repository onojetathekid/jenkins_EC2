# Elastic IP for NAT Gateway
# NAT gateway needs a static public IP address
resource "aws_eip" "nat" {
  domain = "vpc"
  
  tags = {
    Name = "Network-Base-nat-eip"
  }
  
  depends_on = [aws_internet_gateway.main]
}


# NAT Gateway
# Allows resources in private subnets to reach the internet
# but prevents the internet from initiating connections to them
resource "aws_nat_gateway" "main" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public_1.id
  
  tags = {
    Name = "Network-Base-nat-gateway"
  }
  
  depends_on = [aws_internet_gateway.main]
}