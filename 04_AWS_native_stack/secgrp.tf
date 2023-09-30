resource "aws_security_group" "Vpro-bean-elb-sg" {
  name = "vprofile-beanstalk-security-grp"
  description = "Security group for beanstalk environment and stack"
  vpc_id = module.VPC.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "bastion-sg" {
  name = "vpro-bastion-sg"
  description = "vpro-bastion-sg"
  vpc_id = module.VPC.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [var.MYIP]
  }
}

resource "aws_security_group" "vprod-sg" {
  name = "vpro-prod-sg"
  description = "vpro-secgrp-for-beanstalk-instances"
  vpc_id = module.VPC.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.bastion-sg.id]
  }
}

resource "aws_security_group" "backend-sg" {
  name = "backend-sg"
  description = "for rds amazonmq and elasticache"
  vpc_id = module.VPC.vpc_id
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    security_groups = [aws_security_group.vprod-sg.id]
  }
}

resource "aws_security_group_rule" "coms-backend" {
  type = "ingress"
  from_port = 0
  to_port = 65535
  protocol = "tcp"
  security_group_id = aws_security_group.backend-sg.id
  source_security_group_id = aws_security_group.backend-sg.id
}