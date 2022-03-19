resource "kubernetes_service" "wordpress" {
  metadata {
    name = "${var.deployment_name}-service"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = var.labels
  }
  spec {
    selector = var.labels
    type  = "NodePort"
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
    }
  }
}

resource "kubernetes_ingress" "wordpress" {
  metadata {
    name      = "${var.deployment_name}-ingress"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type" = "ip"
    }
    labels = var.labels
  }

  spec {
    backend {
      service_name = kubernetes_service.wordpress.metadata[0].name
      service_port = kubernetes_service.wordpress.spec[0].port[0].port
    }
    rule {
      http {
        path {
          path = "/*"
          backend {
            service_name = kubernetes_service.wordpress.metadata[0].name
            service_port = kubernetes_service.wordpress.spec[0].port[0].port
          }
        }
      }
    }
  }
  depends_on = [ kubernetes_service.wordpress, helm_release.using_iamserviceaccount ]
}
