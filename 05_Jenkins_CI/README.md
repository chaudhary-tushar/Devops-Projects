# Jenkins PAAC

This Jenkinsfile serves as a PAAC for:-
1.cloning git repo from url 
2.Builds the code (vprofile) using java and maven
3.Tests the code using maven test and sonarqube quality gates
4.After passing the quality gates uploads the **.war artifact to nexus repo
5.Sends a build success message after completing the code

### Required  tools ###
OJDK 
maven
integrated sonarqubue and nexus in jenkins plugin manager
integrated telegrambot in jenkins plugin manager