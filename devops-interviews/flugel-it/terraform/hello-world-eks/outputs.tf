
output "lb_ip" {
  value = kubernetes_service.hello-world-eks.load_balancer_ingress[0].hostname
}
