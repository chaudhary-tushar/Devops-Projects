# BEANSTALK ENVIRONMENT SETUP

the terraform apply will only setup 
1. RDS - mysql with database name accounts
2. Elasticache - with memcache
3. AmazonMQ - with rabbitMQ broker

following which you have to initialize the database 
accounts with the given backup sql file
Then change the application.conf to point to the
endpoints of Mysql , Memcached and Rabbitmq in the 
configuration files.
then you can initialize the beanstalk environment with the 
configurations stated in the terraform comments
