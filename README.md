# Demo: Terraform Project for Kubernetes Application on Azure

This project provisions Azure resources and deploys a containerized Python app to Kubernetes using AKS, ACR, and Terraform.

## Flow

1. Use Terraform to create: Resource Group, ACR, AKS.
2. Build & push Docker image to ACR.
3. Deploy app to AKS using Kubernetes manifests.

## Prerequisites

- [Terraform installed](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- Azure CLI: `az login`
- Service Principal or your Azure credentials
- Docker installed
- kubectl installed

## How To Use

### 1. Provision Azure Resources

```bash
cd terraform
terraform init
terraform apply
```
Note outputs: ACR login server, AKS kubeconfig, credentials.

### 2. Build and Push Docker Image

```bash
az acr login --name <acr_name>
docker build -t <acr_login_server>/python-demo:latest .
docker push <acr_login_server>/python-demo:latest
```

### 3. Configure kubectl

```bash
export KUBECONFIG=$(pwd)/kubeconfig
kubectl get nodes
```
Or using output from `terraform output kube_config`.

### 4. Deploy to AKS

```bash
kubectl apply -f k8s/
kubectl get service python-demo-service
```
Access your app via the external IP.

### 5. Clean Up

```bash
terraform destroy
```

## Notes

- Update `<ACR_LOGIN_SERVER>` in `k8s/deployment.yaml` if needed.
- You may automate image build/push and deployment with CI/CD (GitHub Actions can follow this flow).

---

terraform init