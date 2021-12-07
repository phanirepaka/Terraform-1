provider "aws" {
    region =   var.aws_region
    profile = var.profile
}

resource "aws_instance" "ec2" {
  ami           = var.ec2_ami
  instance_type = var.instance_type
  key_name = var.ec2_keypair
  count = var.ec2_count
  vpc_security_group_ids = ["${aws_security_group.Jenkins-Server.id}"]
  subnet_id = element(var.subnets, count.index)
  user_data = "${file("install_jenkins.sh")}"

  tags = {
    Name = "${var.environment}-Jenkins-Server-${count.index+1}"
  }
}

resource "aws_efs_file_system" "efs-example" {
   creation_token = "efs-example"
   performance_mode = "generalPurpose"
   throughput_mode = "bursting"
   encrypted = "true"
 tags = {
     Name = "EfsExample"
   }
}

resource "aws_efs_mount_target" "efs-mt-example" {
   file_system_id  = "${aws_efs_file_system.efs-example.id}"
   #subnet_id = "subnet-f52b1991, subnet-c5f8ceb3"
   subnet_id = aws_instance.ec2[0].subnet_id
   security_groups = ["${aws_security_group.efs-SG.id}"]

}

resource "null_resource" "configure_nfs" {
        depends_on = [aws_efs_mount_target.efs-mt-example]
        connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("/home/ec2-user/learn-terraform-aws-instance/Wasim-AWS-key.pem")
        host = aws_instance.ec2[0].public_ip
        timeout = "5m"
        agent = false
        }


provisioner "remote-exec" {
inline = [
        "sleep 30",
        "sudo /etc/init.d/jenkins stop",
        "sudo /etc/init.d/jenkins status",
        #"sudo mkdir -p /var/lib/jenkins/jobs",
        "sudo echo ${aws_efs_file_system.efs-example.dns_name}",
        "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs-example.dns_name}:/  /var/lib/jenkins/jobs",
        "sudo echo ${aws_efs_file_system.efs-example.dns_name}:/ /var/lib/jenkins/jobs nfs4 defaults,_netdev 0 0  | cat >> /etc/fstab",
        "df -h",
        "cd /var/lib/jenkins",
        "ls -ltr",
        "sudo chown -R jenkins:jenkins jobs",
        "sudo /etc/init.d/jenkins start",
        "sudo /etc/init.d/jenkins status",
        ]
   }
}


resource "aws_efs_mount_target" "efs-mt-example-b" {
   file_system_id  = "${aws_efs_file_system.efs-example.id}"
   #subnet_id = "subnet-f52b1991, subnet-c5f8ceb3"
   subnet_id = aws_instance.ec2[1].subnet_id
   security_groups = ["${aws_security_group.efs-SG.id}"]

}

resource "null_resource" "configure_nfs-b" {
        depends_on = [aws_efs_mount_target.efs-mt-example-b]
        connection {
        type     = "ssh"
        user     = "ec2-user"
        private_key = file("/home/ec2-user/learn-terraform-aws-instance/Wasim-AWS-key.pem")
        host = aws_instance.ec2[1].public_ip
        timeout = "5m"
        agent = false
        }


provisioner "remote-exec" {
inline = [
        "sleep 30",
        "sudo /etc/init.d/jenkins stop",
        "sudo /etc/init.d/jenkins status",
        #"sudo mkdir -p /var/lib/jenkins/jobs",
        "sudo echo ${aws_efs_file_system.efs-example.dns_name}",
        "sudo mount -t nfs -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2,noresvport ${aws_efs_file_system.efs-example.dns_name}:/  /var/lib/jenkins/jobs",
        "sudo echo ${aws_efs_file_system.efs-example.dns_name}:/ /var/lib/jenkins/jobs nfs4 defaults,_netdev 0 0  | cat >> /etc/fstab ",
        "df -h",
        "cd /var/lib/jenkins",
        "ls -ltr",
        "sudo chown -R jenkins:jenkins jobs",
        "sudo /etc/init.d/jenkins start",
        "sudo /etc/init.d/jenkins status",
        ]
   }
}
