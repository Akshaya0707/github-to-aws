
terraform {
  backend "s3" {
    bucket       = "statefile23102026"
    key          = "github-ec2-demo/terraform.tfstate"
    region       = "us-west-1"
    use_lockfile = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "us-west-1"
}

resource "aws_instance" "web" {
  ami                         = "ami-0bbfe192d29e29bac"
  instance_type               = "t3.micro"
  subnet_id                   = "subnet-024791e8bf51b89aa"
  vpc_security_group_ids      = ["sg-0f77442c920b8fcf0"]
  associate_public_ip_address = true

  user_data = <<-EOF
    #!/bin/bash
    dnf install httpd git -y
    systemctl enable --now httpd
    git clone https://github.com/Akshaya0707/services.git /var/www/html
  EOF

  tags = {
    Name = "github-actions-ec2-demo"
  }
}

output "website_url" {
  value = "http://${aws_instance.web.public_ip}"
}