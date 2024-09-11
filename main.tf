module "hello-world" {
  source  = "app.terraform.io/mattspahr-sandbox/hello-world/aws"
  version = "1.0.2"
}

resource "random_string" "test_string2" {
  length = var.string_length
}
