resource "aws_key_pair" "shared_key" {
  key_name   = "shared-ssh-key"
  public_key = file("~/.ssh/cloud9_key.pub")
}

resource "aws_instance" "bastion" {
  ami                    = "ami-0453ec754f44f9a4a"
  instance_type          = "t2.micro"
  subnet_id              = var.subnet_id
  key_name               = aws_key_pair.shared_key.key_name
  vpc_security_group_ids = [var.bastion_security_group_id]

  tags = {
    Name = "Bastion Host Instance"
  }
}
