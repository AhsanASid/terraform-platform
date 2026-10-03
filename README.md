# AWS Platform Engineering Project

An end-to-end cloud platform on AWS, built phase by phase with Terraform.

## Status
- [x] Phase 1: Modular IaC and secrets management
- [x] Phase 2: Container CI (GitHub Actions) and Kubernetes delivery on a local kind cluster (EKS Terraform planned as plan-only)
- [ ] Phase 3: GitOps (ArgoCD) and observability (Prometheus, Grafana, Loki)
- [ ] Phase 4: Canary deployments (Argo Rollouts)
- [ ] Phase 5: Backups/DR (Velero) and cost optimization

## Phase 1 highlights
- **Remote state:** S3 bucket (versioned, encrypted, public access blocked) with native S3 state locking
- **Reusable VPC module:** VPC, two public subnets across two AZs, internet gateway, routing
- **Secrets:** SSM Parameter Store (SecureString); no secrets in code or Git
- **Least privilege:** read-only IAM role assumed via temporary credentials
- **Layout:** `modules/` for shared code, `envs/<name>/` for each environment

## Design decisions
- Public subnets only for now. NAT gateways (~$32/month each) are deferred to protect a credit-limited budget
- Parameter Store over Secrets Manager: free tier, adequate without automatic rotation
- Provider pinned (`~> 6.0`) and lock file committed for reproducible builds

## Usage
```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```
Requires AWS credentials configured locally and your own state bucket name in the backend block.

## Cleanup
`terraform destroy` from `envs/dev`. The state bucket is created manually and removed separately.

## Phase 2 summary (local-first)
- **CI:** [hello-api](https://github.com/AhsanASid/hello-api) builds a non-root container image with GitHub Actions and publishes it to GHCR, tagged by commit SHA
- **Delivery:** [platform-manifests](https://github.com/AhsanASid/platform-manifests) holds the Kubernetes desired state (probes, resource limits, rolling updates)
- **Cluster:** local `kind` cluster instead of EKS. The AWS account has no credits, and EKS costs about $0.10/hr for the control plane alone, so the Kubernetes work runs locally at zero cost
