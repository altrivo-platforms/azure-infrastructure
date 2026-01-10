# Naming Conventions

**Document Version:** 1.0  
**Last Updated:** January 10, 2026  
**Status:** Active  
**Owner:** Platform Team

---

## 📋 Purpose

This document defines standardized naming conventions for all Azure resources, Git branches, commits, and other project artifacts. Consistent naming improves discoverability, manageability, and operational efficiency.

---

## 🎯 Core Principles

1. **Descriptive:** Names should clearly indicate purpose and ownership
2. **Consistent:** Follow the same pattern across all resources
3. **Searchable:** Enable easy filtering and discovery
4. **Compliant:** Adhere to Azure naming restrictions
5. **Scalable:** Support growth without renaming

---

## ☁️ Azure Resource Naming

### General Pattern

```
{resource-type}-{project}-{environment}-{region}-{instance}

Components:
- resource-type: Abbreviated resource type (see table below)
- project: Project name (azureplatform)
- environment: dev, staging, prod
- region: Azure region abbreviation (optional)
- instance: Sequential number or purpose identifier
```

### Examples

```
rg-azureplatform-dev-001
vnet-azureplatform-prod-eastus-001
vmss-azureplatform-dev-web-001
kv-azureplatform-prod-eastus
```

---

## 📦 Azure Resource Type Abbreviations

### Compute

| Resource Type            | Abbreviation | Example                            |
| ------------------------ | ------------ | ---------------------------------- |
| Virtual Machine          | vm           | `vm-azureplatform-dev-web-001`     |
| VM Scale Set             | vmss         | `vmss-azureplatform-prod-app-001`  |
| Azure Kubernetes Service | aks          | `aks-azureplatform-prod-eastus`    |
| Container Instance       | aci          | `aci-azureplatform-dev-worker-001` |
| App Service              | app          | `app-azureplatform-prod-api`       |
| Function App             | func         | `func-azureplatform-dev-processor` |

### Networking

| Resource Type          | Abbreviation | Example                        |
| ---------------------- | ------------ | ------------------------------ |
| Virtual Network        | vnet         | `vnet-azureplatform-dev-001`   |
| Subnet                 | snet         | `snet-azureplatform-dev-app`   |
| Network Security Group | nsg          | `nsg-azureplatform-dev-app`    |
| Public IP Address      | pip          | `pip-azureplatform-prod-appgw` |
| Load Balancer          | lb           | `lb-azureplatform-prod-001`    |
| Application Gateway    | appgw        | `appgw-azureplatform-prod-001` |
| VPN Gateway            | vpngw        | `vpngw-azureplatform-prod-001` |
| Azure Bastion          | bas          | `bas-azureplatform-dev`        |
| Private Endpoint       | pe           | `pe-azureplatform-dev-kv`      |

### Storage

| Resource Type   | Abbreviation | Example                    |
| --------------- | ------------ | -------------------------- |
| Storage Account | st           | `stazureplatformdev001` \* |
| Blob Container  | blob         | `blob-backups`             |
| File Share      | share        | `share-data`               |
| Queue           | queue        | `queue-messages`           |
| Table           | table        | `table-logs`               |

_Note: Storage accounts cannot contain hyphens and must be globally unique_

### Data & Databases

| Resource Type      | Abbreviation | Example                         |
| ------------------ | ------------ | ------------------------------- |
| Azure SQL Database | sqldb        | `sqldb-azureplatform-prod-001`  |
| Azure SQL Server   | sql          | `sql-azureplatform-prod-eastus` |
| PostgreSQL Server  | psql         | `psql-azureplatform-dev-001`    |
| MySQL Server       | mysql        | `mysql-azureplatform-dev-001`   |
| Cosmos DB          | cosmos       | `cosmos-azureplatform-prod`     |
| Redis Cache        | redis        | `redis-azureplatform-prod`      |

### Security & Identity

| Resource Type    | Abbreviation | Example                           |
| ---------------- | ------------ | --------------------------------- |
| Key Vault        | kv           | `kv-azureplatform-prod-eastus` \* |
| Managed Identity | id           | `id-azureplatform-dev-vmss`       |

_Note: Key Vault names must be globally unique, 3-24 characters_

### Management & Governance

| Resource Type           | Abbreviation | Example                  |
| ----------------------- | ------------ | ------------------------ |
| Resource Group          | rg           | `rg-azureplatform-dev`   |
| Log Analytics Workspace | la           | `la-azureplatform-prod`  |
| Application Insights    | appi         | `appi-azureplatform-dev` |
| Azure Monitor           | mon          | `mon-azureplatform-prod` |
| Recovery Services Vault | rsv          | `rsv-azureplatform-prod` |

---

## 🔤 Naming Rules & Restrictions

### General Rules

- **Case:** Use lowercase for all resource names (Azure requirement)
- **Separators:** Use hyphens (-) to separate components
- **Special Characters:** Avoid except hyphens (some resources don't allow hyphens)
- **Length:** Keep names under 24 characters when possible
- **Uniqueness:** Some resources require globally unique names (Storage, Key Vault)

### Azure-Specific Restrictions

| Resource Type   | Max Length | Allowed Characters                      | Global Uniqueness |
| --------------- | ---------- | --------------------------------------- | ----------------- |
| Storage Account | 24         | Lowercase letters, numbers (no hyphens) | Yes               |
| Key Vault       | 24         | Letters, numbers, hyphens               | Yes               |
| Resource Group  | 90         | Letters, numbers, hyphens, underscores  | No                |
| Virtual Network | 64         | Letters, numbers, hyphens, underscores  | No                |
| VM Scale Set    | 64         | Letters, numbers, hyphens               | No                |

---

## 🌍 Region Abbreviations (Optional)

Use when deploying to multiple regions:

| Azure Region   | Abbreviation  |
| -------------- | ------------- |
| East US        | eastus        |
| West US        | westus        |
| Central US     | centralus     |
| North Europe   | northeu       |
| West Europe    | westeu        |
| Southeast Asia | southeastasia |
| East Asia      | eastasia      |

**Example:**

```
vnet-azureplatform-prod-eastus-001
vnet-azureplatform-prod-westeu-001
```

---

## 🔀 Git Branch Naming

### Pattern

```
{type}/{description}

Types:
- feature: New functionality
- bugfix: Bug fixes
- hotfix: Emergency production fixes
- docs: Documentation changes
- chore: Maintenance tasks
- refactor: Code restructuring
- test: Test additions or modifications
```

### Examples

```bash
feature/add-monitoring-module
bugfix/fix-nsg-rule-typo
hotfix/emergency-security-patch
docs/update-architecture-diagram
chore/upgrade-terraform-version
refactor/simplify-networking-module
test/add-vmss-scaling-tests
```

### Branch Naming Rules

- **Lowercase:** All branch names in lowercase
- **Hyphens:** Use hyphens to separate words
- **Descriptive:** Clearly indicate what the branch does
- **Concise:** Keep under 50 characters
- **No Spaces:** Use hyphens instead of spaces

---

## 💬 Commit Message Conventions

### Pattern (Conventional Commits)

```
{type}({scope}): {subject}

{body}

{footer}
```

### Commit Types

| Type         | Description             | Example                                          |
| ------------ | ----------------------- | ------------------------------------------------ |
| **feat**     | New feature             | `feat(networking): Add VNet peering`             |
| **fix**      | Bug fix                 | `fix(security): Correct NSG rule priority`       |
| **docs**     | Documentation only      | `docs(runbooks): Add VM recovery procedure`      |
| **style**    | Formatting changes      | `style(terraform): Run terraform fmt`            |
| **refactor** | Code restructuring      | `refactor(modules): Simplify variable structure` |
| **test**     | Add/modify tests        | `test(vmss): Add scaling behavior tests`         |
| **chore**    | Maintenance tasks       | `chore(deps): Upgrade AzureRM provider`          |
| **perf**     | Performance improvement | `perf(vmss): Optimize instance startup`          |
| **ci**       | CI/CD changes           | `ci(pipeline): Add Terraform validation step`    |
| **build**    | Build system changes    | `build(terraform): Update module dependencies`   |

### Commit Message Examples

**Good Examples:**

```bash
feat(monitoring): Add CPU and memory alerts

Implemented Azure Monitor alerts for:
- CPU utilization > 80% for 5 minutes
- Memory utilization > 85% for 5 minutes
- Disk space < 20% available

Alerts send notifications to platform-team@company.com
```

```bash
fix(security): Correct PostgreSQL NSG rule

The DB subnet NSG was allowing traffic from 0.0.0.0/0.
Updated rule to only allow traffic from app subnet (10.0.2.0/24).

Closes #42
```

```bash
docs(architecture): Update network diagram

Added private endpoint connections to architecture diagram.
Reflects current state after Phase 1 completion.
```

**Bad Examples:**

```bash
# ❌ Too vague
update stuff

# ❌ No type prefix
Add monitoring

# ❌ Not descriptive
fix bug

# ❌ Multiple concerns
feat: Add monitoring, fix NSG, update docs
```

### Commit Message Rules

- **Subject Line:**

  - Max 50 characters
  - Start with lowercase type
  - No period at the end
  - Imperative mood ("Add" not "Added" or "Adds")

- **Body (Optional):**

  - Wrap at 72 characters
  - Explain WHAT and WHY, not HOW
  - Separate from subject with blank line

- **Footer (Optional):**
  - Reference issues: `Closes #42`, `Fixes #123`
  - Breaking changes: `BREAKING CHANGE: description`

---

## 📝 Pull Request Naming

### Pattern

Same as commit message format:

```
{type}({scope}): {subject}
```

### Examples

```
feat(monitoring): Add Azure Monitor module
fix(security): Correct NSG rule configuration
docs(runbooks): Add deployment procedures
chore(terraform): Upgrade to AzureRM 3.80
```

---

## 📁 File & Directory Naming

### Terraform Files

```
main.tf              # Primary resource definitions
variables.tf         # Input variable declarations
outputs.tf           # Output value definitions
providers.tf         # Provider configuration
versions.tf          # Terraform and provider version constraints
data.tf             # Data source definitions
locals.tf           # Local value definitions
```

### Module Directories

```
modules/
├── networking/     # Network resources (VNet, NSG)
├── compute/        # Compute resources (VMSS, Bastion)
├── security/       # Security resources (Key Vault, Identity)
├── data/          # Data resources (PostgreSQL, Storage)
└── monitoring/    # Observability (Monitor, Log Analytics)
```

### Documentation Files

```
docs/
├── architecture/
│   ├── architecture-overview.md
│   ├── network-design.md
│   └── security-architecture.md
├── decisions/
│   ├── adr-001-vm-scale-sets-over-aks.md
│   ├── adr-002-private-endpoints-mandatory.md
│   └── adr-003-terraform-state-backend.md
├── runbooks/
│   ├── terraform-workflow.md
│   ├── deployment-procedures.md
│   └── vm-failure-response.md
└── policies/
    ├── change-management-policy.md
    ├── security-baseline-policy.md
    └── cost-governance-policy.md
```

---

## 🏷️ Resource Tagging

See [tagging-strategy.md](tagging-strategy.md) for comprehensive tagging requirements.

### Mandatory Tags

```hcl
tags = {
  Environment   = "dev"                         # dev, staging, prod
  Project       = "azure-platform"              # Project identifier
  Owner         = "platform-team"               # Team/person responsible
  CostCenter    = "engineering"                 # Chargeback allocation
  ManagedBy     = "terraform"                   # Provisioning method
  CreatedBy     = "user@domain.com"             # User attribution
  CreatedDate   = "2026-01-10T10:00:00Z"       # ISO 8601 timestamp
}
```

---

## ✅ Naming Validation

### Pre-Commit Checklist

Before committing code, verify:

- [ ] Azure resource names follow pattern: `{type}-{project}-{env}-{instance}`
- [ ] All resource names are lowercase
- [ ] Storage account names have no hyphens
- [ ] Names are under length limits
- [ ] Branch name follows `{type}/{description}` pattern
- [ ] Commit message follows Conventional Commits format
- [ ] All resources have mandatory tags

### Terraform Validation

```hcl
# Example: Variable validation for naming
variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string

  validation {
    condition     = can(regex("^rg-[a-z0-9-]+$", var.resource_group_name))
    error_message = "Resource group name must start with 'rg-' and contain only lowercase letters, numbers, and hyphens."
  }
}
```

---

## 🔧 Automation & Enforcement

### GitHub Actions (Future)

```yaml
# .github/workflows/naming-validation.yml
name: Naming Convention Validation

on: [pull_request]

jobs:
  validate-naming:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Validate Resource Names
        run: |
          # Check Terraform files for naming compliance
          ./scripts/validate-naming.sh
```

### Azure Policy (Future)

```json
{
  "if": {
    "allOf": [
      {
        "field": "type",
        "equals": "Microsoft.Compute/virtualMachines"
      },
      {
        "field": "name",
        "notMatch": "vm-*"
      }
    ]
  },
  "then": {
    "effect": "deny"
  }
}
```

---

## 📊 Naming Convention Quick Reference

### Resource Naming Cheat Sheet

```bash
# Resource Groups
rg-{project}-{env}
Example: rg-azureplatform-dev

# VNets
vnet-{project}-{env}-{instance}
Example: vnet-azureplatform-prod-001

# Subnets
snet-{project}-{env}-{purpose}
Example: snet-azureplatform-dev-app

# VM Scale Sets
vmss-{project}-{env}-{purpose}-{instance}
Example: vmss-azureplatform-prod-web-001

# Storage Accounts (no hyphens!)
st{project}{env}{instance}
Example: stazureplatformdev001

# Key Vault
kv-{project}-{env}-{region}
Example: kv-azureplatform-prod-eastus

# PostgreSQL
psql-{project}-{env}-{instance}
Example: psql-azureplatform-dev-001
```

### Git Naming Cheat Sheet

```bash
# Branches
{type}/{description}
Examples:
- feature/add-monitoring
- bugfix/fix-nsg-rule
- hotfix/security-patch

# Commits
{type}({scope}): {subject}
Examples:
- feat(monitoring): Add CPU alerts
- fix(security): Correct NSG rule
- docs(runbooks): Add VM recovery
```

---

## 🔍 Common Mistakes to Avoid

### ❌ Bad Examples

```bash
# Inconsistent casing
VM-AzurePlatform-Dev-001  # ❌ Mixed case
vm-azureplatform-dev-001  # ✅ All lowercase

# Missing components
rg-dev                    # ❌ Missing project name
rg-azureplatform-dev      # ✅ Includes project

# Non-descriptive names
vm-001                    # ❌ No context
vm-azureplatform-dev-web-001  # ✅ Descriptive

# Storage with hyphens
st-azureplatform-dev-001  # ❌ Hyphens not allowed
stazureplatformdev001     # ✅ No hyphens

# Too generic
myvm, test, temp          # ❌ Not descriptive
vmss-azureplatform-dev-app-001  # ✅ Clear purpose
```

---

## 📚 Related Documentation

- [Tagging Strategy](tagging-strategy.md)
- [Terraform Style Guide](../standards/terraform-style-guide.md)
- [Git Workflow Guide](../standards/git-workflow-guide.md)

---

## 📅 Version History

| Version | Date       | Changes                    | Author        |
| ------- | ---------- | -------------------------- | ------------- |
| 1.0     | 2026-01-10 | Initial naming conventions | Platform Team |

---

**Document Status:** Active Policy  
**Enforcement:** Mandatory for all resources  
**Review Cadence:** Quarterly  
**Next Review:** April 10, 2026
