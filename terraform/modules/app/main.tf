resource "aws_key_pair" "app_key" {
  key_name   = "app-ssh-key"
  public_key = file("~/.ssh/app_key.pub")
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

resource "aws_launch_template" "app" {
  name          = "app-launch-template"
  instance_type = var.instance_type
  image_id           = var.ami_id
  key_name      = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [aws_security_group.app_sg.id]

  user_data = base64encode(<<-EOF
      #!/bin/bash
      yum update -y
      yum install -y httpd
      systemctl start httpd
      systemctl enable httpd
    
      echo "Hello, World from ASG!" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "App-Instance"
    }
  }
}

resource "aws_autoscaling_group" "app" {
  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  min_size           = 2
  max_size           = 2
  desired_capacity   = 2
  vpc_zone_identifier = var.subnet_ids
  target_group_arns  = [var.target_group_arn]

  tags = [
    {
      key                 = "Name"
      value               = "App-Instance"
      propagate_at_launch = true
    }
  ]
}

data "aws_autoscaling_group" "app_asg" {
  name = aws_autoscaling_group.app.name
}

data "aws_instances" "app_instances" {
  filter {
    name   = "tag:aws:autoscaling:groupName"
    values = [data.aws_autoscaling_group.app_asg.name]
  }
}
