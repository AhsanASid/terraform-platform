# AWS Platform Engineering Project

An end-to-end cloud platform on AWS, built phase by phase with Terraform.

## Status
- [x] Phase 1: Modular IaC and secrets management
- [x] Phase 2: Container CI (GitHub Actions) and Kubernetes delivery on a local kind cluster
- [x] Phase 3: Observability (Prometheus, Grafana, Loki) & GitOps repo layout
- [x] Phase 4: Canary progressive delivery (Argo Rollouts)
- [x] Phase 5: Backups/DR (Velero) and cost optimization (plan-only EKS)

## Phase 1 highlights
- **Remote state:** S3 bucket (versioned, encrypted, public access blocked) with native S3 state locking
- **Reusable VPC module:** VPC, two public subnets across two AZs, internet gateway, routing
- **Secrets:** SSM Parameter Store (SecureString); no secrets in code or Git
- **Least privilege:** read-only IAM role assumed via temporary credentials
- **Layout:** `modules/` for shared code, `envs/<name>/` for each environment

## Design decisions & Cost Optimization
- **Zero-Spend Constraint:** Strict adherence to free-tier/zero-cost engineering. AWS EKS control planes incur ~$0.10/hour plus compute costs.
- **EKS Architecture (Plan-Only):** The `modules/eks` module defines the complete production AWS EKS architecture (control plane, IAM roles, managed node groups with autoscaling). It is verified via `terraform plan` to prove enterprise AWS platform proficiency, but never `terraform apply`'d to eliminate AWS charges.
- **Local-First Kubernetes:** Workloads, observability (Prometheus, Grafana, Loki), progressive delivery (Argo Rollouts), and disaster recovery (Velero + MinIO) run locally on a single-node `kind` cluster.
- **Public subnets only:** NAT gateways (~$32/month each) are omitted to protect the zero-spend budget.
- **Parameter Store over Secrets Manager:** Free tier, adequate without automatic rotation.
- **Provider pinned:** (`~> 6.0`) and lock file committed for reproducible builds.

## Usage
```bash
cd envs/dev
terraform init
terraform plan
# Note: DO NOT run terraform apply for EKS in credit-limited dev environments
```
Requires AWS credentials configured locally and your own state bucket name in the backend block.

## Cleanup
`terraform destroy` from `envs/dev` if any resources are applied. The state bucket is created manually and removed separately.
