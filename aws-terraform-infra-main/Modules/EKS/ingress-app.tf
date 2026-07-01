# 1. Simple Nginx Deployment
resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "nginx-app"
    labels = { app = "nginx" }
  }

  spec {
    replicas = 2
    selector { match_labels = { app = "nginx" } }

    template {
      metadata { labels = { app = "nginx" } }
      spec {
        container {
          image = "nginx:alpine"
          name  = "nginx"
          port { container_port = 80 }
        }
      }
    }
  }
  depends_on = [helm_release.alb_controller]
}

# 2. Service (Target Type standard: NodePort or ClusterIP can be used depending on target-type annotation)
resource "kubernetes_service" "nginx_service" {
  metadata {
    name = "nginx-service"
  }
  spec {
    selector = { app = "nginx" }
    port {
      port        = 80
      target_port = 80
    }
    type = "NodePort"
  }
}

# 3. Ingress Manifest creating the AWS ALB
resource "kubernetes_ingress_v1" "app_ingress" {
  metadata {
    name = "app-ingress"
    annotations = {
      "kubernetes.io/ingress.class"           = "alb"
      "alb.ingress.kubernetes.io/scheme"      = "internet-facing"
      "alb.ingress.kubernetes.io/target-type"  = "instance"
    }
  }

  spec {
    rule {
      http {
        path {
          path      = "/*"
          path_type = "ImplementationSpecific"
          backend {
            service {
              name = kubernetes_service.nginx_service.metadata[0].name
              port { number = 80 }
            }
          }
        }
      }
    }
  }
}

# Output the DNS endpoint of your Application Load Balancer once active
output "ingress_alb_dns" {
  value       = kubernetes_ingress_v1.app_ingress.status[0].load_balancer[0].ingress[0].hostname
  description = "The public DNS URL of your Application Load Balancer"
}