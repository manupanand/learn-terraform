output "dns_name" {
  value = aws_lb.main.dns_name
}
# writing output for listener, no need of rules for http redirectot -only public and internal http
output "listener_arn" {
  value = aws_lb_listener.main.arn
}