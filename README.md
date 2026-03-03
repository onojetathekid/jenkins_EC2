# Jenkins on EC2 — Terraform Deployment

This project provisions a Jenkins CI/CD server on AWS using Terraform. It builds a full networking stack from scratch and deploys a Jenkins instance on an EC2 machine, with Jenkins automatically installed and started via a user data bootstrap script.

---

## Architecture Overview

```
Internet
   │
   ▼
Internet Gateway
   │
   ▼
Public Subnets (us-east-1a/b/c)
   │                    │
   ▼                    ▼
EC2 (Jenkins)      NAT Gateway
  :8080                 │
                        ▼
              Private Subnets (us-east-1a/b/c)
```

### Resources Created

| File | Resource |
|---|---|
| `0-auth.tf` | AWS Provider & Terraform config |
| `1-vpc.tf` | VPC (`10.220.0.0/16`) |
| `2-subnets.tf` | 3 public + 3 private subnets across AZs |
| `3-igw.tf` | Internet Gateway |
| `4-nat.tf` | Elastic IP + NAT Gateway |
| `5-route.tf` | Public & private route tables + associations |
| `6-SG.tf` | Security Group (ports 22, 80, 8080 inbound) |
| `7-EC2.tf` | EC2 instance (Amazon Linux 2023, t3.micro) |
| `jenkins.sh` | User data script — installs Jenkins + Nginx |
| `output.tf` | Outputs Jenkins URL and initial password command |

---

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- AWS CLI configured with a `default` profile (`aws configure`)
- Sufficient IAM permissions to create VPC, EC2, and networking resources

---

## Usage

### 1. Clone the repository

```bash
git clone https://github.com/your-username/jenkins_EC2.git
cd jenkins_EC2
```

### 2. Initialise Terraform

```bash
terraform init
```

### 3. Review the plan

```bash
terraform plan
```

### 4. Deploy

```bash
terraform apply
```

Type `yes` when prompted. Deployment typically takes 3–5 minutes.

### 5. Access Jenkins

After apply completes, Terraform will output your Jenkins URL:

```
jenkins_details = {
  url = "http://<PUBLIC_IP>:8080"
  command_to_get_pwd = "sudo cat /var/lib/jenkins/secrets/initialAdminPassword"
}
```

Open the URL in your browser. To retrieve the initial admin password, SSH into the instance and run:

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

---

## Networking Details

| Subnet | CIDR | AZ |
|---|---|---|
| Public 1 | `10.220.1.0/24` | us-east-1a |
| Public 2 | `10.220.2.0/24` | us-east-1b |
| Public 3 | `10.220.3.0/24` | us-east-1c |
| Private 1 | `10.220.11.0/24` | us-east-1a |
| Private 2 | `10.220.12.0/24` | us-east-1b |
| Private 3 | `10.220.13.0/24` | us-east-1c |

---

## Security Group Rules

| Direction | Port | Protocol | Source |
|---|---|---|---|
| Inbound | 22 | TCP | `0.0.0.0/0` |
| Inbound | 80 | TCP | `0.0.0.0/0` |
| Inbound | 8080 | TCP | `0.0.0.0/0` |
| Outbound | All | All | `0.0.0.0/0` |

> **Note:** Port 22 and 8080 are open to the world (`0.0.0.0/0`). For production use, restrict the SSH CIDR to your own IP.

---

## What `jenkins.sh` Does

The EC2 user data script runs at first boot and:

1. Updates system packages
2. Adds the Jenkins YUM repository
3. Imports the Jenkins GPG key
4. Installs Java 21 (Amazon Corretto)
5. Installs and starts the Jenkins service
6. Installs Nginx and configures a health check endpoint on port `8081`

---

## Teardown

To destroy all resources and avoid ongoing AWS charges:

```bash
terraform destroy
```

---

## Tags

All resources are tagged with:

```hcl
Project   = "Network-Base"
Date      = "2026-02-16"
ManagedBy = "El Pollo Loco"
Theme     = "Quick Network Deployment"
```
