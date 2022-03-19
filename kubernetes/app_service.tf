resource "kubernetes_service" "wordpress" {
  metadata {
    name = "${var.deployment_name}-service"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = var.labels
  }
  spec {
    selector = var.labels
    type  = "LoadBalancer"
    port {
      port = 80
      target_port = 80
      protocol = "TCP"
    }
  }
}
