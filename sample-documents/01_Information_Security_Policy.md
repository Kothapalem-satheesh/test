# Acme Cloud Solutions Inc.
# Information Security Policy

**Document Control**
| Field | Value |
|-------|-------|
| Version | 2.1 |
| Effective Date | March 1, 2026 |
| Owner | Chief Information Security Officer |
| Classification | Internal |
| Review Cycle | Annual |

---

## 1. Purpose and Scope

This Information Security Policy establishes the framework for protecting Acme Cloud Solutions Inc. ("Acme") information assets, systems, and services. It applies to all employees, contractors, consultants, and third parties with access to Acme resources.

Acme operates a B2B SaaS platform hosted on Amazon Web Services (AWS), serving approximately 400 enterprise customers. The platform processes customer business data classified as Confidential. Acme does not process, store, or transmit payment card data; PCI DSS is explicitly out of scope.

## 2. Roles and Responsibilities

**Chief Information Security Officer (CISO):** Owns the information security program, reports to the CTO, and approves security policies.

**Security Engineering Team:** Implements technical controls, manages SIEM, conducts vulnerability assessments, and responds to security incidents.

**Engineering Leadership:** Ensures secure SDLC practices are followed across all product teams.

**All Personnel:** Comply with this policy, complete annual security awareness training, and report suspected security incidents within one hour.

## 3. Asset Management

### 3.1 Hardware and Infrastructure Inventory
Acme maintains a centralized asset inventory in ServiceNow CMDB, updated automatically via AWS Systems Manager for cloud instances and via MDM (Jamf) for corporate endpoints. Asset discovery scans run weekly. All assets are tagged with owner, environment (production/staging/development), and data classification.

### 3.2 Software Inventory
A software bill of materials (SBOM) is generated for each production release via CI/CD integration. All third-party libraries are tracked in Dependabot and Snyk. Unauthorized software installation on corporate devices is prohibited by endpoint policy.

## 4. Access Control and Identity Management

### 4.1 Identity Management
All workforce identities are managed through Okta as the single sign-on (SSO) provider. Unique user IDs are assigned to every individual; shared accounts are prohibited except for documented break-glass service accounts under PAM control.

### 4.2 Authentication
- Minimum password length: 12 characters with complexity requirements
- Passwords checked against known breach databases (Have I Been Pwned integration)
- Account lockout after 5 failed attempts within 15 minutes
- **Multi-factor authentication (MFA)** is mandatory for all employees and contractors
- **Privileged accounts** (admin, root, database, deployment) require hardware security key MFA (FIDO2) with no exceptions

### 4.3 Authorization
Role-based access control (RBAC) is enforced across all internal systems and the production platform. Access follows least-privilege principles. The RBAC matrix is reviewed quarterly by system owners and the Security team. Separation of duties is enforced for code deployment (developers cannot deploy to production without separate approver).

### 4.4 Access Provisioning and Deprovisioning
- New hire access: Manager submits ticket; IT provisions within 24 hours based on role template
- Role change: Access adjusted within 48 hours
- Termination: All access revoked within 4 hours of HR notification via automated Okta deprovisioning workflow
- Quarterly access certification campaigns are conducted for all production systems

## 5. Data Classification and Handling

### 5.1 Classification Levels
| Level | Description | Examples |
|-------|-------------|----------|
| Public | Approved for public release | Marketing materials, public docs |
| Internal | Internal use only | Internal memos, org charts |
| Confidential | Sensitive business data | Customer data, contracts, source code |
| Restricted | Highly sensitive | Credentials, encryption keys, HR records |

### 5.2 Encryption
- **At rest:** AES-256 encryption for all databases (RDS with KMS), S3 buckets (SSE-KMS), and endpoint disk encryption (BitLocker/FileVault)
- **In transit:** TLS 1.2 or higher required for all data transmission; TLS 1.0/1.1 disabled
- Certificate management via AWS Certificate Manager with automated renewal

### 5.3 Data Retention and Disposal
Data retention schedules are defined per classification level. Customer data is retained per contract terms and deleted within 90 days of account termination. Secure deletion follows NIST SP 800-88 guidelines for electronic media.

**Known Gap:** Data Loss Prevention (DLP) tooling is planned for Q3 2026 but is not yet fully deployed across email and endpoint channels.

## 6. Acceptable Use

Employees may use Acme systems for legitimate business purposes. Prohibited activities include: unauthorized data exfiltration, installation of unapproved software, circumventing security controls, sharing credentials, and accessing systems beyond authorized scope. Violations may result in disciplinary action up to termination.

## 7. Risk Management

Acme conducts formal risk assessments annually using a qualitative risk matrix (Likelihood × Impact). Identified risks are logged in the enterprise risk register with assigned owners and treatment plans. Risk appetite is defined by the executive team and reviewed annually.

## 8. Compliance Alignment

This program aligns with:
- NIST Cybersecurity Framework 2.0
- ISO/IEC 27001:2022 (certification audit scheduled Q4 2026; not yet certified)
- CIS Critical Security Controls v8
- OWASP Application Security Verification Standard (ASVS) Level 2

## 9. Policy Review

This policy is reviewed annually by the CISO and approved by executive management. All employees acknowledge receipt upon hire and annually thereafter.

**Approved by:** Jane Mitchell, CTO | Date: March 1, 2026
