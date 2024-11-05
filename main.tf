module "hello-world" {
  source  = "app.terraform.io/mattspahr-sandbox/hello-world/aws"
  version = "1.0.8"

  instance_type = "t2.nano"
  instance_name = "${var.env}-hello-world-${random_string.instance_id.result}"
}

resource "random_string" "instance_id" {
  length  = 16
  special = false
}
