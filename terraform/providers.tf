terraform {
  required_version = ">= 1.5.0"

  required_providers {
    ionoscloud = {
      source  = "ionos-cloud/ionoscloud"
      version = "~> 6.4"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.13"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.33"
    }
    # Keep aws here ONLY to satisfy any leftover references in your tree.
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.58"
    }
  }

  # Remote state in IONOS Object Storage (S3-compatible)
  backend "s3" {
    endpoint                    = "https://s3.eu-central-1.ionoscloud.com"
    bucket                      = "cs-backup-saiteja"
    key                         = "terraform.tfstate"
    region                      = "eu-central-1"
    skip_credentials_validation = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

# IONOS provider
provider "ionoscloud" {
  token = "eyJ0eXAiOiJKV1QiLCJraWQiOiJkOThjZTdiNS1jZTY3LTQwM2UtODAxZS01MmRkNjI0ZTcxNDMiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJpb25vc2Nsb3VkIiwiaWF0IjoxNzU2MTExMjM3LCJjbGllbnQiOiJVU0VSIiwiaWRlbnRpdHkiOnsicmVzZWxsZXJJZCI6MSwicmVnRG9tYWluIjoiaW9ub3MuZGUiLCJyb2xlIjoidXNlciIsImNvbnRyYWN0TnVtYmVyIjozMTkwMTQ1OSwiaXNQYXJlbnQiOmZhbHNlLCJwcml2aWxlZ2VzIjpbIkFDQ0VTU19BTkRfTUFOQUdFX0xPR0dJTkciLCJBQ0NFU1NfQUNUSVZJVFlfTE9HIiwiTUFOQUdFX1JFR0lTVFJZIiwiQUNDRVNTX0FORF9NQU5BR0VfQ0VSVElGSUNBVEVTIiwiQUNDRVNTX0FORF9NQU5BR0VfQVBJX0dBVEVXQVkiLCJCQUNLVVBfVU5JVF9DUkVBVEUiLCJBQ0NFU1NfQU5EX01BTkFHRV9ETlMiLCJNQU5BR0VfREFUQVBMQVRGT1JNIiwiQUNDRVNTX0FORF9NQU5BR0VfQUlfTU9ERUxfSFVCIiwiTUFOQUdFX0RCQUFTIiwiQ1JFQVRFX0lOVEVSTkVUX0FDQ0VTUyIsIlBDQ19DUkVBVEUiLCJBQ0NFU1NfQU5EX01BTkFHRV9ORVRXT1JLX0ZJTEVfU1RPUkFHRSIsIkFDQ0VTU19BTkRfTUFOQUdFX1ZQTiIsIkFDQ0VTU19BTkRfTUFOQUdFX0NETiIsIks4U19DTFVTVEVSX0NSRUFURSIsIlNOQVBTSE9UX0NSRUFURSIsIkZMT1dfTE9HX0NSRUFURSIsIkFDQ0VTU19BTkRfTUFOQUdFX01PTklUT1JJTkciLCJEQVRBX0NFTlRFUl9DUkVBVEUiLCJBQ0NFU1NfQU5EX01BTkFHRV9LQUFTIiwiQUNDRVNTX1MzX09CSkVDVF9TVE9SQUdFIiwiQUNDRVNTX0FORF9NQU5BR0VfSUFNX1JFU09VUkNFUyIsIklQX0JMT0NLX1JFU0VSVkUiLCJDUkVBVEVfTkVUV09SS19TRUNVUklUWV9HUk9VUFMiXSwidXVpZCI6IjE4ZThlNWY5LTA0NDUtNDdiYi1hYzkzLThkMTkxZTA5YjY5ZSJ9LCJleHAiOjE3NTY3MTYwMzd9.ahqy-Hd29y-X9rFkATtegPyU3DpW2L30lv4dinrAmwv4QdqZyos-osz4hvgJFrmpma9Vj6W8WpyRB--X-T2aLrqwkQXD625kWH8N_OrFw1RcAAXXGpUeNSVys_fwZzGXxvvuZdAOByrJ7B1qC-qOfi3YMyX6IjkQeDku8xanYoZbryAFXrY8Y5vBPqQ58LQMOGdgMyQzXETQdQG3qr0_vDy5u-OGggxhXvkb96bfN13Hit6ti1m8vnvOeaRu4qmbVxjpJnlB5MrKEvJulsIGxaHTbZDdri4lv-8vXx-3nkyoJy8dm0WUpyD28cE5ypoIJC0y_81nqp9iw8ll3sL6Vg"
}

# Neutral (no-STS) AWS provider so Terraform won't error if something references it.
# Uses empty creds + skips ALL validation and account lookups.
provider "aws" {
  region                      = "eu-central-1"
  access_key                  = ""
  secret_key                  = ""
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true

  # If any aws_s3_* data/resources exist, point them at IONOS S3.
  endpoints {
    s3 = "https://s3.eu-central-1.ionoscloud.com"
  }
}

# K8s/Helm providers (will work once the cluster resource exists or is imported)
provider "kubernetes" {
  host                   = ionoscloud_k8s_cluster.cluster.kube_config[0].host
  cluster_ca_certificate = base64decode(ionoscloud_k8s_cluster.cluster.kube_config[0].cluster_certificate)
  token                  = ionoscloud_k8s_cluster.cluster.kube_config[0].token
}

provider "helm" {
  kubernetes {
    host                   = ionoscloud_k8s_cluster.cluster.kube_config[0].host
    cluster_ca_certificate = base64decode(ionoscloud_k8s_cluster.cluster.kube_config[0].cluster_certificate)
    token                  = ionoscloud_k8s_cluster.cluster.kube_config[0].token
  }
}

