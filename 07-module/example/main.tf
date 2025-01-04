resource "null_resource" "test" {
  count = var.input
}