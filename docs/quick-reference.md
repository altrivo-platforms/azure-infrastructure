# Quick Reference Guide

**Version:** 1.0  
**Last Updated:** January 10, 2026  
**Purpose:** Fast lookup for common commands and workflows

---

## 📋 Daily Commands

### Morning Sync

```bash
cd ~/your-workspace/azure-infrastructure
git checkout main
git pull origin main
git status
```

### Create Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### Commit and Push

```bash
git add .
git commit -m "feat(scope): description"
git push origin feature/your-feature-name
```

---

## 🔧 Terraform Commands

### Essential Commands

```bash
# Format code
terraform fmt -recursive

# Validate syntax
terraform validate

# Initialize (download providers)
terraform init

# Plan changes (preview)
terraform plan

# Apply changes
terraform apply

# Destroy resources
terraform destroy

# Show current state
terraform show

# List resources in state
terraform state list
```

### Advanced Commands

```bash
# Plan with specific var file
terraform plan -var-file=environments/dev/terraform.tfvars

# Plan and save to file
terraform plan -out=tfplan

# Apply from saved plan
terraform apply tfplan

# Target specific resource
terraform apply -target=module.networking

# Refresh state
terraform refresh

# Import existing resource
terraform import azurerm_resource_group.main /subscriptions/{id}/resourceGroups/{name}

# Unlock state (if stuck)
terraform force-unlock {lock-id}
```

---

## 🌐 Git Workflows

### Feature Branch Workflow

```bash
# 1. Create branch
git checkout -b feature/add-monitoring

# 2. Make changes
# (edit files)

# 3. Stage changes
git add .

# 4. Commit
git commit -m "feat(monitoring): add alerts"

# 5. Push
git push origin feature/add-monitoring

# 6. Create PR on GitHub

# 7. After merge, sync
git checkout main
git pull origin main
git branch -d feature/add-monitoring
```

### Hotfix Workflow

```bash
# 1. Create hotfix branch
git checkout -b hotfix/critical-fix

# 2. Make minimal fix
# (edit files)

# 3. Commit
git commit -m "fix: critical security patch"

# 4. Push
git push origin hotfix/critical-fix

# 5. Create PR with "URGENT" label

# 6. After merge, sync
git checkout main
git pull origin main
```

---

## 🔍 Azure CLI Commands

### Resource Groups

```bash
# List resource groups
az group list --output table

# Create resource group
az group create --name rg-name --location eastus

# Delete resource group
az group delete --name rg-name --yes --no-wait

# Show resource group
az group show --name rg-name
```

### Virtual Machines

```bash
# List VMs
az vm list --output table

# Start VM
az vm start --name vm-name --resource-group rg-name

# Stop VM
az vm stop --name vm-name --resource-group rg-name

# Get VM status
az vm get-instance-view --name vm-name --resource-group rg-name
```

### VM Scale Sets

```bash
# List VMSS
az vmss list --output table

# Scale VMSS
az vmss scale --name vmss-name --resource-group rg-name --new-capacity 3

# Update VMSS instances
az vmss update-instances --instance-ids '*' --name vmss-name --resource-group rg-name

# Get VMSS instances
az vmss list-instances --name vmss-name --resource-group rg-name --output table
```

### Networking

```bash
# List VNets
az network vnet list --output table

# List NSGs
az network nsg list --output table

# Show NSG rules
az network nsg rule list --nsg-name nsg-name --resource-group rg-name --output table

# List public IPs
az network public-ip list --output table
```

### Monitoring

```bash
# List alerts
az monitor metrics alert list --resource-group rg-name --output table

# Show alert
az monitor metrics alert show --name alert-name --resource-group rg-name

# List activity log
az monitor activity-log list --resource-group rg-name --output table
```

### Cost Management

```bash
# Show cost for current month
az consumption usage list --start-date 2026-01-01 --end-date 2026-01-31 --output table

# Show cost by resource group
az consumption usage list --query "[?resourceGroup=='rg-azureplatform-dev']" --output table
```

---

## 🔐 SSH & Authentication

### SSH Key Management

```bash
# Generate new SSH key
ssh-keygen -t ed25519 -f ~/.ssh/key-name -C "email@domain.com"

# Add key to SSH agent
ssh-add ~/.ssh/key-name

# List loaded keys
ssh-add -l

# Test GitHub connection (Lead)
ssh -T git@github.com-lead

# Test GitHub connection (Engineer)
ssh -T git@github.com-engineer
```

### Git Identity

```bash
# Check current identity
git config user.name
git config user.email

# Set identity (repository-specific)
git config user.name "Your Name"
git config user.email "your@email.com"

# Set identity (global)
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

---

## 📊 Useful Queries

### Find Resources by Tag

```bash
# Find all dev resources
az resource list --tag Environment=dev --output table

# Find all terraform-managed resources
az resource list --tag ManagedBy=terraform --output table

# Find resources by project
az resource list --tag Project=azure-platform --output table
```

### Check Resource Compliance

```bash
# Find resources missing Environment tag
az resource list --query "[?tags.Environment==null].{Name:name, Type:type}" --output table

# Find resources missing Owner tag
az resource list --query "[?tags.Owner==null].{Name:name, Type:type}" --output table
```

---

## 🚨 Emergency Commands

### Quick Rollback

```bash
# Revert last commit
git revert HEAD
git push origin main

# Revert specific commit
git revert <commit-hash>
git push origin main

# Force rollback (DANGEROUS)
git reset --hard HEAD~1
git push --force origin main  # Only if absolutely necessary
```

### State Recovery

```bash
# Backup current state
terraform state pull > state-backup-$(date +%Y%m%d-%H%M%S).json

# Restore state
terraform state push backup-file.json

# Remove resource from state
terraform state rm azurerm_resource_group.main

# Move resource in state
terraform state mv azurerm_resource_group.old azurerm_resource_group.new
```

---

## 📍 Important URLs

### Azure Resources

```
Azure Portal:
https://portal.azure.com

Azure DevOps:
https://dev.azure.com/altrivo-azure-platform/azure-infrastructure

GitHub Organization:
https://github.com/altrivo-platform

Repository:
https://github.com/altrivo-platform/azure-infrastructure
```

### Subscription Details

```
Subscription Name: Pay-As-You-Go
Subscription ID: [Your Subscription ID]

Resource Groups:
- Dev: rg-azureplatform-dev
- Prod: rg-azureplatform-prod
```

---

## 📱 Contact Information

### Team Contacts

```
Platform Lead:
Name: [Platform Lead Name]
Email: yourname+lead@domain.com
Phone: [Phone Number]

Platform Engineer:
Name: [Platform Engineer Name]
Email: yourname+dev@domain.com
Phone: [Phone Number]

Team Email:
platform-team@company.com
```

### Escalation Path

```
Level 1: Platform Engineer
  ↓ (if cannot resolve in 30 min)
Level 2: Platform Lead
  ↓ (if critical)
Level 3: Management
```

---

## 🔑 Common Variables

### Environment Variables

```hcl
environment = "dev"     # or "prod"
location    = "East US"
project     = "azure-platform"
```

### Resource Naming Pattern

```
{resource-type}-{project}-{environment}-{instance}

Examples:
rg-azureplatform-dev
vnet-azureplatform-prod-001
vmss-azureplatform-dev-app-001
```

### Tag Structure

```hcl
tags = {
  Environment   = "dev"
  Project       = "azure-platform"
  Owner         = "platform-team"
  CostCenter    = "engineering"
  ManagedBy     = "terraform"
  CreatedBy     = "user@domain.com"
  CreatedDate   = "2026-01-10T10:00:00Z"
}
```

---

## 🎯 Troubleshooting Quick Fixes

### Git Issues

```bash
# Conflict during pull
git stash
git pull origin main
git stash pop

# Wrong branch
git checkout main

# Discard local changes
git checkout -- filename
# OR discard all changes
git reset --hard HEAD

# Delete local branch
git branch -d branch-name

# Delete remote branch
git push origin --delete branch-name
```

### Terraform Issues

```bash
# State lock error
terraform force-unlock <lock-id>

# Provider cache issues
rm -rf .terraform
terraform init

# Module errors
terraform get -update

# Formatting issues
terraform fmt -recursive

# Validate all files
find . -name "*.tf" -exec terraform validate {} \;
```

### Azure CLI Issues

```bash
# Login issues
az login
az account set --subscription <subscription-id>

# Clear cache
az cache purge
az cache delete

# Update CLI
az upgrade
```

---

## 📊 Cost Monitoring Quick Check

```bash
# Current month costs
az consumption usage list \
  --start-date $(date +%Y-%m-01) \
  --end-date $(date +%Y-%m-%d) \
  --output table

# Costs by resource group
az consumption usage list \
  --query "[?resourceGroup=='rg-azureplatform-dev'].{Resource:name, Cost:pretaxCost}" \
  --output table

# Largest costs
az consumption usage list \
  --query "sort_by([?pretaxCost!=null], &pretaxCost)[*].{Resource:name, Cost:pretaxCost}" \
  --output table | tail -10
```

---

## 🔄 Common Workflows Cheat Sheet

### New Resource

```
1. git checkout -b feature/add-resource
2. Edit Terraform files
3. terraform fmt -recursive
4. terraform validate
5. git commit -m "feat: add resource"
6. git push origin feature/add-resource
7. Create PR
8. Wait for approval
9. Merge PR
10. Verify in dev
11. Request prod deployment
```

### Bug Fix

```
1. git checkout -b bugfix/fix-issue
2. Make minimal fix
3. terraform validate
4. git commit -m "fix: description"
5. git push origin bugfix/fix-issue
6. Create PR with "bug" label
7. Fast-track review
8. Merge and deploy
```

### Emergency Fix

```
1. Notify Platform Lead
2. git checkout -b hotfix/critical
3. Make MINIMAL change
4. Deploy immediately
5. Document afterward
6. Post-incident review
```

---

## 📚 Documentation Links

```
Architecture:
docs/architecture/architecture-overview.md

Policies:
docs/policies/change-management-policy.md
docs/policies/security-baseline-policy.md
docs/policies/naming-conventions.md

Runbooks:
docs/runbooks/terraform-workflow.md
docs/runbooks/deployment-procedures.md
docs/runbooks/vm-failure-response.md

Standards:
docs/standards/terraform-style-guide.md
docs/standards/git-workflow-guide.md
```

---

## 🎓 Learning Resources

### Azure Documentation

```
AZ-104 Study Guide:
https://learn.microsoft.com/en-us/certifications/exams/az-104

Terraform Azure Provider:
https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs

Azure Architecture Center:
https://learn.microsoft.com/en-us/azure/architecture/
```

### Terraform Resources

```
Terraform Documentation:
https://developer.hashicorp.com/terraform/docs

Terraform Best Practices:
https://www.terraform-best-practices.com/

Terraform Module Registry:
https://registry.terraform.io/
```

---

## ⚡ Performance Tips

### Speed Up Terraform

```bash
# Parallel resource creation (careful!)
terraform apply -parallelism=10

# Target specific module
terraform apply -target=module.networking

# Skip provider updates
terraform init -upgrade=false

# Use local state for testing
# (But NEVER for shared environments!)
```

### Speed Up Git

```bash
# Shallow clone (faster)
git clone --depth 1 <repo-url>

# Fetch only main branch
git fetch origin main

# Prune deleted branches
git remote prune origin
```

---

## 🎯 Pre-Deployment Checklist

```
Technical:
□ terraform fmt executed
□ terraform validate passed
□ No hardcoded values
□ All resources tagged
□ Variables documented
□ Outputs defined

Process:
□ Feature branch created
□ Pull request opened
□ Code review completed
□ Dev testing successful
□ Prod approval obtained

Documentation:
□ README updated
□ Runbook updated (if needed)
□ Change log updated
□ Comments added to complex logic

Security:
□ No credentials in code
□ RBAC appropriate
□ Network rules validated
□ Secrets in Key Vault
```

---

## 📅 Version History

| Version | Date       | Changes                 | Author        |
| ------- | ---------- | ----------------------- | ------------- |
| 1.0     | 2026-01-10 | Initial quick reference | Platform Team |

---

**Document Type:** Quick Reference  
**Update Frequency:** As needed  
**Last Review:** January 10, 2026  
**Owner:** Platform Team
