# IONOS K8s – Terraform + Ansible

This repo provisions an IONOS Virtual Data Center (VDC), LAN, Managed Kubernetes cluster, installs:
- Ingress-NGINX
- kube-prometheus-stack (Prometheus, Grafana, Alertmanager)
- Velero (with IONOS S3)
…and deploys a sample NGINX app (Deployment/Service/Ingress/HPA) using Ansible.
