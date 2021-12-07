variable "aws_region" {
  default = "eu-west-1"
}

variable "profile" {
  default = "Terraform&Jenkins-Setup"
}

variable "ec2_ami" {
  default = "ami-09ce2fc392a4c0fbc"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ec2_keypair" {
  default = "Wasim-AWS-key"
}

variable "ec2_count" {
  type = number
  default = "2"
}

variable "environment" {
  default = "Prod"
}

variable "vpc_id" {
  default = "vpc-d82200bc"
}
variable "subnets" {
   default = ["subnet-f52b1991","subnet-c5f8ceb3","subnet-769fe02e"]
}
