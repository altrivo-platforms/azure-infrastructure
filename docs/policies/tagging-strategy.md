# Resource Tagging Strategy

**Document Version:** 1.0  
**Last Updated:** January 10, 2026  
**Status:** Active Policy  
**Owner:** Platform Team

---

## 📋 Purpose

This document defines the standardized tagging strategy for all Azure resources. Proper tagging enables cost tracking, automation, governance, and operational management across the platform.

---

## 🎯 Tagging Objectives

### Business Objectives

- **Cost Allocation:** Track spending by project, environment, and cost center
- **Chargeback:** Allocate costs to appropriate departments
- **Budget Management:** Monitor spending against budgets
- **Resource Ownership:** Identify responsible teams and individuals

### Technical Objectives

- **Automation:** Enable automated operations based on tags
- **Compliance:** Meet regulatory and audit requirements
- **Resource Management:** Identify resources for lifecycle operations
- **Search & Discovery:** Quickly find resources by attributes

---

## 🏷️ Mandatory Tags

**ALL Azure resources MUST have these tags:**

### Tag Definitions

| Tag Name        | Description                 | Allowed Values               | Example                |
| --------------- | --------------------------- | ---------------------------- | ---------------------- |
| **Environment** | Deployment environment      | `dev`, `staging`, `prod`     | `dev`                  |
| **Project**     | Project identifier          | `azure-platform`             | `azure-platform`       |
| **Owner**       | Team or person responsible  | Team name or email           | `platform-team`        |
| **CostCenter**  | Cost allocation code        | Department/cost center       | `engineering`          |
| **ManagedBy**   | Provisioning method         | `terraform`, `manual`, `arm` | `terraform`            |
| **CreatedBy**   | User who created resource   | User email address           | `user@domain.com`      |
| **CreatedDate** | Resource creation timestamp | ISO 8601 format              | `2026-01-10T10:00:00Z` |

### Terraform Implementation

```hcl
# Define common tags as a variable
variable "common_tags" {
  description = "Common tags applied to all resources"
  type        = map(string)
  default = {
    Environment   = "dev"
    Project       = "azure-platform"
    Owner         = "platform-team"
    CostCenter    = "engineering"
    ManagedBy     = "terraform"
    CreatedBy     = "yourname+dev@outlook.com"
    CreatedDate   = "2026-01-10T10:00:00Z"
  }
}

# Apply to resources using merge function
resource "azurerm_resource_group" "main" {
  name     = "rg-azureplatform-dev"
  location = "East US"

  tags = merge(
    var.common_tags,
    {
      ResourceType = "ResourceGroup"
      Purpose      = "Infrastructure foundational services"
    }
  )
}

resource "azurerm_virtual_network" "main" {
  name                = "vnet-azureplatform-dev-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  address_space       = ["10.0.0.0/16"]

  tags = merge(
    var.common_tags,
    {
      ResourceType = "VirtualNetwork"
      Purpose      = "Primary network for application workloads"
    }
  )
}
```

---

## 🔖 Optional Tags

**Use these tags when applicable:**

| Tag Name               | Description                  | Example                              | When to Use                  |
| ---------------------- | ---------------------------- | ------------------------------------ | ---------------------------- |
| **Application**        | Application identifier       | `web-app`, `api-service`             | Multi-app environments       |
| **Version**            | Application/resource version | `1.0.0`, `2.1.3`                     | Versioned deployments        |
| **DataClassification** | Data sensitivity level       | `public`, `internal`, `confidential` | Resources handling data      |
| **Backup**             | Backup frequency             | `daily`, `weekly`, `none`            | Resources requiring backup   |
| **DisasterRecovery**   | DR strategy                  | `replicated`, `local`, `none`        | DR-enabled resources         |
| **Monitoring**         | Monitoring status            | `enabled`, `disabled`                | Observability tracking       |
| **SecurityLevel**      | Security classification      | `high`, `medium`, `low`              | Security-sensitive resources |
| **Compliance**         | Compliance requirements      | `hipaa`, `pci-dss`, `gdpr`           | Regulated workloads          |
| **SLA**                | Service level agreement      | `99.9`, `99.95`, `none`              | SLA-committed resources      |
| **AutoShutdown**       | Auto-shutdown schedule       | `enabled`, `disabled`                | Cost optimization            |
| **MaintenanceWindow**  | Maintenance schedule         | `saturday-2am-4am`                   | Scheduled maintenance        |
| **Department**         | Responsible department       | `engineering`, `marketing`           | Organizational tracking      |

### Example with Optional Tags

```hcl
resource "azurerm_postgresql_flexible_server" "main" {
  name                = "psql-azureplatform-dev-001"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  # ... other configuration ...

  tags = merge(
    var.common_tags,
    {
      ResourceType        = "PostgreSQL"
      Purpose             = "Primary application database"
      DataClassification  = "confidential"
      Backup              = "daily"
      DisasterRecovery    = "replicated"
      Monitoring          = "enabled"
      SecurityLevel       = "high"
      SLA                 = "99.9"
    }
  )
}
```

---

## 📊 Tag Value Standards

### Environment Tag Values

| Value     | Description             | Use Case                 |
| --------- | ----------------------- | ------------------------ |
| `dev`     | Development environment | Testing, experimentation |
| `staging` | Staging/UAT environment | Pre-production testing   |
| `prod`    | Production environment  | Live customer workloads  |
| `sandbox` | Sandbox environment     | Learning, POCs           |
| `dr`      | Disaster recovery       | DR resources             |

### ManagedBy Tag Values

| Value       | Description                     |
| ----------- | ------------------------------- |
| `terraform` | Provisioned via Terraform       |
| `arm`       | Provisioned via ARM templates   |
| `manual`    | Manually created via Portal/CLI |
| `script`    | Provisioned via scripts         |

### DataClassification Tag Values

| Value          | Description              | Examples                            |
| -------------- | ------------------------ | ----------------------------------- |
| `public`       | Publicly accessible data | Marketing content, documentation    |
| `internal`     | Internal-only data       | Employee directories, internal docs |
| `confidential` | Sensitive business data  | Customer data, financial records    |
| `restricted`   | Highly sensitive data    | Credentials, PII, PHI               |

---

## 🔍 Tag Governance & Enforcement

### Tag Validation in Terraform

```hcl
# Variable validation for environment tag
variable "environment" {
  description = "Environment name"
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be dev, staging, or prod."
  }
}

# Variable validation for data classification
variable "data_classification" {
  description = "Data sensitivity classification"
  type        = string
  default     = "internal"

  validation {
    condition = contains([
      "public",
      "internal",
      "confidential",
      "restricted"
    ], var.data_classification)
    error_message = "Data classification must be public, internal, confidential, or restricted."
  }
}
```

### Azure Policy for Tag Enforcement (Future)

```json
{
  "properties": {
    "displayName": "Require mandatory tags on resources",
    "policyType": "Custom",
    "mode": "Indexed",
    "description": "Enforces required tags on all resources",
    "parameters": {
      "tagName": {
        "type": "String",
        "metadata": {
          "displayName": "Tag Name",
          "description": "Name of the tag, such as 'Environment'"
        }
      }
    },
    "policyRule": {
      "if": {
        "field": "[concat('tags[', parameters('tagName'), ']')]",
        "exists": "false"
      },
      "then": {
        "effect": "deny"
      }
    }
  }
}
```

---

## 💰 Cost Management Using Tags

### Cost Allocation Queries

**Azure CLI - Get costs by environment:**

```bash
az consumption usage list \
  --start-date 2026-01-01 \
  --end-date 2026-01-31 \
  --query "[?tags.Environment=='dev'].{Name:name, Cost:pretaxCost}" \
  --output table
```

**Azure CLI - Get costs by project:**

```bash
az consumption usage list \
  --start-date 2026-01-01 \
  --end-date 2026-01-31 \
  --query "[?tags.Project=='azure-platform'].{Name:name, Cost:pretaxCost}" \
  --output table
```

### Cost Tracking Dashboard

Create custom dashboards in Azure Portal:

1. Navigate to **Cost Management + Billing**
2. Select **Cost analysis**
3. Filter by tags: `Environment=dev`, `Project=azure-platform`
4. Group by: `CostCenter`, `Owner`
5. Save as dashboard

### Budget Alerts by Tag

```hcl
resource "azurerm_consumption_budget_resource_group" "dev" {
  name              = "budget-azureplatform-dev"
  resource_group_id = azurerm_resource_group.main.id

  amount     = 300
  time_grain = "Monthly"

  time_period {
    start_date = "2026-01-01T00:00:00Z"
  }

  filter {
    tag {
      name   = "Environment"
      values = ["dev"]
    }
    tag {
      name   = "Project"
      values = ["azure-platform"]
    }
  }

  notification {
    enabled        = true
    threshold      = 80.0
    operator       = "GreaterThan"
    contact_emails = ["platform-team@company.com"]
  }

  notification {
    enabled        = true
    threshold      = 100.0
    operator       = "GreaterThan"
    contact_emails = ["platform-team@company.com"]
  }
}
```

---

## 🤖 Automation Using Tags

### Auto-Shutdown for Dev Resources

```hcl
# Logic to auto-shutdown VMs with specific tags
resource "azurerm_dev_test_global_vm_shutdown_schedule" "dev" {
  for_each = {
    for vm in azurerm_linux_virtual_machine : vm.name => vm
    if vm.tags["Environment"] == "dev" && vm.tags["AutoShutdown"] == "enabled"
  }

  virtual_machine_id = each.value.id
  location           = each.value.location
  enabled            = true

  daily_recurrence_time = "2000"  # 8 PM
  timezone              = "Eastern Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = 30
    email           = var.common_tags.CreatedBy
  }
}
```

### Resource Lifecycle Management

```bash
# Delete resources older than 30 days in dev environment
az resource list \
  --tag Environment=dev \
  --query "[?tags.CreatedDate<'2025-12-10'].id" \
  --output tsv | xargs -I {} az resource delete --ids {}
```

---

## 📈 Tag Reporting & Compliance

### Monthly Tag Compliance Report

**Script to check tag compliance:**

```bash
#!/bin/bash
# check-tag-compliance.sh

REQUIRED_TAGS=("Environment" "Project" "Owner" "CostCenter" "ManagedBy" "CreatedBy" "CreatedDate")

echo "Checking tag compliance for all resources..."

for tag in "${REQUIRED_TAGS[@]}"; do
  echo "Checking for tag: $tag"

  # Find resources missing this tag
  az resource list \
    --query "[?tags.$tag==null].{Name:name, Type:type, ResourceGroup:resourceGroup}" \
    --output table
done
```

### Compliance Dashboard Metrics

Track these KPIs:

- **Tag Coverage:** % of resources with all mandatory tags
- **Cost Attribution:** % of costs allocated to cost centers
- **Owner Assignment:** % of resources with identified owners
- **Automation-Ready:** % of resources tagged for automation

**Target:** 100% compliance for all mandatory tags

---

## 🔄 Tag Update Procedures

### Updating Existing Resource Tags

**Via Azure CLI:**

```bash
# Update single tag
az resource tag \
  --ids /subscriptions/{sub-id}/resourceGroups/{rg}/providers/Microsoft.Compute/virtualMachines/{vm} \
  --tags Environment=prod

# Update multiple tags
az resource update \
  --ids /subscriptions/{sub-id}/resourceGroups/{rg}/providers/Microsoft.Compute/virtualMachines/{vm} \
  --set tags.Owner=new-owner tags.CostCenter=new-cost-center
```

**Via Terraform:**

```hcl
# Update tags in Terraform configuration
resource "azurerm_virtual_machine" "example" {
  # ... other configuration ...

  tags = merge(
    var.common_tags,
    {
      Owner      = "new-owner"
      CostCenter = "new-cost-center"
    }
  )
}

# Apply changes
terraform plan
terraform apply
```

### Bulk Tag Updates

```bash
# Update all resources in a resource group
az group update \
  --name rg-azureplatform-dev \
  --tags Environment=dev Project=azure-platform Owner=platform-team
```

---

## 🚨 Tag Violations & Remediation

### Common Violations

| Violation             | Detection             | Remediation                   |
| --------------------- | --------------------- | ----------------------------- |
| Missing mandatory tag | Daily compliance scan | Add missing tag via Terraform |
| Incorrect tag value   | Validation failure    | Update to correct value       |
| Inconsistent casing   | Manual review         | Standardize to lowercase      |
| Outdated owner        | Quarterly review      | Update to current owner       |
| Wrong cost center     | Finance audit         | Correct allocation            |

### Remediation Process

1. **Detection:** Automated daily scan identifies non-compliant resources
2. **Notification:** Owner receives email with details
3. **Grace Period:** 7 days to remediate
4. **Escalation:** After 7 days, escalate to Platform Lead
5. **Enforcement:** After 14 days, resource may be stopped or deleted

---

## 📝 Tag Documentation Requirements

### Required Documentation per Resource Type

**For each Terraform module, document:**

- Which tags are applied
- Why specific optional tags are used
- Any custom tag logic
- Tag inheritance patterns

**Example module README:**

```markdown
## Tags Applied

### Mandatory Tags

All resources created by this module receive the common tags from `var.common_tags`:

- Environment
- Project
- Owner
- CostCenter
- ManagedBy
- CreatedBy
- CreatedDate

### Module-Specific Tags

This module adds these additional tags:

- **ResourceType:** "VirtualNetwork"
- **Purpose:** Descriptive purpose of the VNet
- **NetworkSegment:** Network classification (DMZ, Internal, Management)

### Tag Inheritance

Subnets automatically inherit tags from the parent VNet unless overridden.
```

---

## 🔍 Tag Audit Trail

### Change Tracking

All tag changes are tracked via:

1. **Git History:** Terraform code changes show tag modifications
2. **Azure Activity Log:** Records all tag create/update/delete operations
3. **Terraform State:** Tracks current vs. desired tag state
4. **Pipeline Logs:** CI/CD logs show tag changes during deployments

### Audit Query Examples

**Azure CLI - View tag change history:**

```bash
az monitor activity-log list \
  --resource-group rg-azureplatform-dev \
  --start-time 2026-01-01T00:00:00Z \
  --query "[?contains(operationName.value, 'tags')]" \
  --output table
```

**PowerShell - Export tag audit:**

```powershell
Get-AzActivityLog `
  -ResourceGroupName "rg-azureplatform-dev" `
  -StartTime (Get-Date).AddDays(-30) |
  Where-Object {$_.OperationName -like "*tags*"} |
  Export-Csv -Path "tag-audit.csv"
```

---

## 📚 Best Practices

### ✅ Do's

- **Automate tag application** via Terraform/IaC
- **Validate tags** before resource creation
- **Document tag purpose** in README files
- **Review tags quarterly** for accuracy
- **Use consistent casing** (lowercase preferred)
- **Leverage tag inheritance** where possible
- **Monitor tag compliance** continuously

### ❌ Don'ts

- **Don't manually tag** resources (use Terraform)
- **Don't use special characters** in tag values
- **Don't create duplicate tags** with different casing
- **Don't exceed 50 tags** per resource (Azure limit)
- **Don't use PII** in tag values
- **Don't ignore validation** failures
- **Don't skip tag documentation**

---

## 🎯 Tag Strategy Maturity Model

### Level 1: Basic (Current)

- Mandatory tags defined
- Manual enforcement
- Basic cost tracking

### Level 2: Intermediate (Phase 1 Goal)

- Automated tag validation in pipelines
- Tag-based automation (auto-shutdown)
- Regular compliance reporting

### Level 3: Advanced (Future)

- Azure Policy enforcement
- AI-driven tag optimization
- Real-time compliance dashboards
- Automated remediation

---

## 📅 Review & Maintenance

### Review Schedule

| Activity                 | Frequency   | Owner                   |
| ------------------------ | ----------- | ----------------------- |
| Tag compliance scan      | Daily       | Automated               |
| Owner verification       | Quarterly   | Platform Team           |
| Cost allocation review   | Monthly     | Finance + Platform Lead |
| Tag strategy update      | Bi-annually | Platform Lead           |
| Cleanup of orphaned tags | Quarterly   | Platform Engineer       |

### Tag Lifecycle

```
Tag Created → In Use → Deprecated → Removed
     ↓           ↓           ↓         ↓
  Validate   Monitor    Migrate   Cleanup
```

---

## 📚 Related Documentation

- [Naming Conventions](naming-conventions.md)
- [Cost Governance Policy](cost-governance-policy.md)
- [Terraform Style Guide](../standards/terraform-style-guide.md)

---

## 📅 Version History

| Version | Date       | Changes                  | Author        |
| ------- | ---------- | ------------------------ | ------------- |
| 1.0     | 2026-01-10 | Initial tagging strategy | Platform Team |

---

**Document Status:** Active Policy  
**Enforcement:** Mandatory for all resources  
**Review Cadence:** Quarterly  
**Next Review:** April 10, 2026
