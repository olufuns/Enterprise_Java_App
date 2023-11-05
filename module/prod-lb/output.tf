output "prod-target-arn" {
  value = aws_lb_target_group.target_group_prod.arn
}

output "prod-alb-dns" {
  value = aws_lb.prod-alb.dns_name
}

output "prod_lb_arn" {
  value = aws_lb.prod-alb.arn
}

output "prod-alb-zone-id" {
  value = aws_lb.prod-alb.zone_id
}