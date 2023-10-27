
# Jenkins Pipeline

This Jenkinsfile serves as a PAAC for:- 
- Cloning git repo from url. 
- Builds the code (vprofile) using java and maven. 
- Tests the code using maven test and sonarqube quality gates. 
- After passing the quality gates uploads the **.war artifact to nexus repo 
- Sends a build success message after completing the code.

### Prerequisites
- AWS CLI
- Terraform
- Bash Scripting
- VPC (Networking)
- Jenkins
- sonarqube
- Nexus  Artifact Repository
- Maven 
- Git

### System Design

![App Screenshot](https://via.placeholder.com/468x300?text=App+Screenshot+Here)

### Jenkins Plugins Setup
- Git 
- SonarQube Credentials
- Nexus Plugin
- Telegram Plugin




