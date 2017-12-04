output "wasadmin_pass" {
  value = "${var.admin_password != "Generate" ? var.admin_password : random_id.wspasswd.hex}"
}

output "wasadmin_user" {
  value = "${var.wsadmin_user}"
}

