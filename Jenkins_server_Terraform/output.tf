#It will list out EC2 instance's IP created in jenkins-server.tf file after creation

output "ec2_public_ip" {
  value = aws_instance.myapp-server.public_ip
}
