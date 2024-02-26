output "alb_hostname" {
  value = aws_lb.main.dns_name
}

output "alb_zone_id" {
  value = aws_lb.main.zone_id
}

# Load balancer ARN to be used in the target groups
output "alb_arn" {
  value = aws_lb.main.arn
}


# Load balancer Listener ARN to be used in the target groups
output "alb_listener_arn" {
  value = aws_lb_listener.front_end_http.arn
}
