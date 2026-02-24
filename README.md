# junior-devops-assessment – Highly Available ALB with Private EC2 Architecture
📌 Project Overview

This project demonstrates a secure and highly available AWS architecture using:

- Custom VPC
- Public and Private Subnets
- NAT Gateway
- EC2 Instances running Nginx
- Application Load Balancer
- Proper Security Group configuration

The architecture ensures that application servers are not directly exposed to the internet.

---

Architecture Design

- 1 VPC (10.0.0.0/16)
- 2 Public Subnets (Multi-AZ)
- 2 Private Subnets (Multi-AZ)
- Internet Gateway
- NAT Gateway
- 2 EC2 Instances (Private Subnets)
- Application Load Balancer (Public Subnets)

Traffic Flow

Internet  
↓  
Application Load Balancer (Public Subnets)  
↓  
EC2 Instances (Private Subnets)  
↓  
NAT Gateway (Outbound Internet Access)

---

Security Design

- EC2 instances do NOT have public IP addresses.
- Only the ALB Security Group can access EC2 on port 80.
- Public access is allowed only to the ALB.
- Private instances use NAT Gateway for outbound internet access.

---

Deployment Steps

1️⃣ Create VPC
- CIDR: 10.0.0.0/16

2️⃣ Create Subnets
- Public Subnet 1 (AZ1)
- Public Subnet 2 (AZ2)
- Private Subnet 1 (AZ1)
- Private Subnet 2 (AZ2)

3️⃣ Attach Internet Gateway

4️⃣ Configure Route Tables
- Public RT → 0.0.0.0/0 → IGW
- Private RT → 0.0.0.0/0 → NAT Gateway

5️⃣ Create NAT Gateway
- Placed in Public Subnet
- Elastic IP attached

6️⃣ Launch EC2 Instances (Private Subnets)
- Amazon Linux 2023
- Nginx installed via user data
- No public IP

7️⃣ Create Target Group
- Register both EC2 instances

8️⃣ Create Application Load Balancer
- Internet-facing
- Deployed in Public Subnets
- Listener: HTTP 80 → Target Group

---

💻 User Data Script (Nginx Setup)

```bash
#!/bin/bash
yum update -y
yum install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1>DevOps Assignment</h1>
<p>Hostname: $(hostname)</p>
<p>Private IP: $(hostname -I)</p>" > /usr/share/nginx/html/index.html
