resource "aws_db_subnet_group" "vpro-rds-subgrp" {
  name = "main"
  subnet_ids = [module.VPC.private_subnets[0],module.VPC.private_subnets[1],module.VPC.private_subnets[2]]
  tags = {
    name = "subnet group for rds"
  }
}

resource "aws_elasticache_subnet_group" "vpro-cache-subgrp" {
  name = "vpro-elasticache-subnet-grp"
  description = "subnet groups for elasticache"
  subnet_ids = [module.VPC.private_subnets[0],module.VPC.private_subnets[1],module.VPC.private_subnets[2]]
  tags = {
    Name = "subnet group for ecache"
  }
}

resource "aws_db_instance" "vpro-rds" {
  allocated_storage = 20
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.6.34"
  instance_class = "db.t2.micro"
  db_name = var.dbname
  username = var.dbuser
  password = var.dbpass
  parameter_group_name = "default.mysql5.6"
  multi_az = "false"
  publicly_accessible = "false"
  skip_final_snapshot = true
  db_subnet_group_name = aws_db_subnet_group.vpro-rds-subgrp.name
  vpc_security_group_ids = [aws_security_group.backend-sg.id]
}

resource "aws_elasticache_cluster" "vpro-cache" {
  cluster_id = "vprofile-cache"
  engine = "memcached"
  node_type = "cache.t2.micro"
  num_cache_nodes = 1
  parameter_group_name = "default.memcached1.5"
  port = 11211
  security_group_ids = [aws_security_group.backend-sg.id]
  subnet_group_name = aws_elasticache_subnet_group.vpro-cache-subgrp.name
}

resource "aws_mq_broker" "vprormq" {
  broker_name = "rabbit"
  engine_type = "ActiveMQ"
  engine_version = "5.15.0"
  host_instance_type = "mq.t2.micro"
  security_groups = [aws_security_group.backend-sg.id]
  subnet_ids = [module.VPC.private_subnets[0]]
  user {
    username = var.rmquser
    password = var.rmqpass
  }
}