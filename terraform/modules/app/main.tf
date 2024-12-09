resource "aws_key_pair" "app_key" {
  key_name   = "app-ssh-key"
  public_key = file("~/.ssh/app_key.pub")
}

resource "aws_instance" "app" {
  count         = 2
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name        = aws_key_pair.app_key.key_name
  subnet_id     = element(var.subnet_ids, count.index)
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = <<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
    
      echo "Hello, World! ${count.index}" > /var/www/html/index.html
  EOF


  tags = {
    Name = "App-Instance-${count.index}"
  }
}

resource "aws_security_group" "app_sg" {
  name   = "app-security-group"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_security_group_id]
  }

  ingress {
    description     = "Allow SSH from Bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [var.bastion_security_group_id]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_lb_target_group_attachment" "app" {
  count             = length(aws_instance.app)
  target_group_arn  = var.target_group_arn
  target_id         = aws_instance.app[count.index].id
  port              = 80
}