# 🚀 Production-Level Three-Tier Web Application on AWS

A production-style three-tier web application deployed on AWS using **React, Flask, Docker, Amazon ECR, Amazon EC2, Auto Scaling, Application Load Balancer, Amazon RDS, Amazon S3, AWS Secrets Manager, AWS Systems Manager, CloudWatch, Terraform, and Jenkins CI/CD**.

The project demonstrates how to build, deploy, monitor, and automate a containerized application using AWS services and DevOps practices.

---

## 📌 Project Overview

This project implements a three-tier architecture:

1. **Presentation Tier** – React frontend hosted on Amazon S3
2. **Application Tier** – Flask backend running inside Docker containers on EC2
3. **Database Tier** – Amazon RDS MySQL

The backend instances are placed behind an **Application Load Balancer (ALB)** and managed using an **Auto Scaling Group (ASG)**.

Jenkins automates the CI/CD process by:

- Checking out source code from GitHub
- Testing the backend
- Building the Docker image
- Pushing the image to Amazon ECR
- Discovering active Auto Scaling instances
- Deploying the backend using AWS Systems Manager
- Performing backend health checks
- Building the React frontend
- Deploying the frontend to Amazon S3
- Verifying the application

---

# 🏗️ Architecture

```text
                         Internet
                            |
                            |
                    +---------------+
                    |   React App   |
                    |   Frontend    |
                    +---------------+
                            |
                            v
                    +---------------+
                    |   Amazon S3   |
                    | Static Website|
                    +---------------+
                            |
                            | API Requests
                            v
                 +----------------------+
                 | Application Load     |
                 | Balancer (ALB)       |
                 +----------------------+
                     /              \
                    /                \
                   v                  v
          +---------------+    +---------------+
          |    EC2 #1    |    |    EC2 #2    |
          |    Docker     |    |    Docker     |
          |    Flask API  |    |    Flask API  |
          +---------------+    +---------------+
                    \                /
                     \              /
                      v            v
                    +---------------+
                    |   Amazon RDS  |
                    |     MySQL     |
                    +---------------+

🔄 CI/CD Architecture

Developer
    |
    v
 GitHub
    |
    v
 Jenkins
    |
    +----------------------+
    |                      |
    v                      v
Backend Pipeline       Frontend Pipeline
    |                      |
    v                      v
Docker Build           React Build
    |                      |
    v                      v
Amazon ECR              Amazon S3
    |
    v
AWS Systems Manager
    |
    v
EC2 Auto Scaling Group
    |
    v
Application Load Balancer
    |
    v
Backend Application
    |
    v
Amazon RDS

☁️ AWS Services Used

| AWS Service               | Purpose                                       |
| ------------------------- | --------------------------------------------- |
| Amazon VPC                | Network isolation                             |
| Public Subnets            | Internet-facing resources                     |
| Private Subnets           | Application/database resources                |
| Internet Gateway          | Internet connectivity                         |
| NAT Gateway               | Outbound internet access from private subnets |
| Route Tables              | Network routing                               |
| Security Groups           | Network access control                        |
| Application Load Balancer | Distributes application traffic               |
| EC2                       | Runs Dockerized backend                       |
| Auto Scaling Group        | Maintains backend instances                   |
| Amazon ECR                | Stores Docker images                          |
| Amazon RDS                | MySQL database                                |
| Amazon S3                 | Hosts React frontend                          |
| AWS Secrets Manager       | Stores database credentials                   |
| AWS Systems Manager       | Remote deployment to EC2                      |
| IAM                       | AWS permissions                               |
| CloudWatch                | Monitoring and alarms                         |
| Terraform                 | Infrastructure as Code                        |
| Jenkins                   | CI/CD automation                              |

🧩 Application Components

Frontend

Technology:

React.js
React DOM
React Scripts

The frontend is built as a production React application.

npm install
npm run build

The generated build/ directory is deployed to Amazon S3.

Backend

Technology:

Python
Flask
Gunicorn
PyMySQL
Boto3
Docker

The backend exposes the following endpoints.

Application Endpoint
/
Example response:

{
  "message": "Production Three Tier Application",
  "status": "Running"
}

Health Endpoint
/health

Example response:

{
  "status": "Healthy"
}
Database Endpoint
/database

Example response:

{
  "database": "Connected",
  "time": "2026-08-23 14:28:04"
}

🐳 Docker

The Flask backend is containerized using Docker.
Example Dockerfile:

FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["gunicorn","--bind","0.0.0.0:5000","app:app"]

The container listens on:

5000
📦 Amazon ECR

Docker images are stored in Amazon Elastic Container Registry.

Example:

<ACCOUNT_ID>.dkr.ecr.us-east-1.amazonaws.com/three-tier-backend:<BUILD_NUMBER>

Jenkins creates a unique image tag using the Jenkins build number.

Example:

three-tier-backend:1
three-tier-backend:2
three-tier-backend:3
⚖️ Application Load Balancer

The backend EC2 instances are registered with an Application Load Balancer.

The ALB distributes requests between healthy instances.

Example:

Client
   |
   v
ALB
   |
   +------> EC2 Instance 1
   |
   +------> EC2 Instance 2

The ALB also performs health checks to determine whether backend instances are healthy.

📈 Auto Scaling

The backend runs inside an Auto Scaling Group.

Current configuration:

Minimum Capacity : 2
Desired Capacity : 2
Maximum Capacity : 4

Example:

                 Auto Scaling Group
                         |
              +----------+----------+
              |                     |
              v                     v
           EC2 #1                 EC2 #2
         InService               InService

If additional capacity is required, Auto Scaling can launch additional instances.

🔐 AWS Secrets Manager

Database credentials are not stored directly in the application source code.

The backend retrieves database credentials from AWS Secrets Manager.

Example configuration:

DB_HOST
DB_PORT
DB_USER
DB_PASSWORD
DB_NAME

The backend uses Boto3 to retrieve the secret dynamically.

This avoids storing database passwords directly in the Git repository.

🛠️ AWS Systems Manager

Jenkins deploys the backend using AWS Systems Manager instead of SSH.

Deployment flow:

Jenkins
   |
   v
AWS Systems Manager
   |
   v
EC2 Instances

Jenkins uses:

aws ssm send-command

to execute deployment commands on the application instances.

This avoids the need to store SSH private keys in Jenkins.

🔄 Jenkins CI/CD Pipeline

The Jenkins pipeline performs the following steps:

1. Checkout
       |
2. AWS Identity Check
       |
3. Backend Test
       |
4. Docker Build
       |
5. ECR Login
       |
6. Push Docker Image
       |
7. Discover ASG Instances
       |
8. Deploy Backend using SSM
       |
9. Backend Health Check
       |
10. Frontend Build
       |
11. Deploy Frontend to S3
       |
12. Application Verification
🔎 Dynamic Auto Scaling Deployment

The Jenkins pipeline does not depend on a permanently hard-coded application EC2 instance.

Instead, it discovers the current instances in the Auto Scaling Group.

Example:

aws autoscaling describe-auto-scaling-groups

Jenkins identifies instances in:

InService

state and deploys the latest Docker image.

This allows newly launched Auto Scaling instances to participate in deployments.

🏗️ Infrastructure as Code

Terraform is used to define AWS infrastructure.

The Terraform configuration includes resources such as:

VPC
Subnets
Internet Gateway
NAT Gateway
Route Tables
Security Groups
Application Load Balancer
Target Groups
EC2
Auto Scaling Group
RDS
IAM
S3

Typical Terraform commands:

terraform init
terraform validate
terraform plan
terraform apply
📊 Monitoring

Amazon CloudWatch is used for monitoring and alarms.

Configured monitoring includes:

EC2 CPU utilization
ALB HTTP 5XX errors
Auto Scaling metrics
Application health

Example CPU alarm:

CPU utilization > 70%

Example ALB alarm:

HTTP 5XX errors > 5
🔒 Security Practices

The project implements several AWS security practices:

IAM roles instead of hard-coded AWS access keys
AWS Systems Manager instead of SSH-based deployment
AWS Secrets Manager for database credentials
Security Groups for network access control
Private database tier
Application Load Balancer
Auto Scaling
Health checks
No database passwords stored in source code
📁 Project Structure
Production-level-three-tier-web-app/
│
├── README.md
├── .gitignore
│
├── application/
│   │
│   ├── backend/
│   │   ├── app.py
│   │   ├── database.py
│   │   ├── requirements.txt
│   │   └── Dockerfile
│   │
│   └── frontend/
│       ├── public/
│       ├── src/
│       │   ├── App.js
│       │   ├── api.js
│       │   └── index.js
│       ├── package.json
│       └── package-lock.json
│
├── terraform/
│   ├── provider.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── vpc.tf
│   ├── subnet.tf
│   ├── route-table.tf
│   ├── security-groups.tf
│   ├── alb.tf
│   ├── asg.tf
│   ├── ec2.tf
│   ├── rds.tf
│   ├── iam.tf
│   └── s3.tf
│
├── jenkins/
│   └── Jenkinsfile
│
└── docs/
    ├── architecture.png
    └── screenshots/
🚀 Deployment Process
Step 1 — Clone Repository
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd Production-level-three-tier-web-app
Step 2 — Infrastructure

Initialize Terraform:

terraform init

Validate:

terraform validate

Review:

terraform plan

Apply:

terraform apply
Step 3 — Backend

Navigate to backend:

cd application/backend

Build Docker image:

docker build -t three-tier-backend .

Run locally:

docker run -p 5000:5000 three-tier-backend

Test:

curl http://localhost:5000/
Step 4 — Frontend

Navigate to frontend:

cd application/frontend

Install dependencies:

npm install

Build:

npm run build
Step 5 — Jenkins

Configure Jenkins with the GitHub repository.

Jenkins performs:

GitHub
   ↓
Jenkins
   ↓
Backend Test
   ↓
Docker Build
   ↓
ECR Push
   ↓
SSM Deployment
   ↓
Health Check
   ↓
Frontend Build
   ↓
S3 Deployment
🧪 Application Testing
Test ALB
curl http://<ALB-DNS>/

Expected:

{
  "message": "Production Three Tier Application",
  "status": "Running"
}
Test Health
curl http://<ALB-DNS>/health

Expected:

{
  "status": "Healthy"
}
Test Database
curl http://<ALB-DNS>/database

Expected:

{
  "database": "Connected"
}
🌐 Frontend

The React frontend is hosted on Amazon S3.

Example:

http://<S3-WEBSITE-ENDPOINT>/

The frontend communicates with the backend through the Application Load Balancer.

📸 Screenshots

Screenshots demonstrating the deployment are available in:

docs/screenshots/

Recommended screenshots:

AWS architecture
Jenkins successful pipeline
EC2 Auto Scaling Group
Application Load Balancer
RDS database
S3 frontend
Working frontend application
Backend health check
Database connectivity
CloudWatch alarms
✅ Project Status
Completed
 AWS VPC
 Public and private subnets
 Internet Gateway
 NAT Gateway
 Route Tables
 Security Groups
 Application Load Balancer
 Target Group
 EC2
 Auto Scaling Group
 Docker
 Amazon ECR
 Amazon RDS MySQL
 AWS Secrets Manager
 AWS Systems Manager
 Amazon S3
 IAM
 CloudWatch
 Terraform
 Jenkins CI/CD
 Backend health checks
 Database connectivity
 Frontend deployment
 Auto Scaling instance deployment
🔮 Future Improvements

The following features are planned for future versions.

CloudFront

Add Amazon CloudFront in front of the S3 frontend.

User
 |
 v
CloudFront
 |
 v
S3

Benefits:

CDN
Caching
Improved performance
HTTPS support
Global edge locations
Route 53

Add a custom domain using Amazon Route 53.

Example:

www.example.com
api.example.com
HTTPS / ACM

Use AWS Certificate Manager to enable HTTPS.

Target:

https://www.example.com
https://api.example.com
AWS WAF

Add AWS WAF for additional application-layer protection.

SNS Notifications

Connect CloudWatch alarms to Amazon SNS for email notifications.

GitHub Webhook

Automatically trigger Jenkins when code is pushed to GitHub.

git push
   |
   v
GitHub
   |
   v
Webhook
   |
   v
Jenkins
   |
   v
Deployment
Zero-Downtime Deployment

Improve the Docker deployment strategy to reduce or eliminate downtime during application updates.

ECS / Fargate

Future versions can migrate the backend from manually managed Docker containers on EC2 to Amazon ECS/Fargate.

🎯 DevOps Skills Demonstrated

This project demonstrates practical experience with:

AWS
Docker
Terraform
Jenkins
CI/CD
Linux
Git
GitHub
Python
Flask
React
Amazon ECR
Amazon EC2
Auto Scaling
Application Load Balancer
Amazon RDS
Amazon S3
IAM
Secrets Manager
Systems Manager
CloudWatch
Infrastructure as Code
Containerization
Deployment Automation
Monitoring
👨‍💻 Author
Saran PS

AWS / DevOps Project

⭐ Final Result

The completed project provides an automated three-tier application deployment architecture:

                   GitHub
                      |
                      v
                   Jenkins
                      |
          +-----------+-----------+
          |                       |
          v                       v
      Backend                 Frontend
          |                       |
          v                       v
       Docker                    React
          |                       |
          v                       v
        ECR                      S3
          |
          v
        SSM
          |
          v
       EC2 ASG
          |
          v
         ALB
          |
          v
         RDS

The infrastructure is managed using Terraform and the application deployment is automated using Jenkins CI/CD.
