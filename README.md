# 🚀 AWS EKS Cluster with ArgoCD, Prometheus, and Grafana launched via Terraform 

Welcome to the Terraform project repository for setting up a fully functional, private AWS EKS cluster integrated with essential tools like ArgoCD, Prometheus, and Grafana. This repository provides everything you need to deploy and manage a secure and scalable Kubernetes environment on AWS.

## 🌟 Overview

This project automates the provisioning of a private EKS cluster on AWS, along with the deployment of key Kubernetes management and monitoring tools using Terraform and Helm. The infrastructure is designed to be robust, allowing you to easily manage, scale, and monitor your Kubernetes resources.

### Key Features:
- **Private EKS Cluster**: A secure EKS setup running within a private VPC.
- **Infrastructure as Code**: Automated deployment using Terraform, ensuring repeatability and scalability.
- **Helm Integration**: Deployment of ArgoCD, Prometheus, and Grafana using Helm charts.
- **Modular Design**: The project is structured into reusable modules for easier management and customization.

### Architecture Diagram
![Architecture Diagram](./assets/architecture.png)

## 🚀 Getting Started

### Prerequisites

Before you begin, ensure you have the following installed:

- **Terraform**: Infrastructure as Code tool to automate deployment.
- **AWS CLI**: To interact with your AWS account.
- **Kubectl**: Kubernetes command-line tool.
- **Helm**: Kubernetes package manager.

### Quickstart

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Joebaho/ArgoCD-EKS-LB-Terraform.git
   cd ArgoCD-EKS-LB-Terraform
   ```

2. **Deploy the network and helper EC2 instance**:
   ```bash
   cd vpc-ec2
   terraform init
   terraform validate
   terraform plan
   terraform apply -auto-approve
   ```

   After this step, connect to the helper EC2 instance (via ssm) created by the network configuration. This EC2 instance is intended to be used as an administration host for the cluster.

   Once you are on the EC2 instance, configure your AWS credentials so Terraform, `aws`, `kubectl`, and `helm` can communicate with your AWS account and EKS cluster:

   ```bash
   aws configure
   aws sts get-caller-identity
   ```

3. **Deploy the EKS cluster and platform add-ons**:
   ```bash
   cd ../eks
   terraform init
   terraform validate
   terraform plan
   terraform apply -auto-approve
   ```

   After the EKS deployment completes, continue working from the helper EC2 instance and make sure your AWS credentials are still configured correctly before trying to access the cluster from `kubectl`.

4. **Configure kubectl for the new cluster**:
   ```bash
   aws eks update-kubeconfig --region us-west-2 --name dev-medium-eks-cluster
   kubectl get nodes
   ```

5. **Check that the add-ons are running**:
   ```bash
   kubectl get pods -A
   kubectl get svc -A
   ```

6. **Open ArgoCD, Grafana, and Prometheus in your browser**:
   Follow the commands in the access section below to get the external URLs and login details.

![Load Ballanceers](./assets/loadbalacer.png)

### Access ArgoCD

After the `eks/` deployment completes, get the ArgoCD load balancer address:

```bash
kubectl -n argocd get svc
```

Look for the ArgoCD server service and copy the `EXTERNAL-IP` or hostname. You can also fetch it directly:

```bash
kubectl -n argocd get svc argocd-server \
  -o jsonpath="{.status.loadBalancer.ingress[0].hostname}{.status.loadBalancer.ingress[0].ip}" && echo
```

Open the returned address in your browser:

```text
http://<ARGOCD-EXTERNAL-HOSTNAME>
```

Get the initial ArgoCD admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret \
  -o jsonpath="{.data.password}" | base64 --decode && echo
```

ArgoCD login details:
- Username: `admin`
- Password: use the command above

![ArgoCd Page](./assets/argocd.png)

### Access Grafana

List the services in the `prometheus` namespace:

```bash
kubectl -n prometheus get svc
```

Find the Grafana service, usually named `prometheus-grafana`, then get its load balancer hostname:

```bash
kubectl -n prometheus get svc prometheus-grafana \
  -o jsonpath="{.status.loadBalancer.ingress[0].hostname}{.status.loadBalancer.ingress[0].ip}" && echo
```

Open the returned address in your browser:

```text
http://<GRAFANA-EXTERNAL-HOSTNAME>
```

If you want to find the Grafana service name quickly:

```bash
kubectl -n prometheus get svc -o wide | grep grafana
```

![Grafana](./assets/grafana.png)

### Access Prometheus

Get the Prometheus service hostname:

```bash
kubectl -n prometheus get svc -o wide | grep prometheus
```

Then fetch the external address for the Prometheus service:

```bash
kubectl -n prometheus get svc prometheus-kube-prometheus-prometheus \
  -o jsonpath="{.status.loadBalancer.ingress[0].hostname}{.status.loadBalancer.ingress[0].ip}" && echo
```

Open the returned address in your browser:

```text
http://<PROMETHEUS-EXTERNAL-HOSTNAME>
```

![Promotheus](./assets/prometheus.png)

### Troubleshooting Access

If the external address is still pending, the AWS Load Balancer may still be provisioning. Check again after a few minutes:

```bash
kubectl get svc -A
```

Useful troubleshooting commands:

```bash
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A
kubectl -n argocd get svc
kubectl -n prometheus get svc
```

### Destroy The Infrastructure

Destroy the stacks in reverse order. Always destroy `eks/` first, then destroy `vpc-ec2/`.

1. **Destroy the EKS cluster and add-ons**:
   ```bash
   cd eks
   terraform destroy -auto-approve
   ```

2. **Destroy the VPC and helper EC2 instance**:
   ```bash
   cd ../vpc-ec2
   terraform destroy -auto-approve
   ```

If you want to review the destroy plan before deleting resources, run:

```bash
terraform plan -destroy
```

![Destroy](./assets/destroy.png)

### Notes

- This project supports Terraform `1.13.x` and `1.14.x`.
- The Terraform root modules are `vpc-ec2/` and `eks/`. The repository root is not itself a Terraform root module.
- Each Terraform root includes its own committed `terraform.tfvars`, so you can run `terraform plan` and `terraform apply` directly inside `vpc-ec2/` and `eks/` without passing `-var-file`.
- `endpoint-public-access` is enabled in `variables.tfvars` so the Helm and Kubernetes providers can complete from a standard workstation. If you want a fully private API endpoint later, disable it after you have a private network path to the cluster.
- ArgoCD is exposed through a `LoadBalancer` service in the `argocd` namespace.
- Grafana and Prometheus are exposed through `LoadBalancer` services in the `prometheus` namespace.

## 🤝 Contribution

Pull requests are welcome. For major changes, please open an issue first.

## 👨‍💻 Author

**Joseph Mbatchou**

• DevOps / Cloud / Platform  Engineer   
• Content Creator / AWS Builder

## 🔗 Connect With Me

🌐 Website: [https://platform.joebahocloud.com](https://platform.joebahocloud.com)

💼 LinkedIn: [https://www.linkedin.com/in/josephmbatchou/](https://www.linkedin.com/in/josephmbatchou/)

🐦 X/Twitter: [https://www.twitter.com/Joebaho237](https://www.twitter.com/Joebaho237)

▶️ YouTube: [https://www.youtube.com/@josephmbatchou5596](https://www.youtube.com/@josephmbatchou5596)

🔗 Github: [https://github.com/Joebaho](https://github.com/Joebaho)

📦 Dockerhub: [https://hub.docker.com/u/joebaho2](https://hub.docker.com/u/joebaho2)

---

## 📄 License

This project is licensed under the MIT License — see the LICENSE file for details.
