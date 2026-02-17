############################################
# Data
############################################

data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}




resource "aws_instance" "network-base-server-01" {
    ami           = data.aws_ami.al2023.id # Amazon Linux 2 AMI (HVM), SSD Volume Type in us-east-1
    instance_type = "t3.micro"
    subnet_id     = aws_subnet.public_1.id
    security_groups = [aws_security_group.network-base_sg.id]
    associate_public_ip_address = true
    
    user_data = file("jenkins.sh")

    tags = {
        Name = "network-base-server1"
    }
}