# Terraform Workflow Runbook

**Document Type:** Operational Runbook  
**Version:** 1.0  
**Last Updated:** January 10, 2026  
**Owner:** Platform Team  
**Audience:** Platform Engineers, Platform Leads

---

## 📋 Purpose

This runbook provides step-by-step procedures for common Terraform operations in the Azure Platform Foundation project. Follow these procedures to ensure consistent, reliable infrastructure deployments.

---

## 🎯 Quick Navigation

- [Daily Workflow](#daily-workflow)
- [Creating New Resources](#creating-new-resources)
- [Modifying Existing Resources](#modifying-existing-resources)
- [Creating New Modules](#creating-new-modules)
- [Troubleshooting](#troubleshooting)
- [Emergency Procedures](#emergency-procedures)

---

## 📅 Daily Workflow

### Morning Routine (Both Roles)

**Purpose:** Sync your local workspace with latest changes

**Time:** 2-3 minutes

**Steps:**

```bash
# 1. Navigate to your workspace
cd ~/engineer-workspace/azure-infrastructure
# OR
cd ~/lead-workspace/azure-infrastructure

# 2. Ensure you're on main branch
git checkout main

# 3. Pull latest changes from GitHub
git pull origin main

# 4. Verify identity configuration
git config user.name
git config user.email

# Expected output should match your user:
# Platform Engineer: "Karan Parab" / karan.parab+dev@outlook.com
# Platform Lead: "Nikhil Mhatre" / nikhil.mhatre+lead@outlook.com

# 5. Check for pending work
git status

# Expected: "Your branch is up to date with 'origin/main'"
```

**Success Criteria:**

- ✅ Local main branch matches remote
- ✅ Working directory is clean
- ✅ Git identity is correct

**Troubleshooting:**

- If conflicts exist: `git stash` → `git pull` → `git stash pop`
- If identity wrong: `git config user.name "Correct Name"` and `git config user.email "correct@email.com"`

---

## 🆕 Creating New Resources

### Scenario: Add Monitoring Alerts

**Performed By:** Platform Engineer  
**Time Required:** 2-3 hours  
**Risk Level:** Low

---

### Step 1: Create Feature Branch

```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Create feature branch with descriptive name
git checkout -b feature/add-cpu-memory-alerts

# Verify you're on the new branch
git branch
# Should show: * feature/add-cpu-memory-alerts
```

---

### Step 2: Locate or Create Module

```bash
# Navigate to appropriate module directory
cd modules/monitoring

# List existing files
ls -la

# Expected structure:
# main.tf         - Resource definitions
# variables.tf    - Input variables
# outputs.tf      - Output values
# README.md       - Module documentation
```

---

### Step 3: Add Terraform Resources

**Edit `modules/monitoring/main.tf`:**

```hcl
# Add CPU alert rule
resource "azurerm_monitor_metric_alert" "cpu_alert" {
  name                = "alert-${var.project}-${var.environment}-cpu-high"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Alert when CPU exceeds 80% for 5 minutes"
  severity            = 2
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  window_size        = "PT5M"
  frequency          = "PT1M"

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = merge(
    var.common_tags,
    {
      ResourceType = "MetricAlert"
      Purpose      = "CPU utilization monitoring"
    }
  )
}

# Add Memory alert rule
resource "azurerm_monitor_metric_alert" "memory_alert" {
  name                = "alert-${var.project}-${var.environment}-memory-high"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Alert when memory exceeds 85% for 5 minutes"
  severity            = 2
  enabled             = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 1073741824  # 1 GB in bytes
  }

  window_size        = "PT5M"
  frequency          = "PT1M"

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }

  tags = merge(
    var.common_tags,
    {
      ResourceType = "MetricAlert"
      Purpose      = "Memory utilization monitoring"
    }
  )
}
```

---

### Step 4: Add Required Variables

**Edit `modules/monitoring/variables.tf`:**

```hcl
variable "vmss_id" {
  description = "Resource ID of the VM Scale Set to monitor"
  type        = string

  validation {
    condition     = can(regex("^/subscriptions/.*/virtualMachineScaleSets/.*$", var.vmss_id))
    error_message = "VMSS ID must be a valid Azure resource ID."
  }
}

variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must be a valid email address."
  }
}

variable "cpu_threshold" {
  description = "CPU percentage threshold for alerts"
  type        = number
  default     = 80

  validation {
    condition     = var.cpu_threshold > 0 && var.cpu_threshold <= 100
    error_message = "CPU threshold must be between 1 and 100."
  }
}
```

---

### Step 5: Add Outputs

**Edit `modules/monitoring/outputs.tf`:**

```hcl
output "cpu_alert_id" {
  description = "Resource ID of CPU alert rule"
  value       = azurerm_monitor_metric_alert.cpu_alert.id
}

output "memory_alert_id" {
  description = "Resource ID of memory alert rule"
  value       = azurerm_monitor_metric_alert.memory_alert.id
}

output "action_group_id" {
  description = "Resource ID of action group for notifications"
  value       = azurerm_monitor_action_group.main.id
}
```

---

### Step 6: Update Root Module

**Edit `main.tf` in repository root:**

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = var.environment
  project             = var.project_name

  # Pass VMSS ID from compute module
  vmss_id = module.compute.vmss_id

  # Alert configuration
  alert_email   = var.alert_email
  cpu_threshold = var.cpu_threshold

  # Tags
  common_tags = var.common_tags
}
```

---

### Step 7: Validate Terraform Syntax

```bash
# Navigate to repository root
cd ~/engineer-workspace/azure-infrastructure

# Format code (auto-fix formatting)
terraform fmt -recursive

# Expected: Lists files that were reformatted
# modules/monitoring/main.tf
# modules/monitoring/variables.tf
# modules/monitoring/outputs.tf

# Initialize Terraform (download providers if needed)
terraform init

# Validate syntax
terraform validate

# Expected output:
# Success! The configuration is valid.
```

**Common Validation Errors:**

| Error                       | Cause                       | Fix                              |
| --------------------------- | --------------------------- | -------------------------------- |
| `Invalid reference`         | Variable doesn't exist      | Add variable definition          |
| `Missing required argument` | Required field not provided | Add missing field                |
| `Duplicate resource`        | Resource defined twice      | Remove duplicate                 |
| `Invalid value`             | Value fails validation      | Correct value to meet constraint |

---

### Step 8: Commit Changes

```bash
# Check what files changed
git status

# Expected output:
# modified:   main.tf
# modified:   modules/monitoring/main.tf
# modified:   modules/monitoring/variables.tf
# modified:   modules/monitoring/outputs.tf

# Stage changes
git add .

# Verify identity before committing!
git config user.name
git config user.email

# Commit with descriptive message (Conventional Commits format)
git commit -m "feat(monitoring): Add CPU and memory metric alerts

Implementation details:
- Added CPU alert: triggers at 80% utilization for 5 minutes
- Added memory alert: triggers at 85% utilization for 5 minutes
- Configured email notifications via action group
- Alert thresholds configurable via variables

Resources created:
- azurerm_monitor_metric_alert (CPU)
- azurerm_monitor_metric_alert (Memory)
- azurerm_monitor_action_group (Notifications)

Testing plan:
- Validate in dev environment
- Trigger test alert by scaling VMSS
- Verify email notifications received

Related to Phase 1 observability requirements."

# Verify commit created
git log --oneline -1
```

---

### Step 9: Push to GitHub

```bash
# Push feature branch to GitHub organization repository
git push origin feature/add-cpu-memory-alerts

# First time pushing this branch, may see:
# fatal: The current branch feature/add-cpu-memory-alerts has no upstream branch.
# To push the current branch and set the remote as upstream, use:
#     git push --set-upstream origin feature/add-cpu-memory-alerts

# If you see this, run:
git push -u origin feature/add-cpu-memory-alerts

# Expected output shows:
# remote: Create a pull request for 'feature/add-cpu-memory-alerts' on GitHub
# remote:   https://github.com/altrivo-platform/azure-infrastructure/pull/new/feature/add-cpu-memory-alerts
```

---

### Step 10: Create Pull Request

**In GitHub Web Interface:**

1. Navigate to `https://github.com/altrivo-platform/azure-infrastructure`
2. You should see yellow banner: "Compare & pull request"
3. Click **"Compare & pull request"** button

**Fill in PR details:**

**Title:**

```
feat(monitoring): Add CPU and memory metric alerts
```

**Description:**

```markdown
## Change Summary

Implements Azure Monitor metric alerts for VM Scale Set monitoring

## Changes Made

- Added CPU utilization alert (threshold: 80%, window: 5 minutes)
- Added memory utilization alert (threshold: 85%, window: 5 minutes)
- Created action group for email notifications
- Configured alert severity and frequency

## Type of Change

- [x] New feature (monitoring)
- [ ] Bug fix
- [ ] Configuration change
- [ ] Documentation update

## Testing Checklist

- [x] terraform validate (passed)
- [x] terraform fmt (applied)
- [x] Variable validation added
- [x] Resources properly tagged
- [ ] Tested in dev environment (pending deployment)

## Deployment Plan

1. Deploy to dev environment (automatic after merge)
2. Validate alerts appear in Azure Monitor
3. Trigger test alert (scale VMSS to high CPU)
4. Verify email notification received
5. Request production deployment approval

## Rollback Plan

If issues occur:

- Delete alert rules: `terraform destroy -target=module.monitoring`
- Revert PR merge commit
- Re-deploy previous state

## Impact Assessment

- **Risk:** Low (monitoring only, no workload impact)
- **User Impact:** None
- **Cost Impact:** ~$2/month for alerts
- **Dependencies:** Requires VMSS deployed

## Reviewer Checklist

- [ ] Code follows Terraform style guide
- [ ] All variables documented with descriptions
- [ ] Resources use proper naming conventions
- [ ] Tags applied correctly
- [ ] No hardcoded values
- [ ] Validation rules appropriate
- [ ] Outputs documented

## Related Issues

Closes #42
```

4. Click **"Create pull request"**

---

### Step 11: Code Review (Platform Lead)

**Platform Lead Actions:**

1. Receive PR notification via email
2. Navigate to Pull Request
3. Click **"Files changed"** tab
4. Review each file:

   - Check Terraform syntax
   - Verify naming conventions
   - Confirm proper tagging
   - Validate security practices
   - Check for hardcoded values

5. Add inline comments if issues found:

   - Click line number
   - Add comment
   - Click "Start a review"

6. Complete review:
   - Click "Review changes" button
   - Select "Approve" OR "Request changes"
   - Add summary comment
   - Click "Submit review"

**Example Approval Comment:**

```
✅ Code Review Complete

**Validated:**
- Terraform syntax correct
- Naming conventions followed
- Proper resource tagging
- No hardcoded values
- Variable validation appropriate
- Alert thresholds reasonable

**Approved for deployment to dev**
```

---

### Step 12: Merge to Main

**Platform Lead Actions:**

1. After approving, scroll to bottom of PR
2. Click **"Merge pull request"**
3. Confirm merge
4. Optionally: Delete feature branch

**Automatic Actions:**

- Azure DevOps pipeline triggered
- Terraform plan executes for dev
- Terraform apply runs automatically (dev)
- Resources deployed to dev environment

---

### Step 13: Dev Environment Validation

**Platform Engineer Actions:**

```bash
# Wait for dev deployment to complete (check Azure DevOps pipeline)

# Verify alerts created in Azure
az monitor metrics alert list \
  --resource-group rg-azureplatform-dev \
  --output table

# Expected output shows:
# Name                                    Enabled    Severity
# alert-azureplatform-dev-cpu-high        True       2
# alert-azureplatform-dev-memory-high     True       2

# Check alert details
az monitor metrics alert show \
  --name alert-azureplatform-dev-cpu-high \
  --resource-group rg-azureplatform-dev

# Test alert (optional - generate high CPU load)
# SSH to VMSS instance via Bastion
# Run: stress --cpu 8 --timeout 600

# Wait for alert to trigger (5-10 minutes)
# Check email for notification

# Document validation results
echo "✅ CPU alert created successfully" >> validation.log
echo "✅ Memory alert created successfully" >> validation.log
echo "✅ Email notification received" >> validation.log
```

---

### Step 14: Request Production Deployment

**Platform Engineer Actions:**

Create production deployment request:

```markdown
## Production Deployment Request

**Change:** CPU and Memory Monitoring Alerts
**Dev Validation:** Completed successfully on 2026-01-10
**Validation Evidence:**

- Alert rules visible in Azure Monitor (dev)
- Test alert triggered and received email notification
- All resources tagged correctly
- No errors in deployment logs

**Production Readiness:**

- [x] Dev deployment successful
- [x] Functional testing passed
- [x] No unexpected behavior observed
- [x] Cost impact reviewed (<$5/month)
- [x] Rollback plan documented

**Requesting approval from Platform Lead for production deployment**
```

---

### Step 15: Production Approval & Deployment

**Platform Lead Actions:**

1. Review dev validation results
2. In Azure DevOps, navigate to pipeline
3. Check Terraform plan output for production
4. Verify:

   - No unexpected resource changes
   - Alert configurations appropriate
   - Cost impact acceptable
   - Tags applied correctly

5. Manually approve in Azure DevOps:

   - Click "Review" on pending approval
   - Add comment: "Reviewed plan, approved for production"
   - Click "Approve"

6. Monitor deployment execution
7. Verify production deployment successful

---

### Step 16: Production Validation

**Platform Engineer Actions:**

```bash
# Verify production alerts
az monitor metrics alert list \
  --resource-group rg-azureplatform-prod \
  --output table

# Check alert configuration matches dev
az monitor metrics alert show \
  --name alert-azureplatform-prod-cpu-high \
  --resource-group rg-azureplatform-prod \
  --query '{Name:name, Enabled:enabled, Threshold:criteria[0].threshold, Window:windowSize}' \
  --output table

# Monitor for 30-60 minutes for unexpected alerts
# Document successful deployment

# Update change log
```

---

## 🔧 Modifying Existing Resources

### Scenario: Update NSG Rule

**Performed By:** Platform Engineer  
**Time Required:** 1-2 hours  
**Risk Level:** Medium

---

### Step 1: Create Feature Branch

```bash
git checkout main
git pull origin main
git checkout -b bugfix/fix-nsg-rule-priority
```

---

### Step 2: Locate Resource

```bash
# Find NSG definition
grep -r "azurerm_network_security_rule" modules/

# Expected output shows file location:
# modules/networking/main.tf:resource "azurerm_network_security_rule" "allow_https" {
```

---

### Step 3: Modify Resource

**Edit `modules/networking/main.tf`:**

```hcl
resource "azurerm_network_security_rule" "allow_https" {
  name                        = "AllowHTTPS"
  priority                    = 100  # Changed from 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.app.name
}
```

---

### Step 4: Preview Changes

```bash
# Format and validate
terraform fmt -recursive
terraform validate

# Plan changes (shows what will change)
terraform plan -out=tfplan

# Review output carefully:
# ~ azurerm_network_security_rule.allow_https
#   ~ priority: 110 -> 100
#
# Expected: Only priority changes, no recreate
```

---

### Step 5: Commit and Push

```bash
git add modules/networking/main.tf
git commit -m "fix(networking): Correct NSG rule priority conflict

Changed HTTPS rule priority from 110 to 100 to avoid
conflict with newly added rule at priority 105.

No functional impact - priority order maintained correctly."

git push origin bugfix/fix-nsg-rule-priority
```

---

### Step 6: Follow PR Process

Same as Steps 10-16 in Creating New Resources section.

---

## 🏗️ Creating New Modules

### Scenario: Create Monitoring Module

**Performed By:** Platform Engineer  
**Time Required:** 4-6 hours  
**Risk Level:** Low

---

### Step 1: Create Module Directory

```bash
# Navigate to modules directory
cd modules/

# Create new module directory
mkdir monitoring
cd monitoring

# Create standard files
touch main.tf variables.tf outputs.tf README.md
```

---

### Step 2: Create Module README

**Edit `modules/monitoring/README.md`:**

````markdown
# Monitoring Module

## Purpose

Creates Azure Monitor and Log Analytics resources for platform observability.

## Resources Created

- Azure Monitor Action Group
- Log Analytics Workspace
- Metric Alert Rules
- Activity Log Alerts

## Usage

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = "rg-azureplatform-dev"
  location            = "East US"
  environment         = "dev"
  project             = "azure-platform"

  alert_email = "team@company.com"
  vmss_id     = module.compute.vmss_id

  common_tags = var.common_tags
}
```

## Input Variables

| Name                | Type   | Description             | Default | Required |
| ------------------- | ------ | ----------------------- | ------- | -------- |
| resource_group_name | string | Resource group name     | -       | yes      |
| location            | string | Azure region            | -       | yes      |
| environment         | string | Environment (dev/prod)  | -       | yes      |
| alert_email         | string | Email for notifications | -       | yes      |
| vmss_id             | string | VMSS resource ID        | -       | yes      |

## Outputs

| Name                       | Description              |
| -------------------------- | ------------------------ |
| log_analytics_workspace_id | LA Workspace resource ID |
| action_group_id            | Action group resource ID |

## Dependencies

- Requires compute module (VMSS) deployed first
````

---

### Step 3: Define Resources

**Edit `modules/monitoring/main.tf`:**

```hcl
# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "la-${var.project}-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.environment == "prod" ? 90 : 30

  tags = merge(
    var.common_tags,
    {
      ResourceType = "LogAnalytics"
      Purpose      = "Centralized logging and monitoring"
    }
  )
}

# Action Group for Alerts
resource "azurerm_monitor_action_group" "main" {
  name                = "ag-${var.project}-${var.environment}"
  resource_group_name = var.resource_group_name
  short_name          = var.environment == "prod" ? "ProdAlert" : "DevAlert"

  email_receiver {
    name                    = "Platform Team"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  tags = merge(
    var.common_tags,
    {
      ResourceType = "ActionGroup"
      Purpose      = "Alert notification routing"
    }
  )
}
```

---

### Step 4: Define Variables

**Edit `modules/monitoring/variables.tf`:**

```hcl
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region for resources"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, prod)"
  type        = string

  validation {
    condition     = contains(["dev", "prod"], var.environment)
    error_message = "Environment must be dev or prod."
  }
}

variable "project" {
  description = "Project name for resource naming"
  type        = string
}

variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.alert_email))
    error_message = "Must be a valid email address."
  }
}

variable "vmss_id" {
  description = "Resource ID of VM Scale Set to monitor"
  type        = string
}

variable "common_tags" {
  description = "Common tags to apply to all resources"
  type        = map(string)
}
```

---

### Step 5: Define Outputs

**Edit `modules/monitoring/outputs.tf`:**

```hcl
output "log_analytics_workspace_id" {
  description = "Resource ID of Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of Log Analytics Workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "action_group_id" {
  description = "Resource ID of action group"
  value       = azurerm_monitor_action_group.main.id
}

output "workspace_id" {
  description = "Workspace ID for Log Analytics (for agent configuration)"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}
```

---

### Step 6: Validate Module

```bash
# Navigate to module directory
cd ~/engineer-workspace/azure-infrastructure/modules/monitoring

# Initialize Terraform in module directory
terraform init

# Validate module syntax
terraform validate

# Expected: Success! The configuration is valid.

# Navigate back to root
cd ~/engineer-workspace/azure-infrastructure

# Format all files
terraform fmt -recursive
```

---

### Step 7: Use Module in Root

**Edit root `main.tf`:**

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  environment         = var.environment
  project             = var.project_name

  alert_email = var.alert_email
  vmss_id     = module.compute.vmss_id

  common_tags = var.common_tags
}
```

---

### Step 8: Test Module

```bash
# Initialize with new module
terraform init

# Plan changes
terraform plan

# Review output to verify module resources will be created
# Expected: Several resources from monitoring module shown
```

---

### Step 9: Follow Standard Commit Process

Same as Steps 8-16 in Creating New Resources section.

---

## 🔍 Troubleshooting

### Common Issues & Solutions

#### Issue: State Lock Error

**Symptom:**

```
Error: Error acquiring the state lock

Lock Info:
  ID:        abc-123-xyz
  Path:      terraform.tfstate
  Operation: OperationTypeApply
  Who:       user@hostname
  Version:   1.3.0
  Created:   2026-01-10 10:30:00 UTC
```

**Cause:** Another Terraform operation in progress or previous operation crashed

**Solution:**

```bash
# Option 1: Wait for other operation to complete

# Option 2: Force unlock (ONLY if sure no other operation running)
terraform force-unlock abc-123-xyz

# Option 3: Check Azure DevOps pipelines for running jobs
# Cancel stuck pipeline if necessary
```

---

#### Issue: Provider Version Conflict

**Symptom:**

```
Error: Failed to query available provider packages

Could not retrieve the list of available versions for provider
hashicorp/azurerm: no available releases match the given constraints
```

**Cause:** Version constraint incompatible with Terraform version

**Solution:**

```bash
# Check Terraform version
terraform version

# Update provider constraints in providers.tf
# Change:
#   version = "~> 4.0"
# To:
#   version = "~> 3.80"

# Re-initialize
terraform init -upgrade
```

---

#### Issue: Resource Already Exists

**Symptom:**

```
Error: A resource with the ID "/subscriptions/.../resourceGroups/..."
already exists - to be managed via Terraform this resource needs to be
imported into the State
```

**Cause:** Resource exists in Azure but not in Terraform state

**Solution:**

```bash
# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/{sub-id}/resourceGroups/{rg-name}

# Or delete resource manually if it's a test resource
az group delete --name {rg-name}
```

---

#### Issue: Variable Validation Failed

**Symptom:**

```
Error: Invalid value for variable

The given value does not match the variable's validation rules.
```

**Cause:** Variable value doesn't meet validation constraint

**Solution:**

```bash
# Check variable definition in variables.tf
# Example: environment must be "dev" or "prod", but you passed "development"

# Fix in terraform.tfvars or command line:
# Wrong:
environment = "development"

# Correct:
environment = "dev"
```

---

## 🚨 Emergency Procedures

### Emergency Rollback

**When to Use:**

- Production outage caused by deployment
- Critical security issue introduced
- Data loss risk identified

**Steps:**

```bash
# 1. Immediately notify Platform Lead

# 2. Identify last known good state
git log --oneline main

# 3. Revert to previous commit
git revert HEAD
git push origin main

# 4. Trigger emergency deployment
# In Azure DevOps, queue new pipeline run

# 5. Monitor rollback completion

# 6. Verify services restored

# 7. Document incident
# Create post-incident review document
```

---

### State Recovery

**When to Use:**

- Terraform state corrupted
- State accidentally deleted
- State lock permanently stuck

**Steps:**

```bash
# 1. Backup current state (if accessible)
terraform state pull > state-backup-$(date +%Y%m%d-%H%M%S).json

# 2. Check Azure Storage for state backups
az storage blob list \
  --account-name {storage-account} \
  --container-name tfstate \
  --output table

# 3. Download backup state
az storage blob download \
  --account-name {storage-account} \
  --container-name tfstate \
  --name terraform.tfstate.backup \
  --file restored-state.json

# 4. Restore state
terraform state push restored-state.json

# 5. Verify state integrity
terraform plan
# Should show minimal or no changes if state matches reality
```

---

## 📚 Related Documentation

- [Change Management Policy](../policies/change-management-policy.md)
- [Deployment Procedures](deployment-procedures.md)
- [Terraform Style Guide](../standards/terraform-style-guide.md)
- [Git Workflow Guide](../standards/git-workflow-guide.md)

---

## 📅 Version History

| Version | Date       | Changes                  | Author        |
| ------- | ---------- | ------------------------ | ------------- |
| 1.0     | 2026-01-10 | Initial runbook creation | Platform Team |

---

**Document Type:** Living Runbook  
**Review Cadence:** Monthly or after major incidents  
**Next Review:** February 10, 2026  
**Runbook Owner:** Platform Team
