resource "aws_ses_email_identity" "noreply_email" {
  email = var.email
}
