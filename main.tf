module "hello-world" {
  source  = "app.terraform.io/mattspahr-sandbox/hello-world/aws"
  version = "1.0.1"
}

resource "random_string" "test_string" {
  length = var.string_length
}
