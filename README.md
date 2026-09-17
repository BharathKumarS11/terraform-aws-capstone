# Terraform AWS DevOps Capstone

A production-style AWS infrastructure project built using **Terraform**, **AWS**, **GitHub Actions**, and **GitHub OIDC**.

The project demonstrates how to provision, manage, validate, and automate a complete AWS web application infrastructure using Infrastructure as Code and CI/CD.

---

## Project Overview

This project provisions a complete web application environment on AWS using Terraform.

The infrastructure includes:

- Custom VPC
- Public and private subnets
- Internet Gateway
- Route tables
- Security Groups
- IAM role and instance profile
- EC2
- Auto Scaling Group
- Application Load Balancer
- Target Group
- Amazon RDS MySQL
- Amazon S3 remote Terraform state
- Terraform state locking
- Terraform modules
- GitHub repository
- GitHub Actions
- GitHub OIDC authentication

The infrastructure can be created and managed through Terraform and automated through GitHub Actions.

---

## Architecture

```text
                    GitHub
                       |
                       v
               GitHub Actions
                       |
                       v
              GitHub OIDC / IAM
                       |
                       v
                 Terraform
                       |
                       v
                AWS Infrastructure
                       |
        +--------------+--------------+
        |                             |
        v                             v
       ALB                         Private RDS
        |                          MySQL :3306
        v
   Target Group
        |
        v
 EC2 / Auto Scaling
        |
        +---------------------------> RDS