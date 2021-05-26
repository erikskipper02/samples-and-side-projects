terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  # access_key = "my-access-key"
  access_key = "" // here
  # secret_key = "my-secret-key"
  secret_key = "" // here
}

resource "aws_instance" "myInstance" {
  ami           = "ami-0c94855ba95c71c99"
  instance_type = "t2.micro"
  user_data     = <<-EOF
                  #!/bin/bash
                  sudo su
                  yum -y install httpd
                  echo "<p> Hello, World! </p>
                  <p> Paragraph 1 </p>
                  <p> Paragraph 2 </p>
                  <p> Paragraph 3 </p>
                  " >> /var/www/html/index.html
                  sudo systemctl enable httpd
                  sudo systemctl start httpd
                  EOF
}

output "DNS" {
  value = aws_instance.myInstance.public_dns
}