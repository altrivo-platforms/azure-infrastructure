# ADR-001: VM Scale Sets Over Azure Kubernetes Service

**Status:** Accepted  
**Date:** 2026-01-10  
**Decision Makers:** Platform Lead, Platform Engineer  
**Technical Reviewers:** Platform Team

---

## Context & Problem Statement

We need to choose a compute platform for hosting application workloads on Azure. The decision will significantly impact our architecture, operational complexity, costs, and the skills demonstrated in this portfolio project.

**Key Questions:**

- Which compute platform best demonstrates Azure infrastructure skills?
- What aligns with AZ-104 certification objectives?
- What is cost-effective for a portfolio project?
- What provides foundational knowledge for career growth?

---

## Decision Drivers

### Business Drivers

- **Cost Management:** Stay within $500/month budget
- **Learning Objectives:** Demonstrate IaaS management skills
- **Career Alignment:** Support AZ-104 certification preparation
- **Time to Value:** Complete project within 8-10 weeks

### Technical Drivers

- **Infrastructure Control:** Direct OS and network management
- **Operational Simplicity:** Minimize operational overhead
- **Scalability:** Support horizontal scaling
- **High Availability:** Deploy across availability zones
- **Security:** Enable private networking

---

## Options Considered

### Option 1: Azure Kubernetes Service (AKS)

**Description:** Managed Kubernetes service for container orchestration.

**Pros:**

- ✅ Industry-standard container orchestration
- ✅ Built-in service mesh capabilities
- ✅ Native integration with Azure services
- ✅ Automatic scaling and self-healing
- ✅ Strong developer ecosystem

**Cons:**

- ❌ Higher complexity (Kubernetes learning curve)
- ❌ Higher monthly cost (~$200-300 for basic cluster)
- ❌ Requires containerization knowledge
- ❌ Additional networking complexity (CNI, Ingress)
- ❌ Not core focus of AZ-104 certification
- ❌ May overshadow infrastructure fundamentals

**Estimated Monthly Cost:**

```
AKS Control Plane: $72/month (0.10/hour)
Worker Nodes (2x Standard_D2s_v3): $140/month
Load Balancer: $30/month
Total: ~$242/month (just compute, before storage/networking)
```

---

### Option 2: Azure VM Scale Sets (VMSS)

**Description:** Managed group of identical VMs with auto-scaling capabilities.

**Pros:**

- ✅ Direct OS-level control and management
- ✅ Lower cost for equivalent workload
- ✅ Simpler operational model
- ✅ Core AZ-104 certification topic
- ✅ Demonstrates IaaS fundamentals
- ✅ Foundation for future Kubernetes migration
- ✅ Easier to troubleshoot and debug

**Cons:**

- ❌ No native container orchestration
- ❌ Manual application deployment configuration
- ❌ No built-in service mesh
- ❌ Less "modern" compared to Kubernetes

**Estimated Monthly Cost:**

```
Dev VMSS (2x Standard_B2s): $60/month
Prod VMSS (2x Standard_D2s_v3): $140/month
Total: ~$200/month (significant savings vs AKS)
```

---

### Option 3: Azure App Service

**Description:** Fully managed PaaS for web applications.

**Pros:**

- ✅ Lowest operational overhead
- ✅ Built-in CI/CD integration
- ✅ Auto-scaling included
- ✅ Lowest cost for simple workloads

**Cons:**

- ❌ Limited infrastructure visibility
- ❌ Less control over underlying platform
- ❌ Doesn't demonstrate IaaS skills
- ❌ Not aligned with portfolio project goals

---

### Option 4: Azure Container Instances (ACI)

**Description:** Serverless container execution without orchestration.

**Pros:**

- ✅ Simplest container deployment
- ✅ Pay-per-second billing
- ✅ Fast startup times

**Cons:**

- ❌ No orchestration capabilities
- ❌ Limited scaling options
- ❌ Not suitable for complex architectures
- ❌ Doesn't demonstrate platform engineering

---

## Decision Outcome

**Chosen Option:** Option 2 - Azure VM Scale Sets (VMSS)

### Rationale

**Alignment with Project Goals:**

1. **Demonstrates Core IaaS Skills:** VMSS requires understanding of VMs, networking, storage, and OS management - fundamental Azure infrastructure knowledge
2. **AZ-104 Certification Focus:** VMSS is a core topic in AZ-104 exam (Deploy and manage Azure compute resources)
3. **Cost Effective:** Saves ~$100/month compared to AKS, allowing budget for other services
4. **Appropriate Complexity:** Challenging enough to demonstrate skills without overwhelming the project scope
5. **Career Foundation:** IaaS knowledge is foundational; Kubernetes can be learned later

**Technical Justification:**

- Provides auto-scaling and high availability
- Supports private networking and security controls
- Enables Infrastructure as Code via Terraform
- Allows hands-on OS configuration (cloud-init)
- Demonstrates troubleshooting and operational skills

**Interview Value:**

- Shows understanding of compute fundamentals
- Demonstrates cost-conscious architecture decisions
- Provides talking points about scaling strategies
- Enables discussion of infrastructure vs. platform choices

---

## Consequences

### Positive Consequences

**✅ Cost Savings:**

- ~$100/month saved vs. AKS
- More budget for networking, security, monitoring services
- Can add additional features without exceeding budget

**✅ Learning Depth:**

- Deep understanding of VM management
- Hands-on experience with OS configuration
- Network troubleshooting skills developed
- Foundation for platform engineering career

**✅ Portfolio Value:**

- Demonstrates breadth across IaaS services
- Shows cost-conscious decision making
- Provides clear progression path (IaaS → CaaS → PaaS)

**✅ Operational Simplicity:**

- Easier to debug issues (direct OS access)
- Simpler networking model
- Less abstraction to understand
- Faster incident resolution

---

### Negative Consequences

**❌ Limited Container Orchestration:**

- No native Kubernetes experience
- Manual container deployment if containerizing
- No built-in service mesh

**Mitigation:**

- Document clear migration path to AKS
- Include AKS comparison in architecture docs
- Consider Phase 2 AKS migration project

---

**❌ Manual Application Deployment:**

- Requires custom deployment scripts
- No built-in blue/green deployments
- More operational overhead for app updates

**Mitigation:**

- Use cloud-init for consistent configuration
- Implement immutable infrastructure pattern
- Document deployment procedures clearly

---

**❌ Perceived as "Less Modern":**

- VMs sometimes seen as "legacy" compared to containers
- May face questions about technology choice

**Mitigation:**

- Clearly articulate decision rationale in interviews
- Emphasize foundational knowledge importance
- Position as Phase 1 of infrastructure journey
- Highlight cost and learning considerations

---

## Alternatives Analysis

### Why Not AKS?

While AKS is powerful and widely used, it was not chosen because:

1. **Complexity vs. Value:** For portfolio project, AKS complexity doesn't add proportional learning value for core Azure skills
2. **Cost Constraints:** AKS doubles compute costs, limiting other features
3. **Scope Creep:** Would require learning Kubernetes, containers, Helm, YAML templating - shifting focus from Azure fundamentals
4. **Career Progression:** Better to master IaaS first, then add containers/orchestration later

**Future Consideration:**

- Phase 2 could migrate to AKS
- Demonstrates evolution from IaaS to CaaS
- Shows architectural migration skills

---

### Why Not App Service?

App Service was rejected because:

1. **Limited Infrastructure Visibility:** Too abstracted for infrastructure-focused portfolio
2. **Reduced Learning:** Doesn't teach OS management, networking, scaling mechanics
3. **Limited Customization:** Can't demonstrate advanced networking, security controls
4. **Career Misalignment:** Less relevant for platform/infrastructure engineer roles

---

## Migration Path to Kubernetes (Future)

To ensure this decision doesn't close future options, document clear migration path:

### Phase 2: Optional AKS Migration

**Prerequisites:**

- VMSS working in production
- Application containerized
- Helm charts created
- Kubernetes learning completed

**Migration Steps:**

1. Deploy AKS cluster in parallel
2. Migrate workloads incrementally
3. Update networking (ingress controller)
4. Cutover DNS
5. Decommission VMSS
6. Document migration process

**Benefits of Delayed Migration:**

- Demonstrates platform evolution
- Shows migration planning skills
- Provides comparison data (VMSS vs AKS)
- Adds another portfolio project

---

## Validation & Testing

### Success Criteria

To validate this decision was correct, measure:

**Learning Outcomes:**

- [ ] Passed AZ-104 certification (VMSS topics)
- [ ] Can explain VM scaling mechanics
- [ ] Understand availability zones and sets
- [ ] Comfortable with cloud-init and VM configuration

**Technical Outcomes:**

- [ ] VMSS deploys consistently via Terraform
- [ ] Auto-scaling works based on metrics
- [ ] High availability across zones verified
- [ ] Costs remain under budget

**Career Outcomes:**

- [ ] Can confidently discuss decision in interviews
- [ ] Received positive feedback on portfolio
- [ ] Demonstrates foundational Azure knowledge

---

## Related Decisions

- [ADR-002: Private Endpoints Mandatory](adr-002-private-endpoints-mandatory.md)
- [ADR-003: Terraform State Backend](adr-003-terraform-state-backend.md)
- [ADR-004: GitHub Organization Model](adr-004-github-organization-model.md)

---

## References

### Azure Documentation

- [Azure VM Scale Sets Overview](https://learn.microsoft.com/en-us/azure/virtual-machine-scale-sets/overview)
- [AKS Overview](https://learn.microsoft.com/en-us/azure/aks/intro-kubernetes)
- [AZ-104 Exam Skills Outline](https://learn.microsoft.com/en-us/certifications/exams/az-104)

### Cost Analysis

- [Azure Pricing Calculator](https://azure.microsoft.com/en-us/pricing/calculator/)
- VMSS estimated: $200/month
- AKS estimated: $300/month

### Community Discussions

- "When to use VMs vs Containers in Azure" - Azure Forums
- "IaaS to PaaS Migration Strategies" - Microsoft Docs

---

## Decision Log

| Date       | Event                   | Notes                          |
| ---------- | ----------------------- | ------------------------------ |
| 2026-01-05 | Initial discussion      | Evaluated all compute options  |
| 2026-01-07 | Cost analysis completed | AKS exceeds budget constraints |
| 2026-01-08 | AZ-104 alignment review | VMSS better aligned with exam  |
| 2026-01-10 | **Decision finalized**  | **VMSS selected for Phase 1**  |

---

## Feedback & Review

### Review Schedule

- **Next Review:** July 2026 (after Phase 1 completion)
- **Trigger Events:** Budget changes, AKS learning progress, AZ-104 certification achieved

### Review Questions

- Did VMSS meet learning objectives?
- Was cost savings significant?
- Is AKS migration still desired?
- Did decision support certification success?

---

**Status:** Accepted and Implemented  
**Effective Date:** January 10, 2026  
**Responsible Party:** Platform Team  
**Review Authority:** Platform Lead
