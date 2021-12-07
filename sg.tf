resource "aws_security_group" "Jenkins-Server" {
  name        = "${var.environment}-Jenkins-Server"
  vpc_id      = "${var.vpc_id}"

 # inbound from jenkis server

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

 # outbound from jenkis server

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-Server"
  }
}

resource "aws_security_group" "efs-SG" {
   name = "${var.environment}-efs-SG"
   vpc_id = "${var.vpc_id}"

   # NFS
   ingress {
     from_port = 2049
     to_port = 2049
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }

   # Terraform removes the default rule
   egress {
     from_port = 0
     to_port = 0
     protocol = "tcp"
     cidr_blocks = ["0.0.0.0/0"]
   }
  tags = {
    Name = "efs-SG"
  }
}
