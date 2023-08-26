provider "aws"{
    region = "us-east-1"
}

variable "aws_key_name" {
  description = "Name of your AWS key pair"
}

variable "priv_key_name" {
  description = "Name of your private AWS key "
}

resource "aws_instance" "jnknserver" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  tags = {
    Name = "jenkins"
  }
  provisioner "file" {
    source = "jenkins-setup.sh"
    destination = "/tmp/jenkins-setup.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 60",
      "sudo chmod 777 /tmp/jenkins-setup.sh" ,
      "sleep 5",
      "sudo /tmp/jenkins-setup.sh > install.log 2>&1"
    ]
  }
  connection {
    user = "ubuntu"
    private_key = file(var.priv_key_name)
    host = self.public_ip
  }
}

resource "aws_instance" "sonar" {
  ami = "ami-0261755bbcb8c4a84"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  tags = {
    Name = "sonar_qube"
  }
  provisioner "file" {
    source = "sonar_setup.sh"
    destination = "/tmp/sonar_setup.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 60",
      "sudo chmod 777 /tmp/sonar_setup.sh" ,
      "sleep 5",
      "sudo /tmp/sonar_setup.sh > install.log 2>&1"
    ]
  }
  connection {
    user = "centos"
    private_key = file(var.priv_key_name)
    host = self.public_ip
  }
}

resource "aws_instance" "nexus" {
  ami = "ami-002070d43b0a4f171"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = var.aws_key_name
  vpc_security_group_ids = ["sg-082caed89bee71634"]
  tags = {
    Name = "nexus_repo"
  }
  provisioner "file" {
    source = "nexus_repo.sh"
    destination = "/tmp/nexus_repo.sh"
  }
  provisioner "remote-exec"{
    inline = [
      "sleep 60",
      "sudo chmod 777 /tmp/nexus_repo.sh" ,
      "sleep 5",
      "sudo /tmp/nexus_repo.sh > install.log 2>&1"
    ]
  }
  connection {
    user = "centos"
    private_key = file(var.priv_key_name)
    host = self.public_ip
  }
}
