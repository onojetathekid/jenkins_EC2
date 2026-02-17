output "jenkins_details" {
  value = {
    url            = "http://${aws_instance.network-base-server-01.public_ip}:8080"
    command_to_get_pwd = "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
  }
}

# Note: This only works if you explicitly defined the password in your user_data script
output "raw_user_data" {
  value     = aws_instance.network-base-server-01.user_data
  sensitive = true
}