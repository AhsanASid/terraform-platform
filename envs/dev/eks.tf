module "eks" {
  source       = "../../modules/eks"
  cluster_name = "platform-dev-eks"
  subnet_ids   = module.vpc.public_subnet_ids

  instance_types   = ["t3.medium"]
  desired_capacity = 2
  min_capacity     = 1
  max_capacity     = 3

  tags = {
    Environment = "dev"
    Project     = "cloud-platform"
  }
}
