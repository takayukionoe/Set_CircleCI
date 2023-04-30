variable "vpc_id"{
}
variable "public_subnet_a"{
}


resource "aws_instance" "ec2" {
  ami                    = "ami-01b32aa8589df6208"
  instance_type          = "t2.micro"
  key_name               = "raisetech13th"
  subnet_id              = var.public_subnet_a
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<EOF
  #! /bin/bash
  sudo yum -y update
  EOF

  tags = {
    Name = "ec2-raisetech13th"
  }
}

resource "aws_eip_association" "eip_assoc"{
  instance_id = aws_instance.ec2.id
  public_ip   = "18.181.38.231"
}

resource "aws_security_group" "ec2_sg" {
  name   = "ec2-sg"
  vpc_id = var.vpc_id

  tags = {
    Name = "ec2-sg"
  }

  ingress {
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

    ingress {
    from_port        = 3000
    to_port          = 3000
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }
}

output "ec2_id"{
  value = aws_instance.ec2.id
}