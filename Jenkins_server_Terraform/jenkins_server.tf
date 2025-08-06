
data "aws_ami" "latest-amazon-linux-image" {
  most_recent = true                                      # Should be False if we don't want latest AMI image
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]               # Add desired version of AMI
  }
  filter {
    name   = "virtualization-type"                        #If we dont provide this step, terraform by default will create EC2 of para-virtual which will show error & won't create EC2
    values = ["hvm"]                                      # hvm = Hardware Virtual Machine
  }
}

resource "aws_instance" "myapp-server" {
  ami                         = data.aws_ami.latest-amazon-linux-image.id
  instance_type               = var.instance_type
  key_name                    = "jenkins-server"
  subnet_id                   = aws_subnet.myapp-subnet-1.id
  vpc_security_group_ids      = [aws_default_security_group.default-sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  user_data                   = file("jenkins-server-script.sh")              #Will tell terraform to run this shell script after crating an EC2
  tags = {
    Name = "${var.env_prefix}-server"
  }
}
