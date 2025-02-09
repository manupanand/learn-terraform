resource "null_resource" "instance" {
  for_each = var.component
}