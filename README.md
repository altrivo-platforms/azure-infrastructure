# Azure Platform Foundation

**Production-Ready Azure Infrastructure with Terraform, CI/CD, Security & Observability**

[![Project Status](https://img.shields.io/badge/Status-Phase%200%20Complete-success)]()
[![Terraform](https://img.shields.io/badge/Terraform-1.3+-purple)]()
[![Azure](https://img.shields.io/badge/Azure-Platform-blue)]()

---

## 📋 Project Overview

This project demonstrates enterprise-grade Azure infrastructure management using Infrastructure as Code (IaC), modern DevOps practices, and production-ready security controls. It showcases how modern IT and product-based companies design, deploy, and operate cloud platforms.

**Key Characteristics:**

- **Security-First Design:** Zero trust networking, private endpoints, Managed Identity
- **Infrastructure as Code:** 100% Terraform, zero manual Azure Portal provisioning
- **Automated CI/CD:** Azure DevOps pipelines with approval gates
- **Separation of Duties:** Platform Engineer and Platform Lead roles
- **Cost Governance:** Budget tracking, resource tagging, auto-shutdown policies
- **Operational Excellence:** Runbooks, monitoring, alerting, disaster recovery

---

## 🎯 Target Audience

This platform is designed for professionals pursuing:

- ☁️ **Cloud Engineer** roles
- 🏗️ **Platform Engineer** positions
- 🔧 **Azure Administrator** (AZ-104) certification
- 🚀 **Junior to Mid-Level DevOps Engineer** opportunities

---

## 🏗️ Architecture Summary

```
┌─────────────────────────────────────────────────────────┐
│              Production Azure Platform                  │
│                                                         │
│  🌐 Networking                                          │
│  ├─ VNet with 3 subnets (app, db, management)          │
│  ├─ Network Security Groups                            │
│  └─ Private Endpoints                                  │
│                                                         │
│  🖥️ Compute & Traffic                                   │
│  ├─ VM Scale Set (horizontal scaling)                  │
│  ├─ Application Gateway (L7 + WAF)                     │
│  └─ Azure Bastion (secure management)                  │
│                                                         │
│  💾 Data & Storage                                      │
│  ├─ PostgreSQL Flexible Server (private only)          │
│  └─ Azure Blob Storage (private endpoint)              │
│                                                         │
│  🔐 Security & Identity                                 │
│  ├─ Azure Entra ID + RBAC                              │
│  ├─ Managed Identity                                   │
│  └─ Azure Key Vault                                    │
│                                                         │
│  📊 Observability                                       │
│  ├─ Azure Monitor                                      │
│  ├─ Log Analytics Workspace                           │
│  └─ Custom Alerts                                      │
│                                                         │
│  💰 Governance                                          │
│  ├─ Resource Tagging                                   │
│  └─ Budget Alerts                                      │
└─────────────────────────────────────────────────────────┘
```

---

## 📁 Repository Structure

```
azure-infrastructure/
│
├── .azuredevops/              # CI/CD Pipelines
│   └── pipelines/
│       ├── terraform-plan.yml
│       ├── terraform-apply.yml
│       └── pr-validation.yml
│
├── .github/                   # GitHub Configuration
│   └── CODEOWNERS            # Automatic reviewer assignment
│
├── environments/              # Environment-specific configs
│   ├── dev/
│   │   ├── terraform.tfvars
│   │   └── backend.tf
│   └── prod/
│       ├── terraform.tfvars
│       └── backend.tf
│
├── modules/                   # Reusable Terraform modules
│   ├── networking/           # VNet, subnets, NSGs
│   ├── compute/              # VMSS, Bastion
│   ├── security/             # Key Vault, Managed Identity
│   ├── data/                 # PostgreSQL, Storage
│   └── monitoring/           # Monitor, Log Analytics
│
├── docs/                      # Documentation
│   ├── architecture/         # Architecture diagrams & design
│   ├── decisions/            # Architecture Decision Records (ADRs)
│   ├── runbooks/             # Operational procedures
│   ├── policies/             # Governance policies
│   ├── standards/            # Development standards
│   ├── cicd/                 # Pipeline documentation
│   └── environments/         # Environment configurations
│
├── main.tf                    # Root module orchestration
├── variables.tf               # Input variables
├── outputs.tf                 # Output values
├── providers.tf               # Provider configuration
├── .gitignore                 # Git exclusions
└── README.md                  # This file
```

---

## 🔐 Terraform Backend (Remote State)

The infrastructure state is stored in a centralized, secure Azure Storage Account (bootstrapped via `infrastructure/scripts/setup-remote-state.sh`).

| Resource            | Value                                    |
| :------------------ | :--------------------------------------- |
| **Resource Group**  | `rg-azureplatform-prod-centralindia-001` |
| **Storage Account** | `stazplatprod7bf60d`                     |
| **Container**       | `tfstate`                                |
| **Region**          | Central India                            |
| **State Key**       | `terraform.tfstate`                      |

> **⚠️ Security Note:**
> The **Access Key** for this storage account is stored in the team's password manager (or Azure Key Vault).
> **DO NOT** commit the access key to this repository.

### How to Authenticate

Developers with `Contributor` access can initialize Terraform using their Azure AD credentials:

```bash
# Login to Azure
az login

# Initialize Terraform (will automatically use the backend config)
terraform init

```

## 🚀 Quick Start

### Prerequisites

- Active Azure subscription (Pay-As-You-Go)
- Azure CLI installed (`az --version`)
- Terraform 1.3+ installed (`terraform --version`)
- Git Bash (Windows) or Terminal (Mac/Linux)
- Two GitHub accounts (Platform Engineer + Platform Lead)

### Initial Setup

1. **Clone the Repository**

   ```bash
   # As Platform Lead
   git clone git@github.com-lead:altrivo-platform/azure-infrastructure.git
   cd azure-infrastructure

   # Configure Git identity
   git config user.name "Platform Lead Name"
   git config user.email "yourname+lead@domain.com"
   ```

2. **Verify Phase 0 Completion**

   - [ ] Azure Entra ID users created
   - [ ] RBAC roles assigned
   - [ ] Azure DevOps organization setup
   - [ ] GitHub Organization created
   - [ ] Branch protection enabled
   - [ ] SSH keys configured

3. **Review Documentation**
   - Read `docs/architecture/architecture-overview.md`
   - Review `docs/policies/change-management-policy.md`
   - Understand `docs/runbooks/terraform-workflow.md`

---

## 🔄 Development Workflow

### Daily Workflow (Platform Engineer)

```bash
# 1. Sync with latest changes
git checkout main
git pull origin main

# 2. Create feature branch
git checkout -b feature/add-monitoring-module

# 3. Make changes
# (Edit Terraform files)

# 4. Commit changes
git add .
git commit -m "feat(monitoring): Add Azure Monitor module"

# 5. Push to GitHub
git push origin feature/add-monitoring-module

# 6. Create Pull Request on GitHub
# 7. Wait for Platform Lead review
# 8. After merge, sync main
git checkout main
git pull origin main
git branch -d feature/add-monitoring-module
```

### Code Review & Approval (Platform Lead)

1. Receive PR notification
2. Review code changes in GitHub
3. Check Terraform plan output in Azure DevOps
4. Approve or request changes
5. Merge PR after approval
6. Monitor deployment to dev environment

---

## 🔐 Security & Compliance

### Security Principles

- **Zero Trust Networking:** No public IPs on VMs or databases
- **Private Endpoints:** All PaaS services accessed via VNet only
- **Managed Identity:** No credentials in code or configuration
- **Key Vault:** Centralized secrets management
- **RBAC:** Least privilege access control
- **Audit Logging:** All changes tracked in Git and Azure logs

### Compliance

- All resources tagged for auditability
- Change management enforced via PR workflow
- Approval gates for production deployments
- Encryption at rest and in transit
- Regular access reviews

---

## 💰 Cost Management

### Budget Allocation

| Environment | Monthly Budget | Auto-Shutdown                   |
| ----------- | -------------- | ------------------------------- |
| Dev         | $300           | Enabled (8 PM - 8 AM, weekends) |
| Prod        | $200           | Disabled (always on)            |
| **Total**   | **$500**       | -                               |

### Cost Optimization Strategies

- Right-sized VM SKUs based on workload
- Auto-shutdown for non-production environments
- Storage lifecycle policies
- Reserved instances for predictable workloads
- Regular cost reviews and optimization

---

## 📊 Monitoring & Observability

### Key Metrics Monitored

- **Compute:** CPU, memory, disk utilization
- **Network:** Bandwidth, latency, packet loss
- **Application:** Response time, error rates
- **Database:** Connections, query performance
- **Cost:** Daily spend, budget consumption

### Alerting

- CPU > 80% for 5 minutes
- Memory > 85% for 5 minutes
- Disk space < 20% available
- VMSS instance unhealthy
- Budget threshold exceeded (80%, 100%)

---

## 📚 Documentation

### Architecture & Design

- [Architecture Overview](docs/architecture/architecture-overview.md)
- [Network Design](docs/architecture/network-design.md)
- [Security Architecture](docs/architecture/security-architecture.md)

### Policies & Governance

- [Change Management Policy](docs/policies/change-management-policy.md)
- [Security Baseline Policy](docs/policies/security-baseline-policy.md)
- [Cost Governance Policy](docs/policies/cost-governance-policy.md)
- [Naming Conventions](docs/policies/naming-conventions.md)
- [Tagging Strategy](docs/policies/tagging-strategy.md)

### Operational Runbooks

- [Terraform Workflow](docs/runbooks/terraform-workflow.md)
- [Deployment Procedures](docs/runbooks/deployment-procedures.md)
- [VM Failure Response](docs/runbooks/vm-failure-response.md)
- [Access Management](docs/runbooks/access-management.md)

### Architecture Decisions

- [ADR-001: VM Scale Sets over AKS](docs/decisions/adr-001-vm-scale-sets-over-aks.md)
- [ADR-002: Private Endpoints Mandatory](docs/decisions/adr-002-private-endpoints-mandatory.md)
- [ADR-003: Terraform State Backend](docs/decisions/adr-003-terraform-state-backend.md)
- [ADR-004: GitHub Organization Model](docs/decisions/adr-004-github-organization-model.md)

---

## 🎓 AZ-104 Exam Alignment

This project covers key AZ-104 exam objectives:

| Exam Objective                              | Coverage in This Project                        |
| ------------------------------------------- | ----------------------------------------------- |
| **Manage Azure identities and governance**  | Azure Entra ID, RBAC, tagging, budgets          |
| **Implement and manage storage**            | Blob Storage, redundancy, lifecycle policies    |
| **Deploy and manage Azure compute**         | VM Scale Sets, availability zones, auto-scaling |
| **Configure and manage virtual networking** | VNet, subnets, NSGs, private endpoints          |
| **Monitor and maintain Azure resources**    | Azure Monitor, Log Analytics, alerts            |

---

## 👥 Team & Roles

### Platform Engineer

- **Responsibilities:** Infrastructure development, Terraform coding, dev deployments
- **Azure RBAC:** Contributor (Resource Group scope)
- **Azure DevOps:** Build Administrator
- **GitHub:** Write access to repository

### Platform Lead

- **Responsibilities:** Production approvals, RBAC management, cost governance
- **Azure RBAC:** Owner (Subscription scope)
- **Azure DevOps:** Project Administrator
- **GitHub:** Admin access to organization

---

## 🔗 Important Links

### Azure Resources

- **Azure Portal:** https://portal.azure.com
- **Subscription:** [Your Subscription Name]
- **Resource Groups:**
  - Dev: `rg-azureplatform-dev`
  - Prod: `rg-azureplatform-prod`

### CI/CD & Version Control

- **GitHub Organization:** https://github.com/altrivo-platform
- **Repository:** https://github.com/altrivo-platform/azure-infrastructure
- **Azure DevOps:** https://dev.azure.com/altrivo-azure-platform/azure-infrastructure

---

## 📞 Contact & Support

**Project Owner:** [Your Name]

- **Email:** yourname@domain.com
- **LinkedIn:** [Your LinkedIn Profile]
- **GitHub:** [Your GitHub Profile]

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- Inspired by real-world enterprise platform engineering practices
- Built for demonstrating production-grade Azure infrastructure skills
- Designed to support AZ-104 certification preparation

---

## 📅 Project Timeline

| Phase       | Status         | Completion Date |
| ----------- | -------------- | --------------- |
| **Phase 0** | ✅ Complete    | 2026-01-10      |
| **Phase 1** | 🔄 In Progress | TBD             |
| Phase 2     | ⏳ Pending     | TBD             |
| Phase 3     | ⏳ Pending     | TBD             |

---

**Last Updated:** January 10, 2026
**Version:** 1.0
**Document Owner:** Platform Team
