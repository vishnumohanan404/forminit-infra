
terraform {
  required_providers {
    civo = {
      source  = "civo/civo"
      version = "1.0.19"
    }
  }
  backend "s3" {
    bucket         = "forminit-terraform-backend"
    key            = "terraform/state"
    region         = "us-east-1"
    dynamodb_table = "forminit-terraform-lock-table"
  }

}

provider "civo" {
  token  = var.civo_api_key
  region = var.civo_region
}

