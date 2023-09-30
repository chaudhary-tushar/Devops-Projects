output "rds-endpoint" {
  value = aws_db_instance.vpro-rds.endpoint
}
output "rmq-endpoint" {
  value = aws_mq_broker.vprormq.instances.0.endpoints.1
}
output "cache-endpoint" {
  value = aws_elasticache_cluster.vpro-cache.configuration_endpoint
}
