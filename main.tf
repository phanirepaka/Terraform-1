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

resource "aws_instance" "Jenkins_Server_2" {
  ami           = "ami-09ce2fc392a4c0fbc"
  instance_type = "t2.micro"

  tags = {
    Name = "Jenkins-Server-2"
  }
}

