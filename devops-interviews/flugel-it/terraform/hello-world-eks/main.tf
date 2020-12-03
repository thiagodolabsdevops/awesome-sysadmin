variable "load_balancer_allowed_ranges" {
  default = ["0.0.0.0/0"]
  type    = list(string)
}

resource "kubernetes_deployment" "hello-world-eks" {
  metadata {
    name = "hello-world-eks"
    labels = {
      App = "hello-world-eks"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "hello-world-eks"
      }
    }
    template {
      metadata {
        labels = {
          App = "hello-world-eks"
        }
      }
      spec {
        container {
          image = "tmagalhaes1985/hello-world-eks:latest"
          name  = "hello-world-eks"

          port {
            container_port = 5000
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "hello-world-eks" {
  metadata {
    name = "hello-world-eks"
  }
  spec {
    selector = {
      App = kubernetes_deployment.hello-world-eks.spec.0.template.0.metadata[0].labels.App
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
    load_balancer_source_ranges = var.load_balancer_allowed_ranges
  }
}
