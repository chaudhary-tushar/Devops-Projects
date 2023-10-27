
# Containerization

This Repo Contains the Java Project divided into 3 parts:-
- App: This image contains the tomcat server where the Java-Maven artifact will be stored and served.
- DB: This image contains the backend MySQL database required by the App. 
- Web: This image contains Nginx server which serves as a load balancer to the app.

### Prerequisites
- Docker
- Docker-Compose
- Microservice Architecture
- Memcache Docker Image
- RabbitMQ Docker Image

### System Design

![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)







## Installation

- Set the parameters in the sonarspec file provided in the repo.
- Update jdbc host, username & password.
- Update rabbitmq username and password.
- Update memcache username and password.
- Build the artifact using Maven .
- Build the app docker image uploading the artifact.
- Run Docker-compose up.
    