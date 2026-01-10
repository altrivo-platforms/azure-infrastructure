# Change Management Policy

**Document Version:** 1.0  
**Last Updated:** January 10, 2026  
**Status:** Active Policy  
**Owner:** Platform Lead  
**Approved By:** Platform Team

---

## 📋 Purpose

This policy defines the processes and requirements for making changes to Azure infrastructure. It ensures all modifications are reviewed, tested, approved, and documented before deployment, minimizing risk and maintaining system stability.

---

## 🎯 Objectives

- **Prevent Unauthorized Changes:** Ensure all changes go through proper approval
- **Reduce Incidents:** Catch errors before they reach production
- **Maintain Audit Trail:** Document all infrastructure modifications
- **Enable Rollback:** Provide clear procedures for reversing changes
- **Support Compliance:** Meet regulatory and organizational requirements

---

## 🔍 Scope

### In Scope

This policy applies to ALL changes to:

- ✅ Azure infrastructure resources (VMs, networks, databases, storage)
- ✅ Terraform code and modules
- ✅ Azure DevOps pipelines (CI/CD definitions)
- ✅ Network security rules and policies
- ✅ Access control and RBAC assignments
- ✅ Configuration management
- ✅ Monitoring and alerting rules

### Out of Scope

This policy does NOT apply to:

- ❌ Application code deployments (separate process)
- ❌ Documentation-only changes (docs/ directory)
- ❌ Read-only operations (queries, reports)
- ❌ Emergency hotfixes (see Emergency Change Process)

---

## 👥 Roles & Responsibilities

### Platform Engineer

**Responsibilities:**

- Create infrastructure changes in Terraform
- Write clear, descriptive commit messages
- Create pull requests with detailed descriptions
- Test changes in dev environment
- Respond to code review feedback
- Fix issues identified during review

**Authorities:**

- Deploy changes to dev environment (automatic after merge)
- Create and modify Terraform code
- Run terraform plan and validate
- Request production deployments

**Restrictions:**

- ❌ Cannot deploy directly to production
- ❌ Cannot approve own pull requests
- ❌ Cannot bypass branch protection rules
- ❌ Cannot modify RBAC or security policies

---

### Platform Lead

**Responsibilities:**

- Review all infrastructure changes
- Approve or reject pull requests
- Manually approve production deployments
- Monitor change success/failure
- Conduct post-implementation reviews
- Maintain change calendar

**Authorities:**

- Approve production deployments
- Merge pull requests to main branch
- Modify RBAC and security policies
- Emergency change authorization
- Override standard process (with documentation)

**Restrictions:**

- ❌ Cannot bypass branch protection (same as engineers)
- ❌ Must document reason for emergency changes

---

## 🔄 Change Categories

### Standard Change (Most Common)

**Definition:** Pre-approved, low-risk, repeatable changes following established procedures.

**Examples:**

- Adding new VM instances to existing scale set
- Updating VM sizes within approved SKUs
- Modifying auto-scaling thresholds
- Adding new alert rules
- Updating tags

**Process:**

- Feature branch → PR → Code review → Auto-deploy to dev → Manual approval for prod
- **Approval Required:** Yes (Platform Lead)
- **Testing Required:** Yes (dev environment validation)
- **Timeline:** 1-3 days

---

### Normal Change

**Definition:** Changes that require planning, testing, and approval but follow standard process.

**Examples:**

- Deploying new Terraform modules
- Modifying network architecture
- Changing NSG rules
- Updating PostgreSQL configuration
- Migrating resources between subnets

**Process:**

- Feature branch → PR with detailed plan → Code review → Dev testing → Prod approval → Deployment
- **Approval Required:** Yes (Platform Lead + optional stakeholder review)
- **Testing Required:** Yes (comprehensive dev testing)
- **Documentation Required:** Yes (runbook updates)
- **Timeline:** 3-7 days

---

### Major Change

**Definition:** High-impact changes with significant risk or complexity.

**Examples:**

- Migrating to new Azure region
- Upgrading PostgreSQL major version
- Restructuring network topology
- Implementing new security model
- Disaster recovery failover

**Process:**

- Design document → Architecture review → Detailed plan → Dev testing → Staging validation → Prod approval → Deployment → Post-implementation review
- **Approval Required:** Yes (Platform Lead + Architecture Review)
- **Testing Required:** Yes (dev + staging validation)
- **Documentation Required:** Yes (detailed runbooks + rollback plan)
- **Communication Required:** Yes (stakeholder notification)
- **Timeline:** 2-4 weeks

---

### Emergency Change (Hotfix)

**Definition:** Urgent changes required to restore service or address critical security issues.

**Examples:**

- Security vulnerability patching
- Service outage remediation
- Critical bug fixes affecting production
- Emergency scaling to prevent outage

**Process:**

- Verbal approval → Immediate deployment → Retrospective documentation
- **Approval Required:** Verbal from Platform Lead (document afterward)
- **Testing Required:** Minimal (restore service first)
- **Post-Change Review Required:** Yes (within 24 hours)
- **Timeline:** Immediate

---

## 📝 Standard Change Process (Detailed)

### Step 1: Planning & Design (Platform Engineer)

**Actions:**

1. Identify need for infrastructure change
2. Document requirements and objectives
3. Review impact on existing resources
4. Plan Terraform code modifications
5. Identify affected modules/resources

**Deliverables:**

- Clear understanding of change scope
- List of modified Terraform files
- Expected resource changes

**Time:** 1-2 hours

---

### Step 2: Development (Platform Engineer)

**Actions:**

1. Ensure local main branch is up to date:

   ```bash
   git checkout main
   git pull origin main
   ```

2. Create feature branch:

   ```bash
   git checkout -b feature/add-monitoring-alerts
   ```

3. Make Terraform code changes
4. Validate syntax:

   ```bash
   terraform fmt -recursive
   terraform validate
   ```

5. Commit with descriptive message:

   ```bash
   git add .
   git commit -m "feat(monitoring): Add CPU and memory alerts

   Implemented Azure Monitor alerts:
   - CPU > 80% for 5 minutes
   - Memory > 85% for 5 minutes
   - Notifications to platform-team@company.com"
   ```

6. Push to GitHub:
   ```bash
   git push origin feature/add-monitoring-alerts
   ```

**Deliverables:**

- Working Terraform code
- Validated and formatted code
- Committed to feature branch

**Time:** 2-4 hours

---

### Step 3: Pull Request Creation (Platform Engineer)

**Actions:**

1. Navigate to GitHub repository
2. Click "Compare & pull request"
3. Fill in PR template:

```markdown
## Change Description

Add Azure Monitor alerts for CPU and memory utilization

## Type of Change

- [x] New feature (monitoring alerts)
- [ ] Bug fix
- [ ] Configuration change
- [ ] Documentation update

## Changes Made

- Created alert rules for VMSS instances
- CPU threshold: 80% for 5 minutes
- Memory threshold: 85% for 5 minutes
- Email notifications configured

## Testing Performed

- [x] terraform validate (passed)
- [x] terraform fmt (applied)
- [x] Alert threshold values reviewed
- [ ] Tested in dev environment (pending deployment)

## Impact Assessment

- **Risk Level:** Low
- **Affected Resources:** VM Scale Set monitoring
- **Rollback Complexity:** Easy (delete alert rules)
- **User Impact:** None (monitoring only)

## Pre-Deployment Checklist

- [x] Code follows Terraform style guide
- [x] All resources properly tagged
- [x] No hardcoded values
- [x] Variable descriptions added
- [x] Outputs documented

## Post-Deployment Validation

1. Verify alerts appear in Azure Monitor
2. Trigger test alert (scale VMSS to high CPU)
3. Confirm email notification received
4. Validate alert auto-resolves when CPU drops

## Related Issues

Closes #42
```

4. Request reviewer (CODEOWNERS auto-assigns Platform Lead)
5. Create pull request

**Deliverables:**

- Detailed pull request
- Clear testing plan
- Documented validation steps

**Time:** 30 minutes

---

### Step 4: Code Review (Platform Lead)

**Actions:**

1. Receive PR notification
2. Review changed files in GitHub
3. Check for:

   - ✅ Correct Terraform syntax
   - ✅ Proper resource naming
   - ✅ Appropriate tags applied
   - ✅ No hardcoded values
   - ✅ Security best practices followed
   - ✅ Cost impact acceptable
   - ✅ Documentation complete

4. Add inline comments for issues
5. Request changes OR approve

**Review Checklist:**

```markdown
- [ ] Code follows naming conventions
- [ ] All resources properly tagged
- [ ] No credentials or secrets in code
- [ ] Variables have descriptions and validation
- [ ] Outputs are documented
- [ ] README updated if needed
- [ ] Change aligns with architecture
- [ ] Rollback plan is clear
- [ ] Testing plan is adequate
```

**Approval Criteria:**

- All checklist items satisfied
- No security concerns
- Acceptable cost impact
- Clear rollback procedure

**Time:** 30-60 minutes

---

### Step 5: Merge to Main (Platform Lead)

**Actions:**

1. After approval, merge PR to main branch
2. Delete feature branch (optional)
3. Monitor automatic dev deployment

**GitHub Actions:**

- PR merged triggers Azure DevOps pipeline
- Terraform plan executes for dev environment
- Terraform apply runs automatically
- Changes deployed to dev

**Time:** 5-10 minutes (automatic)

---

### Step 6: Dev Environment Validation (Platform Engineer)

**Actions:**

1. Wait for dev deployment to complete
2. Verify resources created successfully:

   ```bash
   az monitor metrics alert list \
     --resource-group rg-azureplatform-dev \
     --output table
   ```

3. Test functionality (trigger alert if possible)
4. Document validation results
5. Report success/failure to Platform Lead

**Success Criteria:**

- Resources created without errors
- Configuration matches expected state
- Functional testing passes
- No unexpected side effects

**Time:** 30-60 minutes

---

### Step 7: Production Deployment Request (Platform Engineer)

**Actions:**

1. Create PR or trigger pipeline for production
2. Provide additional context:

   ```markdown
   ## Production Deployment Request

   **Dev Validation:** Completed successfully on 2026-01-10
   **Testing Results:** All tests passed
   **Validation Evidence:**

   - Alert rules visible in Azure Monitor
   - Test alert triggered and resolved successfully
   - Email notifications received

   **Ready for Production:** Yes
   ```

3. Request Platform Lead approval

**Time:** 15 minutes

---

### Step 8: Production Approval (Platform Lead)

**Actions:**

1. Review dev validation results
2. Check terraform plan output for production:

   - Review resource changes
   - Verify no unexpected deletions
   - Confirm cost impact
   - Check security implications

3. Manually approve in Azure DevOps:
   - Navigate to environment approval
   - Review plan output
   - Click "Approve" or "Reject"
   - Add approval comment

**Approval Decision Criteria:**

- ✅ Dev testing successful
- ✅ No unexpected resource changes
- ✅ Cost impact acceptable
- ✅ Security requirements met
- ✅ Rollback plan documented
- ✅ Deployment timing appropriate

**Time:** 15-30 minutes

---

### Step 9: Production Deployment (Automatic)

**Actions:**

- After approval, Azure DevOps pipeline resumes
- Terraform apply executes for production
- Resources created/modified
- Pipeline logs all changes

**Monitoring:**

- Watch pipeline execution
- Monitor Azure Activity Log
- Check for errors/warnings

**Time:** 10-20 minutes

---

### Step 10: Post-Deployment Validation (Platform Engineer)

**Actions:**

1. Verify resources in production:

   ```bash
   az monitor metrics alert list \
     --resource-group rg-azureplatform-prod \
     --output table
   ```

2. Execute validation tests
3. Monitor for unexpected behavior (15-30 minutes)
4. Document results:

   ```markdown
   ## Post-Deployment Validation Results

   **Deployment Time:** 2026-01-10 14:30:00 UTC
   **Validation Time:** 2026-01-10 14:45:00 UTC
   **Status:** SUCCESS

   **Validation Steps:**

   1. ✅ Alert rules visible in Azure Monitor
   2. ✅ Thresholds configured correctly
   3. ✅ Notifications working
   4. ✅ No errors in logs

   **Issues Found:** None
   ```

5. Notify Platform Lead of successful deployment

**Time:** 30-60 minutes

---

### Step 11: Change Documentation (Both Roles)

**Actions:**

1. Update change log:

   ```markdown
   ## 2026-01-10 - Monitoring Alerts Deployment

   **Change ID:** CHG-2026-001
   **Type:** Standard Change
   **Deployed By:** Platform Engineer
   **Approved By:** Platform Lead
   **Affected Environments:** dev, prod

   **Summary:** Added CPU and memory monitoring alerts
   **Impact:** Improved observability, no user impact
   **Rollback:** Delete alert rules if needed
   ```

2. Update runbooks (if applicable)
3. Close related issues in GitHub
4. Archive pull request

**Time:** 15-30 minutes

---

## 🚨 Emergency Change Process

### When to Use Emergency Process

Use ONLY for:

- ⚠️ Active service outages
- 🔒 Critical security vulnerabilities
- 💥 Data loss prevention
- 🔥 Urgent capacity issues preventing service

**DO NOT use for:**

- Routine work on weekends
- Convenient "fast-tracking"
- Avoiding normal approval

---

### Emergency Process Steps

**Step 1: Verbal Approval (Immediate)**

1. Contact Platform Lead by phone/chat
2. Explain situation and proposed fix
3. Get verbal approval to proceed
4. Document approval received

**Step 2: Implement Fix (ASAP)**

1. Create hotfix branch:
   ```bash
   git checkout -b hotfix/critical-security-patch
   ```
2. Make minimal changes to resolve issue
3. Deploy immediately:
   ```bash
   terraform plan -out=emergency.tfplan
   terraform apply emergency.tfplan
   ```

**Step 3: Verify Resolution (Within 1 hour)**

1. Confirm issue resolved
2. Monitor for side effects
3. Document exact changes made

**Step 4: Retrospective Documentation (Within 24 hours)**

1. Create pull request with hotfix code
2. Document:
   - What broke and why
   - What was changed
   - Why emergency process was needed
   - Lessons learned
   - How to prevent recurrence

**Step 5: Post-Incident Review (Within 1 week)**

1. Team review of incident
2. Identify root cause
3. Create preventive actions
4. Update runbooks if needed

---

## 🔙 Rollback Procedures

### Rollback Decision Criteria

Rollback if:

- ❌ Deployment causes service outage
- ❌ Critical functionality broken
- ❌ Security vulnerability introduced
- ❌ Unexpected cost spike
- ❌ Cannot achieve stable state

### Rollback Methods

**Method 1: Terraform State Rollback (Preferred)**

```bash
# Revert to previous Terraform state
terraform state pull > current.tfstate
terraform state push previous.tfstate
terraform apply
```

**Method 2: Git Revert (Clean)**

```bash
# Revert the merge commit
git revert <merge-commit-hash>
git push origin main

# Trigger pipeline to re-deploy previous state
```

**Method 3: Manual Resource Deletion (Last Resort)**

```bash
# Delete problematic resources manually
az resource delete --ids <resource-id>
```

### Rollback Testing

All major changes MUST include tested rollback procedure:

1. Document rollback steps
2. Test rollback in dev environment
3. Measure rollback time
4. Verify system returns to previous state

---

## 📊 Change Metrics & Reporting

### Key Metrics

Track these metrics monthly:

| Metric                    | Target              | Purpose            |
| ------------------------- | ------------------- | ------------------ |
| **Change Success Rate**   | > 95%               | Quality indicator  |
| **Average Approval Time** | < 24 hours          | Process efficiency |
| **Rollback Rate**         | < 5%                | Change quality     |
| **Emergency Changes**     | < 10% of total      | Process adherence  |
| **Time to Deploy**        | < 3 days (standard) | Delivery speed     |

### Monthly Change Report

**Template:**

```markdown
## Change Management Report - January 2026

**Total Changes:** 24
**Successful:** 23 (95.8%)
**Rolled Back:** 1 (4.2%)
**Emergency:** 2 (8.3%)

**Change Breakdown:**

- Standard: 18 (75%)
- Normal: 4 (16.7%)
- Major: 0 (0%)
- Emergency: 2 (8.3%)

**Average Metrics:**

- Approval Time: 18 hours
- Dev to Prod Time: 2.3 days
- Rollback Time: 15 minutes (1 rollback)

**Issues:**

- 1 change rolled back due to NSG rule conflict
- 2 emergency changes for security patches

**Improvements:**

- Add NSG validation to pipeline
- Create runbook for security patching
```

---

## 📅 Change Calendar

### Blackout Periods

**NO infrastructure changes during:**

- First week of each quarter (budget closing)
- Major holidays (December 24-26, January 1)
- Planned maintenance windows
- High-traffic business events

### Preferred Change Windows

| Day                  | Window           | Type            | Approval         |
| -------------------- | ---------------- | --------------- | ---------------- |
| **Tuesday-Thursday** | 10 AM - 3 PM EST | Standard/Normal | Standard process |
| **Saturday**         | 2 AM - 6 AM EST  | Major changes   | Advance approval |
| **Sunday**           | Any time         | Emergency only  | Verbal approval  |

---

## ✅ Change Request Checklist

Before submitting ANY change request:

**Planning:**

- [ ] Change purpose clearly defined
- [ ] Impact assessment completed
- [ ] Rollback plan documented
- [ ] Testing plan created

**Technical:**

- [ ] Terraform code validated
- [ ] Code formatted (`terraform fmt`)
- [ ] Variables documented
- [ ] Outputs defined
- [ ] Resources properly tagged
- [ ] No hardcoded secrets

**Review:**

- [ ] Pull request created with details
- [ ] CODEOWNERS assigned as reviewer
- [ ] All conversations resolved
- [ ] Tests passed in dev

**Deployment:**

- [ ] Dev validation successful
- [ ] Production approval obtained
- [ ] Deployment window scheduled
- [ ] Stakeholders notified

**Post-Deployment:**

- [ ] Validation tests executed
- [ ] Documentation updated
- [ ] Change log updated
- [ ] Monitoring confirmed

---

## 🔒 Compliance & Audit

### Audit Trail Requirements

ALL changes must be traceable via:

1. **Git Commit History:** Who made changes and when
2. **Pull Request Records:** What was changed and why
3. **Azure DevOps Pipeline Logs:** Deployment details
4. **Azure Activity Log:** Resource modifications
5. **Approval Records:** Who approved production changes

### Audit Query Examples

**Find all changes in last 30 days:**

```bash
git log --since="30 days ago" --oneline --graph
```

**Find who approved specific deployment:**

```bash
# In Azure DevOps, check environment deployment history
```

**View all resource modifications:**

```bash
az monitor activity-log list \
  --resource-group rg-azureplatform-prod \
  --start-time 2026-01-01T00:00:00Z \
  --output table
```

---

## 📚 Related Documentation

- [Security Baseline Policy](security-baseline-policy.md)
- [Terraform Workflow](../runbooks/terraform-workflow.md)
- [Deployment Procedures](../runbooks/deployment-procedures.md)
- [Git Workflow Guide](../standards/git-workflow-guide.md)

---

## 📅 Version History

| Version | Date       | Changes                          | Author        |
| ------- | ---------- | -------------------------------- | ------------- |
| 1.0     | 2026-01-10 | Initial change management policy | Platform Team |

---

**Document Status:** Active Policy  
**Mandatory Compliance:** Required for all infrastructure changes  
**Review Cadence:** Quarterly  
**Next Review:** April 10, 2026  
**Policy Owner:** Platform Lead
