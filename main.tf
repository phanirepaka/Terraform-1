terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
}

resource "aws_instance" "Jenkins_Server_1" {
  ami           = "ami-09ce2fc392a4c0fbc"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-Server-1"
  }
}

provisioner "remote-exec" {
  inline = [
	"sudo yum update –y"
    "sudo wget -O /etc/yum.repos.d/jenkins.repo \ https://pkg.jenkins.io/redhat-stable/jenkins.repo",
    "sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key",
    "sudo yum upgrade",
    "sudo yum install jenkins java-1.8.0-openjdk-devel -y",
    "sudo systemctl daemon-reload",
    "sudo systemctl start jenkins",
	"sudo systemctl status jenkins",
  ]
}
