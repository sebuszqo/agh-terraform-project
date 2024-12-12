resource "aws_s3_bucket" "alb_logs" {
  bucket = "agh-cloud-security-course-access-logs-agh"
}

resource "aws_lb" "this" {
  name               = "app-load-balancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnets
  # access_logs {
  #   bucket  = aws_s3_bucket.alb_logs.bucket
  #   enabled = true
  # }
}

# resource "aws_s3_bucket_policy" "alb_logs" {
#   bucket = aws_s3_bucket.alb_logs.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Principal = {
#           Service = "logging.s3.amazonaws.com"
#         }
#         Action = "s3:PutObject"
#         Resource = "${aws_s3_bucket.alb_logs.arn}/*"
#         Condition = {
#           StringEquals = {
#             "aws:SourceAccount" = var.account_id
#           }
#           ArnLike = {
#             "aws:SourceArn" = "arn:aws:elasticloadbalancing:${var.region}:${var.account_id}:loadbalancer/*"
#           }
#         }
#       }
#     ]
#   })
# }


resource "aws_lb_target_group" "this" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

