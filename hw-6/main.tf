resource "aws_vpc" "main" {
  cidr_block = "192.168.0.0/24"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name        = "MyVPC"
    Environment = "Development"
  }
}


resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "192.168.0.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name        = "Public Subnet"
    Environment = "Development"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "192.168.0.128/25"
  availability_zone = "us-east-1a"

  tags = {
    Name        = "Private Subnet"
    Environment = "Development"
  }
}


resource "aws_security_group" "front" {
  name        = "front_sg"
  description = "Allow HTTP access for the public instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Front Security Group"
    Environment = "Development"
  }
}


resource "aws_security_group" "back" {
  name        = "back_sg"
  description = "Allow SSH access for the private instance"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "Back Security Group"
    Environment = "Development"
  }
}

resource "aws_instance" "web_instance" {
  ami             = var.web_ami
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.front.name]
  associate_public_ip_address = true

  tags = {
    Name        = "WEB Instance"
    Environment = "Development"
  }
}


resource "aws_instance" "db_instance" {
  ami             = var.db_ami 
  instance_type   = "t2.micro"
  subnet_id       = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.back.name]

  tags = {
    Name        = "DB Instance"
    Environment = "Development"
  }
}

