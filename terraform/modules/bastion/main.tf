resource "aws_key_pair" "shared_key" {
  key_name   = "shared-ssh-key"
  public_key = file("~/.ssh/cloud9_key.pub")
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0453ec754f44f9a4a"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.shared_key.key_name
  vpc_security_group_ids = [aws_security_group.bastion.id]

  tags = {
    Name = "Bastion Host Instance"
  }
}


resource "aws_security_group" "bastion" {
  vpc_id = var.vpc_id

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
    Name = "Bastion Host SG"
  }
}
