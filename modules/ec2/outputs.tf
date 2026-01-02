output "instance_ids" {
  description = "List of EC2 instance IDs"
  value       = aws_autoscaling_group.main.id
}

output "launch_template_id" {
  description = "ID of the launch template"
  value       = aws_launch_template.main.id
}

output "autoscaling_group_name" {
  description = "Name of the autoscaling group"
  value       = aws_autoscaling_group.main.name
}