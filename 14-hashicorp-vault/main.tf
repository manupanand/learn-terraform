variable "vault_token" {
  
}
data "vault_generic_secret" "hashicorp" {
  path = "kv/test"
}

provider "vault" {
  address = "https:internal:8200"
  token = var.vault_token
  skip_tls_verify = true
}
#will not be able to print
#so store int in file

resource "local_file" "file-name" {
  content = data.vault_generic_secret.hashicorp.data["MYPASS"]
  filename = "/tmp/file-name.bar"

}
#enter token when prompt
