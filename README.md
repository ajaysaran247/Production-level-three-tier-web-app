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

## 🏗️ Architecture

### Infrastructure Flow
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
          |    EC2 #1     |    |    EC2 #2     |
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

```

### 🔄 CI/CD Architecture

```text
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
Amazon ECR             Amazon S3
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

```

---

## ☁️ AWS Services Used

| AWS Service | Purpose |
| --- | --- |
| **Amazon VPC** | Network isolation |
| **Public Subnets** | Internet-facing resources |
| **Private Subnets** | Application/database resources |
| **Internet Gateway** | Internet connectivity |
| **NAT Gateway** | Outbound internet access from private subnets |
| **Route Tables** | Network routing |
| **Security Groups** | Network access control |
| **Application Load Balancer** | Distributes application traffic |
| **EC2** | Runs Dockerized backend |
| **Auto Scaling Group** | Maintains backend instances |
| **Amazon ECR** | Stores Docker images |
| **Amazon RDS** | MySQL database |
| **Amazon S3** | Hosts React frontend |
| **AWS Secrets Manager** | Stores database credentials |
| **AWS Systems Manager** | Remote deployment to EC2 |
| **IAM** | AWS permissions |
| **CloudWatch** | Monitoring and alarms |
| **Terraform** | Infrastructure as Code |
| **Jenkins** | CI/CD automation |

---

## 🧩 Application Components

### 🌐 Frontend

**Technology:** React.js, React DOM, React Scripts

The frontend is built as a production React application.

```bash
npm install
npm run build

```

*The generated `build/` directory is deployed to Amazon S3.*

### ⚙️ Backend

**Technology:** Python, Flask, Gunicorn, PyMySQL, Boto3, Docker

The backend exposes the following endpoints:

**Application Endpoint (`/`)**

```json
{
  "message": "Production Three Tier Application",
  "status": "Running"
}

```

**Health Endpoint (`/health`)**

```json
{
  "status": "Healthy"
}

```

**Database Endpoint (`/database`)**

```json
{
  "database": "Connected",
  "time": "2026-08-23 14:28:04"
}

```

---

## 🐳 Docker

The Flask backend is containerized using Docker.

**Example Dockerfile:**

```dockerfile
FROM python:3.11-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

EXPOSE 5000

CMD ["gunicorn","--bind","0.0.0.0:5000","app:app"]

```

*The container listens on port `5000`.*

---

## 📦 Amazon ECR

Docker images are stored in Amazon Elastic Container Registry. Jenkins creates a unique image tag using the Jenkins build number.

**Example tags:**

```text
<ACCOUNT_ID>[.dkr.ecr.us-east-1.amazonaws.com/three-tier-backend](https://.dkr.ecr.us-east-1.amazonaws.com/three-tier-backend):<BUILD_NUMBER>
three-tier-backend:1
three-tier-backend:2

```

---

## ⚖️ Application Load Balancer

The backend EC2 instances are registered with an Application Load Balancer, which distributes requests between healthy instances and performs regular health checks.

```text
Client
   |
   v
  ALB
   |
   +------> EC2 Instance 1
   |
   +------> EC2 Instance 2

```

---

## 📈 Auto Scaling

The backend runs inside an Auto Scaling Group. If additional capacity is required, Auto Scaling launches additional instances.

**Current configuration:**

* Minimum Capacity: `2`
* Desired Capacity: `2`
* Maximum Capacity: `4`

```text
                 Auto Scaling Group
                         |
              +----------+----------+
              |                     |
              v                     v
           EC2 #1                 EC2 #2
         InService              InService

```

---

## 🔐 Security & Operations

### AWS Secrets Manager

Database credentials are not stored directly in the application source code. The backend uses Boto3 to retrieve the secret dynamically, protecting keys like `DB_HOST`, `DB_PORT`, `DB_USER`, `DB_PASSWORD`, and `DB_NAME`.

### AWS Systems Manager (SSM)

Jenkins deploys the backend using AWS Systems Manager instead of SSH via `aws ssm send-command`. This avoids the need to store SSH private keys in Jenkins.

### Dynamic Auto Scaling Deployment

The pipeline discovers the current instances in the ASG dynamically:

```bash
aws autoscaling describe-auto-scaling-groups

```

Jenkins identifies instances in the `InService` state and deploys the latest Docker image to them.

### Monitoring

Amazon CloudWatch is used for monitoring and alarms, tracking metrics such as:

* EC2 CPU utilization (Alarm: `> 70%`)
* ALB HTTP 5XX errors (Alarm: `> 5 errors`)
* Auto Scaling metrics & Application health

---

## 📁 Project Structure

```text
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

```

---

## 🚀 Deployment Process

### Step 1 — Clone Repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd Production-level-three-tier-web-app

```

### Step 2 — Infrastructure (Terraform)

```bash
terraform init
terraform validate
terraform plan
terraform apply

```

### Step 3 — Backend (Local Testing)

```bash
cd application/backend
docker build -t three-tier-backend .
docker run -p 5000:5000 three-tier-backend
curl http://localhost:5000/

```

### Step 4 — Frontend (Local Build)

```bash
cd application/frontend
npm install
npm run build

```

### Step 5 — Jenkins CI/CD

Configure Jenkins with your GitHub repository. The pipeline automatically handles the flow from GitHub Checkout ➔ Backend Tests ➔ Docker Build ➔ ECR Push ➔ SSM Deployment ➔ S3 Frontend Deployment.

---

## 🧪 Application Testing

**Test ALB**

```bash
curl http://<ALB-DNS>/

```

**Test Health**

```bash
curl http://<ALB-DNS>/health

```

**Test Database**

```bash
curl http://<ALB-DNS>/database

```

The React frontend is hosted on Amazon S3 and can be accessed via `http://<S3-WEBSITE-ENDPOINT>/`.

---

## ✅ Project Status: Completed

* [x] AWS VPC (Public/Private Subnets, IGW, NAT Gateway, Route Tables)
* [x] Security Groups & IAM
* [x] Application Load Balancer & Target Group
* [x] EC2 & Auto Scaling Group
* [x] Docker & Amazon ECR
* [x] Amazon RDS MySQL
* [x] AWS Secrets Manager & Systems Manager
* [x] Amazon S3
* [x] CloudWatch
* [x] Terraform
* [x] Jenkins CI/CD (Backend & Frontend pipelines)

---

## 🔮 Future Improvements

* **CloudFront:** Add Amazon CloudFront in front of the S3 frontend for CDN, caching, and edge locations.
* **Route 53:** Add a custom domain (e.g., `www.example.com`).
* **HTTPS / ACM:** Use AWS Certificate Manager to enable HTTPS.
* **AWS WAF:** Add web application firewall protection.
* **SNS Notifications:** Connect CloudWatch alarms to SNS for email alerts.
* **GitHub Webhooks:** Trigger Jenkins automatically on `git push`.
* **Zero-Downtime Deployment:** Refine Docker deployment strategies.
* **ECS / Fargate:** Migrate from manually managed EC2 instances to AWS ECS/Fargate.

---

## 🎯 DevOps Skills Demonstrated

`AWS` `Docker` `Terraform` `Jenkins` `CI/CD` `Linux` `Git` `Python` `Flask` `React` `Containerization` `Monitoring` `Infrastructure as Code`

---

**👨‍💻 Author:** Saran PS

**⭐ Final Result:** A fully automated, robust, and scalable cloud-native web application.

```

```
