[apps]
%{ for i, ip in app_ips ~}
app${i + 1} ansible_host=${ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/ec2-key.pem node_number=0${i + 1} app_version=${i + 1}.0
%{ endfor ~}

[nginx]
nginx1 ansible_host=${nginx_ip} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/ec2-key.pem

