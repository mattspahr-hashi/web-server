module "hello-world" {
  source  = "app.terraform.io/mattspahr-sandbox/hello-world/aws"
  version = "1.0.5"

  instance_type = "t2.micro"
}
