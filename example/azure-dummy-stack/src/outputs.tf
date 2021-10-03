output "message_id" {
  value = null_resource.message.id
}

output "instance_id" {
  value = random_string.instance_id.result
}

output "instance_name" {
  value = "${var.instance_name}-${random_string.instance_id.result}"
}
