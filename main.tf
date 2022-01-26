variable "aws-access-key-01" {
    type = string
    sensitive = true
}

variable "aws-secret-key-01" {
    type = string
    sensitive = true
}

variable "aws-access-key-02" {
    type = string
    sensitive = true
}

variable "aws-secret-key-02" {
    type = string
    sensitive = true
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
    alias = "aws_01"
    region = "us-east-1"
    access_key = var.aws-access-key-01
    secret_key = var.aws-secret-key-01
}

provider "aws" {
    alias = "aws_02"
    region = "us-east-1"
    access_key = var.aws-access-key-02
    secret_key = var.aws-secret-key-02
}

data "aws_ami" "ubuntu_01" {
    provider = aws.aws_01
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_01" {
  provider = aws.aws_01
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "EC2_In_Account_01"
  }
}

data "aws_ami" "ubuntu_02" {
    provider = aws.aws_01
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

    owners = ["099720109477"] # Canonical
}

resource "aws_instance" "ec2_02" {
  provider = aws.aws_02
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "EC2_In_Account_01"
  }
}