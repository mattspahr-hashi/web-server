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
  default = "hello-world"
}

data "hcp-packer-artifact" "base-linux" {
  bucket_name   = "base-linux"
  channel_name  = "latest"
  platform      = "aws"
  region        = "us-east-2"
}

source "amazon-ebs" "linux" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  instance_type = "t2.micro"
  region        = "us-east-2"
  source_ami    = data.hcp-packer-artifact.base-linux.external_identifier
  ssh_username  = "ec2-user"
}

build {
  sources = ["source.amazon-ebs.linux"]

  provisioner "shell" {
    inline = [
      "echo '<h1>Hello, from HashiCorp!</h1>' | sudo tee /var/www/html/index.html"
    ]
  }

  hcp_packer_registry {
    bucket_name = "hello-world"

    bucket_labels = {
      "os" = "Amazon Linux 2"
    }

    build_labels = {
      "build-time"   = timestamp(),
      "build-source" = basename(path.cwd),
    }
  }
}