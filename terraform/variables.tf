variable "project_name" {
  type    = string
  default = "demo"
}

variable "location" {
  type    = string
  default = "de/fra"
}

variable "ionos_token" {
  type      = string
  sensitive = true
}

variable "k8s_kube_version" {
  type    = string
  default = "1.29"
}

variable "node_count" {
  type    = number
  default = 2
}

variable "s3_region" {
  type    = string
  default = "eu-central-1"
}

variable "s3_access_key" {
  type      = string
  default = ""
}

variable "s3_secret_key" {
  type      = string
  default = ""
}

variable "s3_endpoint" {
  type    = string
  default = "https://s3.eu-central-1.ionoscloud.com"
}

variable "velero_bucket" {
  type    = string
  default = "velero-backups-demo"
}

variable "grafana_admin_password" {
  type      = string
  sensitive = true
  default   = "ChangeMe123!"
}

