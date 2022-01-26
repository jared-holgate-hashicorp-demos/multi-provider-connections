variable "aws_access_key_01" {
    type = string
    sensitive = true
}

variable "aws_secret_key_01" {
    type = string
    sensitive = true
}

variable "aws_access_key_02" {
    type = string
    sensitive = true
}

variable "aws_secret_key_02" {
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

locals {
  image_name = "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"
  image_type = "hvm"
  image_owner = "099720109477" # Canonical
}


provider "aws" {
    alias = "aws_01" # NOTE: Set the provider alias here!
    region = "us-east-1"
    access_key = var.aws_access_key_01
    secret_key = var.aws_secret_key_01
}

provider "aws" {
    alias = "aws_02" # NOTE: Set the provider alias here!
    region = "us-east-1"
    access_key = var.aws_access_key_02
    secret_key = var.aws_secret_key_02
}

data "aws_ami" "ubuntu_01" {
    provider = aws.aws_01 # NOTE: Use the provider alias here!
    most_recent = true

    filter {
        name   = "name"
        values = [local.image_name]
    }

    filter {
        name   = "virtualization-type"
        values = [local.image_type]
    }

    owners = [local.image_owner]
}

resource "aws_instance" "ec2_01" {
  provider = aws.aws_01 # NOTE: Use the provider alias here!
  ami           = data.aws_ami.ubuntu_01.id
  instance_type = "t3.micro"

  tags = {
    Name = "EC2_In_Account_01"
  }
}

data "aws_ami" "ubuntu_02" {
    provider = aws.aws_02 # NOTE: Use the provider alias here!
    most_recent = true

    filter {
        name   = "name"
        values = [local.image_name]
    }

    filter {
        name   = "virtualization-type"
        values = [local.image_type]
    }

    owners = [local.image_owner]
}

resource "aws_instance" "ec2_02" {
  provider = aws.aws_02 # NOTE: Use the provider alias here!
  ami           = data.aws_ami.ubuntu_02.id
  instance_type = "t3.micro"

  tags = {
    Name = "EC2_In_Account_02"
  }
}