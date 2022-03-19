provider "helm" {
  kubernetes {
    host                   = var.eks_cluster_endpoint
    token                  = data.aws_eks_cluster_auth.eks_auth.token
    cluster_ca_certificate = base64decode(var.eks_ca_certificate)
  }
}

resource "helm_release" "using_iamserviceaccount" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = "1.1.1"
  namespace  = "kube-system"
  atomic     = true

  set {
    name  = "clusterName"
    value = var.eks_cluster_name
  }
  set {
    name  = "serviceAccount.create"
    value = "false"
  }
  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }
  set {
    name  = "region"
    value = var.region
  }
  set {
    name  = "vpcId"
    value = var.vpc_id
  }
  depends_on = [kubernetes_cluster_role_binding.load_balancer_Controller]
}
