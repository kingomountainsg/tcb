resource "aws_security_group" "example" {
  name = "example"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}

resource "aws_key_pair" "key" {
  key_name   = "aws_tf_key"
  public_key = file("./ec2-key.pub")
}

resource "aws_instance" "example" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.key.key_name
  vpc_security_group_ids = [aws_security_group.example.id]



  provisioner "local-exec" {
    command = "echo ${self.public_ip} >>ec2-public-ip.txt"
  }


  provisioner "file" {
    source      = "./dump"
    destination = "/tmp/dump-onp"
  }
  provisioner "file" {
    content     = "EC2 AZ: ${self.availability_zone}"
    destination = "/tmp/ec2-az.txt"
  }

  provisioner "remote-exec" {
    inline = [
      "echo EC2 ARN:  ${self.arn} >> /tmp/arn.txt",
      "echo EC2 Public DNS: ${self.public_dns} >> /tmp/public_dns.txt",
      "echo EC2 Private IP:  ${self.private_ip} >> /tmp/private_ip.txt"
    ]

  }


  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("./ec2-key")
    host        = self.public_ip
  }
}