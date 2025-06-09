resource "aws_secretsmanager_secret" "guestbook" {
  name = "guestbook/passwords"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "guestbook" {
  secret_id     = aws_secretsmanager_secret.guestbook.id
  secret_string = jsonencode({
    mysql_user_password = var.mysql_user_password,
    mysql_root_password = var.mysql_root_password,
    redis_password = var.redis_password
  })
}
