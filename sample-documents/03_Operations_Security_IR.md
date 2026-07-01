# Acme Cloud Solutions Inc.
# Operations Security, Monitoring, and Incident Response

**Document Control:** Version 3.0 | March 2026 | Owner: Security Operations

---

## 1. Vulnerability Management Program

### 1.1 Scanning
- **Infrastructure:** Weekly Qualys vulnerability scans of all production and staging assets
- **Applications:** Snyk dependency scanning daily in CI/CD; OWASP ZAP DAST weekly on staging
- **Cloud configuration:** AWS Security Hub and Prowler scans daily

### 1.2 Remediation SLAs
| Severity | Remediation Target |
|----------|-------------------|
| Critical (CVSS 9.0+) | 7 calendar days |
| High (CVSS 7.0–8.9) | 30 calendar days |
| Medium | 90 calendar days |
| Low | Next maintenance window |

Exceptions require CISO approval with documented compensating controls.

### 1.3 Patch Management
Operating system and middleware patches are applied monthly during maintenance windows. Emergency patches for actively exploited vulnerabilities are applied within 72 hours. Database engine updates follow AWS RDS maintenance scheduling with Security team approval.

## 2. Logging and Security Monitoring

### 2.1 Log Sources
- Application logs (structured JSON via Winston)
- Authentication events (Okta, Auth0)
- AWS CloudTrail (all API activity)
- VPC Flow Logs
- WAF logs
- Database audit logs (pgAudit)

### 2.2 Centralized Logging
All security-relevant logs are forwarded to Splunk SIEM with 12-month hot storage and 7-year archive (S3 Glacier). Log integrity is protected via write-once S3 bucket policies.

### 2.3 Monitoring and Alerting
Security Operations monitors SIEM dashboards during business hours with on-call rotation for after-hours critical alerts. Alert categories include:
- Failed authentication spikes (>10 failures/minute per user)
- Privileged account activity
- WAF blocks and anomaly detection
- Unauthorized API access attempts
- Configuration changes to security groups and IAM policies

**Response SLA:** Critical alerts triaged within 15 minutes; High within 1 hour.

## 3. Malware and Endpoint Protection

- CrowdStrike Falcon EDR deployed on all corporate endpoints (Windows and macOS)
- Real-time malware scanning enabled; definitions updated automatically
- USB storage disabled on corporate devices via MDM policy
- Email filtering via Microsoft Defender for Office 365 with anti-phishing policies

## 4. Backup and Disaster Recovery

### 4.1 Backup Policy
- **RDS databases:** Automated daily snapshots with 35-day retention; cross-region replication to us-west-2
- **S3 data:** Versioning enabled; lifecycle policies for archival
- **Configuration:** Infrastructure-as-Code (Terraform) stored in Git with full history

All backups are encrypted with AWS KMS (AES-256).

### 4.2 Recovery Objectives
| Metric | Target |
|--------|--------|
| RPO (Recovery Point Objective) | 4 hours |
| RTO (Recovery Time Objective) | 8 hours |

### 4.3 Testing
Full disaster recovery tabletop exercise conducted annually. Database restore tests performed quarterly (last test: February 2026 — successful). Results documented and gaps remediated.

## 5. Incident Response Plan

### 5.1 Incident Classification
| Level | Description | Example |
|-------|-------------|---------|
| P1 Critical | Active breach, data exfiltration | Confirmed unauthorized data access |
| P2 High | Attempted breach, service compromise | Successful phishing with credential theft |
| P3 Medium | Policy violation, contained threat | Malware on single endpoint, contained |
| P4 Low | Informational | Port scan detected and blocked |

### 5.2 Response Process
1. **Detection & Reporting** — Any employee reports to security@acmecloud.com or #security-incidents Slack channel within 1 hour
2. **Triage** — Security Operations assesses severity within 15 minutes (P1/P2)
3. **Containment** — Isolate affected systems; revoke compromised credentials
4. **Eradication** — Remove threat; patch vulnerabilities exploited
5. **Recovery** — Restore services; verify integrity
6. **Post-Incident Review** — Blameless retrospective within 5 business days; update playbooks

### 5.3 Incident Response Team
- **Incident Commander:** CISO (or delegate)
- **Technical Lead:** Security Engineering on-call
- **Communications:** VP Marketing + Legal for customer notification
- **Executive Sponsor:** CTO

### 5.4 Tabletop Exercises
Incident response tabletop exercises conducted twice annually (last: November 2025). Scenarios include ransomware, data breach, and insider threat.

## 6. Business Continuity

A Business Continuity Plan (BCP) is maintained and reviewed annually. Critical business functions can operate in degraded mode using DR site in us-west-2. Customer communication templates are pre-approved for outage notifications.

## 7. Third-Party and Vendor Risk Management

### 7.1 Vendor Assessment
All vendors with access to Confidential or Restricted data undergo security assessment before contract execution. Assessments include:
- Security questionnaire (SIG Lite or custom)
- SOC 2 Type II report review (required for subprocessors handling customer data)
- Contractual security requirements (encryption, breach notification within 24 hours, right to audit)

### 7.2 Subprocessor List
Current subprocessors (AWS, Auth0, SendGrid, Stripe for billing metadata only) are documented in customer DPAs. Stripe handles payment metadata only; Acme does not store PAN or cardholder data.

### 7.3 Ongoing Monitoring
Critical vendors re-assessed annually. Vendor risk register maintained in Archer GRC.

## 8. Security Awareness and Training

- **Onboarding:** Security awareness training within first week of employment
- **Annual refresher:** Mandatory for all employees by December 31 each year
- **Phishing simulations:** Quarterly campaigns; click rate target <5% (current: 3.2%)
- **Developer training:** Annual secure coding workshop; OWASP Top 10 module in onboarding

## 9. Network Security

- Production VPC segmented into public, private application, and data subnets
- Security groups follow least-privilege (deny all inbound except required ports)
- AWS WAF with OWASP Core Rule Set on all public endpoints
- VPN required for administrative access to production (AWS Client VPN with MFA)
- No direct SSH; all admin access via SSM Session Manager with session logging

## 10. Physical Security

Acme offices use badge access with visitor logs. Production infrastructure is hosted in AWS data centers (physical security managed by AWS per shared responsibility model). Employee laptops encrypted and managed via MDM.

## 11. Compliance Status

| Framework | Status |
|-----------|--------|
| NIST CSF | Self-assessed; controls documented |
| ISO 27001 | Certification audit scheduled Q4 2026 |
| SOC 2 Type II | Audit in progress; report expected Q3 2026 |
| PCI DSS | Out of scope (no cardholder data) |

**Approved by:** Sarah Okonkwo, CISO | March 2026
