
/*
data "aws_ssm_parameter" "keypair" {
  name = "hqr-common-vpc-keypair-bootstrap"
}
# Create a Null Resource and Provisioners
resource "null_resource" "name" {
  depends_on = [module.ec2_instance_pub]
  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = module.ec2_instance_pub.public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("jenkins_ssh_file")
  }

  #  # File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  #  provisioner "file" {
  #    source      = file("jenkins_ssh_file")
  #    destination = "/tmp/jenkins_ssh_file"
  #  }
  #  ### Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  #  provisioner "remote-exec" {
  #    inline = [
  #      "sudo chmod 400 /tmp/jenkins_ssh_file"
  #    ]
  #  }
  #  ### Local Exec Provisioner:  local-exec provisioner (Creation-Time Provisioner - Triggered during Create Resource)
  #
  #  provisioner "local-exec" {
  #    command     = "echo VPC created on `date` and VPC ID: ${local.vpc_id} >> ./creation-time-vpc-id.txt"
  #    working_dir = "local-exec-output-files/"
  #    #on_failure = continue
  #  }
  ## Local Exec Provisioner:  local-exec provisioner (Destroy-Time Provisioner - Triggered during deletion of Resource)
  # provisioner "local-exec" {msql
  #    command = "echo Destroy time prov `date` >> destroy-time-prov.txt"
  #    working_dir = "local-exec-output-files/"
  #    when = destroy
  #    #on_failure = continue
  #  }
}

# Creation Time Provisioners - By default they are created during resource creations (terraform apply)
# Destory Time Provisioners - Will be executed during "terraform destroy" command (when = destroy)
*/
