provider "aws" {
  region = "us-east-1"
}


resource "aws_db_subnet_group" "default" {
  name       = "vpro-rds-subnet"
  subnet_ids = ["subnet-0b531d690d3938b2c","subnet-021165e83e6ccc452","subnet-0f5cc9132b8d4a931","subnet-012397f487d36edd6","subnet-0586d1fbaf201c011","subnet-0e6f70eae9a895ff2"]
  tags = {
    Name = "My DB subnet group"
  }
}


resource "aws_db_instance" "mydb" {
  allocated_storage    = 10
  storage_type        = "gp2"
  engine              = "mysql"
  engine_version      = "5.7.22"
  instance_class      = "db.t2.micro"
  db_name = "accounts"
  port = "3306"
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  username            = "admin"
  password            = "admin123"
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot = true
}


resource "aws_elasticache_cluster" "mycache" {
  cluster_id           = "vprofile-elasticache"
  engine            = "memcached"
  engine_version = "1.4.5"
  node_type         = "cache.t2.micro"
  parameter_group_name = "default.memcached1.4"
  num_cache_nodes   = 1
  port = 11211
  security_group_ids = ["sg-082caed89bee71634"]
}

resource "aws_mq_broker" "mybroker" {
  broker_name = "vprofile-rmq"

  engine_type        = "RabbitMQ"
  engine_version     = "3.9.16"
  host_instance_type = "mq.t3.micro"
  security_groups    = ["sg-082caed89bee71634"]
  publicly_accessible = false

  user {
    username = "rabbit"
    password = "rabbit987tibbar"
  }
}

output "rds_endpoint" {
  value = aws_db_instance.mydb.endpoint
}

output "cache_endpoint" {
  value = aws_elasticache_cluster.mycache.cache_nodes.0.address
}

output "mq_broker" {
  value = aws_mq_broker.mybroker.id
}


############just instructions below #########

# resource "aws_elastic_beanstalk_application" "myapp" {
#   name = "vpro-app"
#   description = "terra-intructions"
# }

# resource "aws_elastic_beanstalk_environment" "myenv" {
#   name                = "vpro-env"
#   application         = aws_elastic_beanstalk_application.myapp.name
#   solution_stack_name = "64bit Amazon Linux 2 v4.3.10 running Tomcat 8.5 Corretto 11"
#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "SecurityGroups"
#     value     = "sg-082caed89bee71634"
#   }
#   setting {
#     namespace = "aws:autoscaling:launchconfiguration"
#     name      = "EC2KeyName"
#     value     = "terraformkey"
#   }
#   setting {
#     namespace = "aws:autoscaling:asg"
#     name      = "MinSize"
#     value     = "2"
#   }
#   setting {
#     namespace = "aws:autoscaling:updatepolicy:rollingupdate"
#     name      = "RollingUpdateEnabled"
#     value     = "true"
#   }
#   setting {
#     namespace = "aws:ec2:instances"
#     name      = "InstanceTypes"
#     value     = "t2.micro"
#   }
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "ServiceRole"
#     value     = "aws-elasticbeanstalk-service-role"
#   }
#   setting {
#     namespace = "aws:elasticbeanstalk:environment"
#     name      = "LoadBalancerType"
#     value     = "application"
#   }
#   setting {
#     namespace = "aws:elasticbeanstalk:command"
#     name      = "DeploymentPolicy"
#     value     = "Rolling"
#   }
#   setting {
#     namespace = "aws:elasticbeanstalk:command"
#     name      = "BatchSizeType"
#     value     = "Percentage"
#   }
#   setting {
#     namespace = "aws:elasticbeanstalk:command"
#     name      = "BatchSize"
#     value     = "50"
#   }
# }


