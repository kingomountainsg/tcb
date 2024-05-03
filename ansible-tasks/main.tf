provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "host01" {
  ami                    = "ami-0fe630eb857a6ec83"
  instance_type          = "t2.micro"
  key_name               = "tcb-ansible-key"
  vpc_security_group_ids = [aws_security_group.secgroup.id]

  provisioner "local-exec" {
    command = "sleep 30;ssh-keyscan ${self.private_ip} >> ~/.ssh/known_hosts"
  }
}

resource "aws_instance" "host02" {
  ami                    = "ami-0fe630eb857a6ec83"
  instance_type          = "t2.micro"
  key_name               = "tcb-ansible-key"
  vpc_security_group_ids = [aws_security_group.secgroup.id]

  provisioner "local-exec" {
    command = "sleep 30;ssh-keyscan ${self.private_ip} >> ~/.ssh/known_hosts"
  }

}

resource "aws_security_group" "secgroup" {
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["sg-0b1c5baf3bc3c30ca"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


output "host01_private_ip" {
  value = aws_instance.host01.private_ip
}

output "host02_private_ip" {
  value = aws_instance.host02.private_ip
}