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
