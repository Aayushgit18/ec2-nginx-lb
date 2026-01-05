resource "null_resource" "ansible_provision" {

  depends_on = [
    aws_instance.app,
    aws_instance.nginx
  ]

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file(var.private_key_path)
    host        = aws_instance.nginx.public_ip
    timeout     = "5m"
  }

  # --------------------------------------------------
  # Fix SSH host key checking
  # --------------------------------------------------
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /home/ubuntu/.ssh",
      "rm -f /home/ubuntu/.ssh/config",
      "cat <<EOF > /home/ubuntu/.ssh/config\nHost *\n  StrictHostKeyChecking no\n  UserKnownHostsFile /dev/null\nEOF",
      "chmod 600 /home/ubuntu/.ssh/config"
    ]
  }

  # --------------------------------------------------
  # Copy EC2 private key to nginx (Ansible control node)
  # --------------------------------------------------
  provisioner "file" {
    source      = var.private_key_path
    destination = "/home/ubuntu/.ssh/ec2-key.pem"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 400 /home/ubuntu/.ssh/ec2-key.pem"
    ]
  }

  # --------------------------------------------------
  # Install Ansible
  # --------------------------------------------------
  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install -y software-properties-common",
      "sudo add-apt-repository --yes --update universe",
      "sudo apt install -y ansible"
    ]
  }

  # --------------------------------------------------
  # Copy Ansible files
  # --------------------------------------------------
  provisioner "file" {
    source      = "../ansible"
    destination = "/home/ubuntu/ansible"
  }

  # --------------------------------------------------
  # Generate inventory dynamically
  # --------------------------------------------------
  provisioner "file" {
    content = templatefile("../ansible/inventory.tpl", {
      app_ips  = aws_instance.app[*].public_ip
      nginx_ip = aws_instance.nginx.public_ip
    })
    destination = "/home/ubuntu/ansible/inventory.ini"
  }

  # --------------------------------------------------
  # Run Ansible
  # --------------------------------------------------
  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/ansible",
      "ansible-playbook -i inventory.ini playbook.yml"
    ]
  }
}

