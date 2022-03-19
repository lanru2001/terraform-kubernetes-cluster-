resource "kubernetes_namespace" "namespace" {
  metadata {
    name = var.namespace
    labels = var.labels
  }
  depends_on = [ var.namespace_depends_on ]
}

resource "kubernetes_deployment" "deploy" {
  metadata {
    name = "${var.deployment_name}-${terraform.workspace}"
    namespace = kubernetes_namespace.namespace.metadata[0].name
    labels = var.labels
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = var.labels
    }

    template {
      metadata {
        labels = var.labels
      }

      spec {
        container {
          image = "wordpress"
          name  = "wordpress"
          port   {
              name = "wordpress"
              container_port = 80
          }
          volume_mount  {
              name = "wordpress-persistent-storage"
              mount_path = "/var/www/html"
          }
          env {
            name = "WORDPRESS_DB_HOST"
            value = var.db_address
          }
          env { 
            name = "WORDPRESS_DB_USER"
            value = var.db_user
          }
          env { 
            name = "WORDPRESS_DB_PASSWORD"
            value = var.db_pass 
          } 
          env {
            name = "WORDPRESS_DB_NAME"
            value = var.db_name
          }
        }
        volume  {
          name = "wordpress-persistent-storage"
          persistent_volume_claim { 
              claim_name = kubernetes_persistent_volume_claim.wordpress.metadata[0].name
          }
        }
      }
    }
  }
}
