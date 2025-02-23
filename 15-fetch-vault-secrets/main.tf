variable "vault_token" {
  
}
# hashicorp data  for fetching details
data "vault_generic_secret" "secret-vault" {
  path = "kv/test"
}
provider "vault" {
  address = "https://vault.man.online"
  token=var.vault_token
  skip_tls_verify = true #skip certificate verification
}
# it will not be able to print since it is secret
# store in local file
resource "local_file" "name" {
  content = data.vault_generic_secret.secret-vault.data["MYPASS"]
  filename = "/tmp/file.bar"
}
# wiil not print since it si sensitive
output "test" {
  value = data.vault_generic_secret.secret-vault.data["MYPASS"]
}