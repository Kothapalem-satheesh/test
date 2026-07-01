# Acme Cloud Solutions Inc.
# Application Security and Architecture Documentation

**Document Control:** Version 1.4 | March 2026 | Owner: VP Engineering / Security Architecture

---

## 1. System Overview

Acme Cloud Solutions delivers a multi-tenant B2B SaaS platform consisting of:

- **Frontend:** React SPA served via CloudFront CDN
- **API Layer:** Node.js/Express REST API on AWS ECS Fargate
- **Database:** PostgreSQL on Amazon RDS with read replicas
- **Cache:** Redis (ElastiCache) for sessions and rate limiting
- **Storage:** S3 for document uploads and exports
- **Identity:** Okta for workforce SSO; Auth0 for customer authentication

## 2. Architecture and Trust Boundaries

### 2.1 Trust Zones
1. **Public Internet** — Untrusted; WAF and CloudFront at edge
2. **DMZ** — Load balancers, API gateway (rate limiting, TLS termination)
3. **Application Tier** — ECS containers (private subnets, no direct internet access)
4. **Data Tier** — RDS and Redis in isolated subnets; accessible only from application tier
5. **Management** — Bastion via AWS SSM Session Manager (no SSH keys)

### 2.2 Data Flow
Customer data enters via HTTPS API calls authenticated with JWT bearer tokens. Data is validated at the API gateway, processed by application services, and stored encrypted in RDS. Audit logs are written to a separate logging pipeline (CloudWatch → SIEM). No customer data flows to third parties except documented subprocessors under DPA.

## 3. Authentication and Session Management

- Customer authentication: OAuth 2.0 / OpenID Connect via Auth0
- Workforce authentication: SAML 2.0 via Okta with mandatory MFA
- API authentication: Short-lived JWT tokens (15-minute expiry) with refresh token rotation
- Session tokens stored in HttpOnly, Secure, SameSite=Strict cookies
- Sessions invalidated server-side on logout and password change
- Static API secrets are prohibited; all integrations use rotatable OAuth credentials

## 4. Authorization

All authorization checks are enforced server-side. The API implements RBAC with roles: Admin, Editor, Viewer, API Service Account. Client-side UI hiding of features is not relied upon for security. API endpoints validate tenant isolation on every request to prevent cross-tenant data access (IDOR prevention).

## 5. OWASP Top 10 Mitigations

| Risk | Control |
|------|---------|
| Broken Access Control | Server-side RBAC, tenant isolation, deny-by-default |
| Cryptographic Failures | TLS 1.2+, AES-256 at rest, no sensitive data in logs |
| Injection | Parameterized queries (Prisma ORM), input validation on all endpoints |
| Insecure Design | STRIDE threat modeling for all new features |
| Security Misconfiguration | CIS-hardened AMIs, automated config scanning in CI/CD |
| Vulnerable Components | Dependabot + Snyk; critical CVEs block deployment |
| Auth Failures | MFA, rate limiting, account lockout, secure password recovery |
| Data Integrity | Signed CI/CD artifacts, immutable deployments |
| Logging Failures | Centralized logging; auth failures and admin actions logged |
| SSRF | URL allowlisting for outbound requests; metadata endpoint blocked |

## 6. Secure Software Development Lifecycle (SDLC)

### 6.1 Development Process
1. **Design:** Security requirements derived from threat model
2. **Develop:** Secure coding standards (OWASP-aligned) enforced
3. **Build:** SAST (Semgrep) and dependency scan (Snyk) in CI pipeline
4. **Test:** DAST (OWASP ZAP) on staging; security test cases per requirement
5. **Deploy:** Security gate blocks merge if Critical/High findings unresolved
6. **Operate:** Runtime monitoring, incident response

### 6.2 Threat Modeling
STRIDE-based threat modeling workshops are mandatory for:
- All new product features
- Significant architecture changes
- New third-party integrations

Outputs are stored in Confluence and linked to Jira epics.

### 6.3 Code Review
All production code changes require peer review. Security-sensitive changes (auth, crypto, access control) require additional review by Security Engineering.

## 7. API Security

- Rate limiting: 100 requests/minute per API key (public endpoints); 1000/min authenticated
- Request size limits: 10MB max payload
- Content-Type validation: Reject unexpected MIME types
- CORS: Restricted to approved customer domains; no wildcard with credentials
- Security headers on all responses: CSP, HSTS (max-age=31536000), X-Content-Type-Options, X-Frame-Options DENY

## 8. Input Validation and Output Encoding

All user input is validated against JSON schemas at API boundary. Output encoding is context-appropriate (HTML entities in UI, URL encoding in redirects). File uploads are restricted by type (PDF, DOCX, CSV) and size (25MB), scanned by ClamAV before storage.

## 9. Vulnerability Management (Application)

- SAST runs on every pull request
- DAST runs weekly against staging environment
- Penetration testing conducted annually by third-party firm (last test: January 2026)
- Critical findings remediated within 7 days; High within 30 days

## 10. Known Gaps

- Legacy internal admin tool (pre-2024) does not yet support MFA — migration to Okta SSO planned Q2 2026
- Formal OWASP SAMM Level 2 assessment not yet completed

**Approved by:** David Chen, VP Engineering | March 2026
