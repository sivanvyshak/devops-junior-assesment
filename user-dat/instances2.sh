#!/bin/bash
dnf update -y
dnf install nginx -y
systemctl start nginx
systemctl enable nginx

INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat <<EOF > /usr/share/nginx/html/index.html
<!DOCTYPE html>
<html>
<head>
    <title>Hello World</title>
</head>
<body style="text-align: center; font-family: Arial; margin-top: 100px;">
    <h1>Hello World!</h1>
    <p>Instance ID: <strong>$INSTANCE_ID</strong></p>
    <p>Availability Zone: <strong>$AZ</strong></p>
    <p>Served by: <strong>Nginx</strong></p>
</body>
</html>
EOF

systemctl restart nginx