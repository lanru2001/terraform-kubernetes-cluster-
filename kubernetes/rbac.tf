resource "kubernetes_service_account" "load_balancer_Controller" {
  automount_service_account_token = true
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    annotations = {
      "eks.amazonaws.com/role-arn" = aws_iam_role.eks_lb_controller.arn
    }
    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/component"  = "controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }
}

resource "kubernetes_cluster_role" "load_balancer_Controller" {
  metadata {
    name = "aws-load-balancer-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["configmaps", "endpoints", "events", "ingresses", "ingresses/status", "services"]
    verbs      = ["create", "get", "list", "update", "watch", "patch"]
  }

  rule {
    api_groups = ["", "extensions"]
    resources  = ["nodes", "pods", "secrets", "services", "namespaces"]
    verbs      = ["get", "list", "watch"]
  }
}

resource "kubernetes_cluster_role_binding" "load_balancer_Controller" {
  metadata {
    name = "aws-load-balancer-controller"

    labels = {
      "app.kubernetes.io/name"       = "aws-load-balancer-controller"
      "app.kubernetes.io/managed-by" = "terraform"
    }
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.load_balancer_Controller.metadata[0].name
  }

  subject {
    api_group = ""
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.load_balancer_Controller.metadata[0].name
    namespace = kubernetes_service_account.load_balancer_Controller.metadata[0].namespace
  }
}
