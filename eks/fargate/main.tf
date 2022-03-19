resource "aws_eks_fargate_profile" "main" {
  cluster_name           = var.eks_cluster_name
  fargate_profile_name   = "${var.fargate_profile_name}-${terraform.workspace}"
  pod_execution_role_arn = aws_iam_role.fargate_pod_execution_role.arn
  subnet_ids             = var.subnet_ids

  selector {
    namespace = "default"
  }
  
  selector {
    namespace = var.kubernetes_namespace
  }
}
