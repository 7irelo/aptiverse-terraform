output "security_groups" {
  description = "Map of security group IDs"
  value = {
    alb        = aws_security_group.alb.id
    web_server = aws_security_group.web_server.id
    rds        = aws_security_group.rds.id
    bastion    = aws_security_group.bastion.id
  }
}