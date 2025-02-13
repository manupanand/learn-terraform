terraform {
  backend "s3" {
    # leave empty comes from each env state-files
  }
}

resource "null_resource" "test" {
  # run - terraform init -backend-config=env-dev/state.tfvars
}