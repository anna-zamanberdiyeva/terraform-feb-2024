provider aws {
    region = "us-east-2"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = file("~/.ssh/id_rsa.pub") 
}

resource "aws_instance" "web" {
  ami           = "ami-060a84cbcb5c14844"
  instance_type = "t2.micro"
  key_name = aws_key_pair.deployer.key_name
}

resource null_resource hello {
    connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = file("~/.ssh/id_rsa")
    host     = aws_instance.web.public_ip


   provisioner "remote-exec" {
    inline = [
        "sudo yum install httpd -y"
    ]
  }
}
}