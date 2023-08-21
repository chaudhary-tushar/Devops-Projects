provider "aws" {
    region = "us-east-1"
}

variable "aws_key_name" {
  description = "Name of your AWS key pair"
}

variable "priv_key_name" {
  description = "Name of your private AWS key "
}

resource "aws_instance" "db01" {
  ami = "ami-002070d43b0a4f171"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  tags = {
    Name = "db01"
  }
  provisioner "file" {
    source = "mysql.sh"
    destination = "/tmp/mysql.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 60",
      "sudo chmod 777 /tmp/mysql.sh" ,
      "sleep 5",
      "sudo /tmp/mysql.sh > install.log 2>&1"
    ]
  }
  connection {
    user = "centos"
    private_key = file(var.priv_key_name)
    host = self.public_ip
  }
}

resource "aws_instance" "mc01" {
  ami = "ami-002070d43b0a4f171"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  tags = {
    Name = "memcached01"
  }
  provisioner "file" {
    source = "memcache.sh"
    destination = "/tmp/memcache.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 60",
      "sudo chmod 777 /tmp/memcache.sh" ,
      "sleep 5",
      "sudo /tmp/memcache.sh > install.log 2>&1"
    ]
  }
  connection {
    user = "centos"
    private_key = file(var.priv_key_name)
    host = self.public_ip
  }
}

resource "aws_instance" "rmq01" {
  ami = "ami-002070d43b0a4f171"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  tags = {
    Name = "rabbitmq01"
  }
  provisioner "file" {
    source = "rabbitmq.sh"
    destination = "/tmp/rabbitmq.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 60",
      "sudo chmod 777 /tmp/rabbitmq.sh" ,
      "sleep 5",
      "sudo /tmp/rabbitmq.sh > install.log 2>&1"
    ]
  }
  connection {
    user = "centos"
    private_key = file(var.priv_key_name)
    host = self.public_ip
  }
}

resource "aws_route53_zone" "awsr53" {
  name = "vprofile.in"
  vpc {
    vpc_id = "vpc-0c0404e4d73812d97"
  }
}

resource "aws_route53_record" "dbr1" {

  zone_id = aws_route53_zone.awsr53.zone_id
  name    = "db01.vprofile.in"  # Change to your desired subdomain
  type    = "A"
  ttl     = "300"
  records = [aws_instance.db01.private_ip]
}

resource "aws_route53_record" "mcr1" {

  zone_id = aws_route53_zone.awsr53.zone_id
  name    = "mc01.vprofile.in"  # Change to your desired subdomain
  type    = "A"
  ttl     = "300"
  records = [aws_instance.mc01.private_ip]
}

resource "aws_route53_record" "rmqr1" {

  zone_id = aws_route53_zone.awsr53.zone_id
  name    = "rmq01.vprofile.in"  # Change to your desired subdomain
  type    = "A"
  ttl     = "300"
  records = [aws_instance.rmq01.private_ip]
}

resource "aws_instance" "app01" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  tags = {
    Name = "tomcat01"
  }
  provisioner "file" {
    source = "tomcat_ubuntu.sh"
    destination = "/tmp/tomcat_ubuntu.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 60",
      "sudo chmod 777 /tmp/tomcat_ubuntu.sh" ,
      "sleep 5",
      "sudo /tmp/tomcat_ubuntu.sh > install.log 2>&1"
    ]
  }

  provisioner "remote-exec"{
    inline = [
      "sleep 10",
      "systemctl stop tomcat9",
      "sleep 5",
      "sudo rm -rf /var/lib/tomcat9/webapps/ROOT"
    ]
  }

  provisioner "file" {
    source = "vprofile-v2.war"
    destination = "/var/lib/tomcat9/webapps/ROOT.war"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 10",
      "systemctl start tomcat9"
    ]
  }

  connection {
    user = "ubuntu"
    private_key = file(var.priv_key_name)
    host = self.public_ip
  }
}

resource "aws_lb_target_group" "load" {
  name     = "vprofile-app-TG"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = "vpc-0c0404e4d73812d97"
  health_check {
    enabled = true
    port = 8080
    path = "/login"
    protocol = "HTTP"
    healthy_threshold = 2
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.load.arn
  target_id        = aws_instance.app01.id
  port             = 8080
}

resource "aws_lb" "vproapp" {
  name               = "vprofile-prod-elb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-082caed89bee71634"]
  subnets            = ["subnet-0b531d690d3938b2c","subnet-021165e83e6ccc452","subnet-0f5cc9132b8d4a931","subnet-012397f487d36edd6","subnet-0586d1fbaf201c011","subnet-0e6f70eae9a895ff2"]
  ip_address_type = "ipv4"
  enable_deletion_protection = false
  tags = {
    Environment = "vprofile-test"
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.vproapp.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.load.arn
  }
}