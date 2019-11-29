data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}
resource "aws_instance" "web" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  key_name = "alsam"
  tags = {
    Name = "HelloWorld"
  }
  security_groups = ["Hillel_alsam", "Alsam"]
  provisioner "remote-exec" {
    inline = [
      "sudo -i",
      "yum update",
    ]
    connection {
      type = "ssh"
      host = "${aws_instance.web.public_ip}"
      user = "centos"
      port = "22"
      private_key = file("/home/alex/Documents/alsam-aws/alsam.pem")
    }
  }
}

resource "aws_security_group" "Hillel_alsam" {
  name         = "Hillel_alsam"
  description  = "Hillel security group"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.105.145.0/32"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
