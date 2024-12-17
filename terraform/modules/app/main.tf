resource "aws_key_pair" "app_key" {
  key_name   = "app-agh-ssh-key"
  public_key = file("~/.ssh/app_key.pub")
}

resource "aws_launch_template" "app" {
  name                   = "app-launch-template"
  instance_type          = var.instance_type
  image_id               = var.ami_id
  key_name               = aws_key_pair.app_key.key_name
  vpc_security_group_ids = [var.app_security_group_id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size           = 20
      volume_type           = "gp3"
      encrypted             = true
      delete_on_termination = true
    }
  }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      apt update -y
      apt install -y apache2
      systemctl start apache2
      systemctl enable apache2
    
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

  min_size            = 2
  max_size            = 2
  desired_capacity    = 2
  vpc_zone_identifier = var.subnet_ids
  target_group_arns   = [var.target_group_arn]

  tag {
    key                 = "Name"
    value               = "App-Instance"
    propagate_at_launch = true
  }
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
