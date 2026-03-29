resource "aws_security_group" "ec2" {
  vpc_id = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = []
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "lt" {
  name_prefix   = "technova"
  image_id      = var.ami
  instance_type = "t2.micro"

  user_data = base64encode(file("${path.module}/../../user-data.sh"))

  vpc_security_group_ids = [aws_security_group.ec2.id]
}

resource "aws_autoscaling_group" "asg" {
  desired_capacity = 3
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier = var.private_subnets

  launch_template {
    id      = aws_launch_template.lt.id
    version = "$Latest"
  }

  target_group_arns = [var.target_group_arn]
}
