resource "ionoscloud_datacenter" "dc" {
  name        = "case-study-vdc"
  location    = var.location
}

resource "ionoscloud_lan" "lan" {
  datacenter_id = "25f2df8e-dcee-4246-8c47-84aa27edacae"
  name          = "cs-lan"
  public        = true
}

resource "ionoscloud_lan" "k8s_public" {
  datacenter_id = "25f2df8e-dcee-4246-8c47-84aa27edacae"
  name          = "k8s-public-lan"
  public        = true
}


resource "ionoscloud_k8s_cluster" "cluster" {
  name         = "cs-k8s-cluster"
  public = true

  # avoid accidental upgrades / immutable-field drift
  lifecycle {
    ignore_changes = [location, k8s_version]
  }
}

resource "ionoscloud_k8s_node_pool" "pool" {
  datacenter_id     = ionoscloud_datacenter.dc.id
  k8s_cluster_id    = ionoscloud_k8s_cluster.cluster.id

  name              = "cs-nodepool-a"
  node_count        = 2
  server_type       = "DedicatedCore"
  # cpu_family intentionally omitted (immutable)

  cores_count       = 4
  ram_size          = 8192
  storage_type      = "SSD"
  storage_size      = 200
  availability_zone = "AUTO"
  k8s_version       = "1.32.6"

  allow_replace     = false

  lifecycle {
    ignore_changes = [cpu_family, k8s_version]
  }
}


resource "aws_s3_bucket" "velero" {
  bucket = "cs-backup-saiteja"
}
