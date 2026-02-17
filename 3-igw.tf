# Internet Gateway
# Allows resources in public subnets to access the internet
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  
  tags = {
    Name = "Network-Base-igw"
  }
}

# # Elastic IP for NAT Gateway
# # NAT gateway needs a static public IP address
# resource "aws_eip" "nat" {
#   domain = "vpc"
  
#   tags = {
#     Name = "Network-Base-nat-eip"
#   }
  
#   depends_on = [aws_internet_gateway.main]
# }
