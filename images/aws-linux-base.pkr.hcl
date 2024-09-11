packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = "~> 1"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

variable "ami_prefix" {
  type    = string
  default = "base-linux"
}

data "amazon-ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  filters = {
    name                = "amzn2-ami-hvm-*-x86_64-gp2"
    root-device-type    = "ebs"
    virtualization-type = "hvm"
  }
  region = "us-east-2"
}

source "amazon-ebs" "linux" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami    = data.amazon-ami.amazon-linux.id
  ssh_username  = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.linux"]

  provisioner "shell" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd curl git",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  }

  hcp_packer_registry {
    bucket_name = "base-linux"

    bucket_labels = {
      "os" = "Amazon Linux 2"
    }

    build_labels = {
      "build-time"   = timestamp(),
      "build-source" = basename(path.cwd),
    }
  }
}