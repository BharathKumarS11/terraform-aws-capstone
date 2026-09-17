# -------------------------
# Latest Amazon Linux 2023 AMI
# -------------------------

data "aws_ssm_parameter" "amazon_linux" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}


# -------------------------
# Launch Template
# -------------------------

resource "aws_launch_template" "app" {
  name = "${var.project_name}-launch-template"

  image_id = data.aws_ssm_parameter.amazon_linux.value

  instance_type = var.instance_type

  iam_instance_profile {
    name = var.instance_profile_name
  }

  vpc_security_group_ids = [
    var.ec2_security_group_id
  ]

  user_data = base64encode(<<-EOF
  #!/bin/bash

  dnf update -y
  dnf install -y httpd

  systemctl enable httpd
  systemctl start httpd

  cat > /var/www/html/index.html <<HTML
  <!DOCTYPE html>
  <html>
  <head>
    <title>Terraform AWS Capstone</title>
  </head>
  <body>
    <h1>Terraform AWS Capstone</h1>

    <p>Application running on Amazon Linux EC2.</p>
    <p>Managed by Terraform.</p>

    <h2>Database Configuration</h2>
    <p>Database: ${var.db_name}</p>
    <p>Database Host: ${var.db_endpoint}</p>
    <p>Database Port: 3306</p>
    <p>Database User: ${var.db_username}</p>

  </body>
  </html>
  HTML
EOF
  )

}
# -------------------------
# Auto Scaling Group
# -------------------------

resource "aws_autoscaling_group" "app" {
  name = "${var.project_name}-asg"

  min_size         = 1
  desired_capacity = 1
  max_size         = 2

  vpc_zone_identifier = var.public_subnet_ids

  launch_template {
    id      = aws_launch_template.app.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "${var.project_name}-asg-instance"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.environment
    propagate_at_launch = true
  }

  tag {
    key                 = "ManagedBy"
    value               = "Terraform"
    propagate_at_launch = true
  }
}

resource "aws_lb" "app" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    var.alb_security_group_id
  ]

  subnets = var.public_subnet_ids

  tags = {
    Name        = "${var.project_name}-alb"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_target_group" "app" {
  name     = "${var.project_name}-tg"
  port     = 80
  protocol = "HTTP"

  vpc_id = var.vpc_id

  target_type = "instance"

  health_check {
    enabled             = true
    path                = "/"
    protocol            = "HTTP"
    port                = "traffic-port"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 30
  }

  tags = {
    Name        = "${var.project_name}-tg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.app.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "forward"

    target_group_arn = aws_lb_target_group.app.arn
  }
}

resource "aws_autoscaling_attachment" "app" {
  autoscaling_group_name = aws_autoscaling_group.app.name
  lb_target_group_arn    = aws_lb_target_group.app.arn
}