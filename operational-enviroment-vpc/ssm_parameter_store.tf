resource "aws_key_pair" "keypair" {
  key_name   = "jenkins_ssh_file"
  public_key = file("/Users/kojibello/.ssh/jenkins_ssh_file.pub")
}

resource "aws_ssm_parameter" "keypair" {
  name        = format("%s-%s", var.component_name, "keypair-bootstrap")
  description = format("%s-%s", var.component_name, "ssm parameter store to manager keypair")
  type        = "SecureString"
  value       = " "
  lifecycle {
    ignore_changes = [
      value,
    ]
  }
}
