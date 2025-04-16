# gcloud commads
```
gcloud auth login

```
```
gcloud services enable compute.googleapis.com
```

Step 5: Initialize Terraform with Remote Backend
```
cd terraform-gcp-lab
terraform init -backend-config=env-dev/backend.tf```

✅ Step 6: Apply Your Infra
```
terraform apply -var-file=env-dev/state.tfvars
```
