-- Seed compliance frameworks and requirements (embeddings added later via npm run seed)
-- Safe to re-run: uses ON CONFLICT

INSERT INTO frameworks (name, description, version, optional)
VALUES ('OWASP ASVS', 'OWASP Application Security Verification Standard v4.0', '4.0.3', false)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V1.1.1', 'Architecture - Secure SDLC', 'Verify the use of a secure software development lifecycle that addresses security in all stages of development.', ARRAY['SDLC', 'secure development', 'SSDLC', 'devsecops'], 'Secure SDLC policy, security gates in CI/CD pipeline documentation', 'Critical', 'Integrate security activities into every phase of the SDLC with defined security gates before production deployment.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V1.2.1', 'Architecture - Authentication', 'Verify the use of unique or appropriate session tokens rather than static API secrets.', ARRAY['session tokens', 'API secrets', 'token management'], 'Authentication architecture documentation, token lifecycle management', 'High', 'Replace static API secrets with short-lived, rotatable session tokens or OAuth2 flows.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V1.4.1', 'Architecture - Access Control', 'Verify that trusted enforcement points such as access control gateways, servers, and serverless functions enforce access controls.', ARRAY['access control', 'authorization', 'enforcement point', 'API gateway'], 'Access control architecture, API gateway authorization configuration', 'Critical', 'Implement centralized access control enforcement at API gateways and application servers, never relying solely on client-side controls.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V1.5.1', 'Architecture - Input Validation', 'Verify that input and output controls are in place to enforce trust boundaries.', ARRAY['input validation', 'output encoding', 'trust boundary'], 'Input validation standards, output encoding guidelines', 'Critical', 'Define and enforce input validation and output encoding at all trust boundaries.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V1.8.1', 'Architecture - Data Protection', 'Verify that all sensitive data is identified and classified into protection levels.', ARRAY['data classification', 'sensitive data', 'PII', 'data labeling'], 'Data classification policy, data inventory with classification labels', 'High', 'Create a data classification scheme and label all sensitive data assets accordingly.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V2.1.1', 'Authentication - Password Security', 'Verify that user set passwords are at least 12 characters in length.', ARRAY['password policy', 'password length', 'credential policy'], 'Password policy documentation, authentication configuration', 'High', 'Enforce minimum 12-character passwords with complexity requirements and breach password checking.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V2.2.1', 'Authentication - General', 'Verify that anti-automation controls are effective at mitigating breached credential testing, brute force, and account lockout attacks.', ARRAY['brute force', 'account lockout', 'rate limiting', 'CAPTCHA'], 'Account lockout policy, rate limiting configuration, CAPTCHA implementation', 'Critical', 'Implement account lockout, rate limiting, and CAPTCHA on authentication endpoints.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V2.5.1', 'Authentication - Credential Recovery', 'Verify that password recovery does not provide a different level of security than authentication.', ARRAY['password recovery', 'password reset', 'account recovery'], 'Password reset flow documentation, recovery security controls', 'High', 'Ensure password recovery uses equally strong verification (MFA, secure tokens) as primary authentication.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V2.7.1', 'Authentication - Session Management', 'Verify that the application uses session tokens rather than static API secrets.', ARRAY['session management', 'session tokens', 'JWT'], 'Session management documentation, token configuration', 'High', 'Use secure session tokens with proper expiration, rotation, and invalidation on logout.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V2.8.1', 'Authentication - MFA', 'Verify that multi-factor authentication is enforced for administrative accounts.', ARRAY['MFA', 'multi-factor', 'admin authentication', '2FA'], 'MFA policy for admin accounts, MFA enrollment records', 'Critical', 'Require MFA for all administrative and privileged accounts without exception.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V3.1.1', 'Session Management', 'Verify the application never reveals session tokens in URL parameters or error messages.', ARRAY['session exposure', 'URL parameters', 'token leakage'], 'Session handling code review, security testing results', 'Critical', 'Store session tokens in secure HTTP-only cookies, never in URLs or client-side storage.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V3.2.1', 'Session Management', 'Verify the application uses session tokens rather than static API secrets.', ARRAY['session tokens', 'token rotation', 'session fixation'], 'Session token implementation documentation', 'High', 'Implement session token rotation on privilege changes and invalidate sessions on logout.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V4.1.1', 'Access Control', 'Verify that the application enforces access control rules on a trusted service layer.', ARRAY['access control', 'authorization', 'RBAC', 'ABAC'], 'Authorization model documentation, access control test results', 'Critical', 'Enforce all authorization checks server-side; never rely on client-side access control.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V4.2.1', 'Access Control', 'Verify that the application or framework enforces a strong anti-CSRF mechanism.', ARRAY['CSRF', 'anti-CSRF', 'CSRF token', 'SameSite'], 'CSRF protection implementation, SameSite cookie configuration', 'Critical', 'Implement CSRF tokens for all state-changing operations and set SameSite cookie attributes.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V5.1.1', 'Validation - Input Handling', 'Verify that the application has defenses against HTTP parameter pollution attacks.', ARRAY['parameter pollution', 'input validation', 'HPP'], 'Input validation framework documentation, parameter handling standards', 'High', 'Validate and sanitize all HTTP parameters; reject duplicate or unexpected parameters.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V5.2.1', 'Validation - Sanitization', 'Verify that the application sanitizes user input before passing to mail systems to protect against SMTP or IMAP injection.', ARRAY['injection', 'SMTP injection', 'input sanitization'], 'Input sanitization standards, email handling security controls', 'High', 'Sanitize all user input used in email headers and body to prevent injection attacks.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V5.3.1', 'Validation - Output Encoding', 'Verify that output encoding is relevant for the interpreter and context required.', ARRAY['output encoding', 'XSS prevention', 'contextual encoding'], 'Output encoding standards, XSS testing results', 'Critical', 'Apply context-appropriate output encoding (HTML, JavaScript, URL) for all user-controlled data.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V6.2.1', 'Cryptography - Algorithms', 'Verify that all cryptographic modules fail securely.', ARRAY['cryptography', 'fail secure', 'encryption'], 'Cryptographic standards documentation, algorithm selection policy', 'High', 'Use only approved cryptographic algorithms and ensure modules fail securely without exposing keys.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V6.3.1', 'Cryptography - Random Values', 'Verify that all random numbers, random file names, random GUIDs, and random strings are generated using approved random number generator.', ARRAY['random number generation', 'CSPRNG', 'entropy'], 'Cryptographic implementation review, RNG usage documentation', 'High', 'Use cryptographically secure random number generators (CSPRNG) for all security-sensitive random values.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V7.1.1', 'Error Handling and Logging', 'Verify that the application does not log credentials or payment card numbers.', ARRAY['logging', 'PII in logs', 'credential logging', 'PCI'], 'Logging policy, log sanitization configuration', 'Critical', 'Implement log sanitization to redact credentials, PII, and payment card data from all log outputs.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V7.2.1', 'Error Handling and Logging', 'Verify that security events are logged with sufficient detail to understand the event.', ARRAY['security logging', 'audit trail', 'event logging'], 'Security event logging standards, log format documentation', 'High', 'Log all security-relevant events with timestamp, user identity, source IP, and action details.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V8.1.1', 'Data Protection', 'Verify that sensitive data is protected in storage and in transit.', ARRAY['data protection', 'encryption', 'TLS', 'at-rest encryption'], 'Encryption policy, TLS configuration, database encryption documentation', 'Critical', 'Encrypt all sensitive data at rest (AES-256) and in transit (TLS 1.2+).'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V8.2.1', 'Data Protection - Client-side', 'Verify that sensitive data is not stored in browser storage (localStorage, sessionStorage, cookies) unless encrypted.', ARRAY['client-side storage', 'localStorage', 'sensitive data exposure'], 'Client-side data handling standards, browser storage audit', 'High', 'Avoid storing sensitive data in browser storage; if necessary, encrypt with server-managed keys.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V9.1.1', 'Communications', 'Verify that TLS is used for all client connectivity, and does not fall back to insecure protocols.', ARRAY['TLS', 'HTTPS', 'transport security', 'certificate'], 'TLS configuration, certificate management, SSL Labs scan results', 'Critical', 'Enforce TLS 1.2+ on all endpoints with strong cipher suites and valid certificates.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V10.1.1', 'Malicious Code', 'Verify that a code analysis tool is in use that can detect potentially malicious code.', ARRAY['SAST', 'code analysis', 'malicious code detection'], 'SAST tool configuration, code analysis pipeline integration', 'High', 'Integrate SAST tools into the CI/CD pipeline to detect malicious or vulnerable code patterns.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V11.1.1', 'Business Logic', 'Verify the application will only process business logic flows for the same user in sequential step order.', ARRAY['business logic', 'workflow', 'step validation', 'race condition'], 'Business logic flow documentation, workflow security controls', 'High', 'Enforce sequential workflow validation server-side to prevent step-skipping attacks.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V12.1.1', 'Files and Resources', 'Verify that the application will not accept large files that could fill up storage or cause DoS.', ARRAY['file upload', 'DoS', 'file size limit', 'resource exhaustion'], 'File upload policy, size limit configuration', 'High', 'Enforce file size limits, type validation, and virus scanning on all upload endpoints.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V12.4.1', 'Files and Resources', 'Verify that files obtained from untrusted sources are stored outside the web root.', ARRAY['file storage', 'web root', 'untrusted files'], 'File storage architecture, upload handling documentation', 'Critical', 'Store uploaded files outside the web root and serve through controlled download endpoints.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V13.1.1', 'API Security', 'Verify that all application components use the same encodings and parsers to avoid parsing attacks.', ARRAY['API security', 'parsing', 'content type', 'deserialization'], 'API security standards, parser configuration documentation', 'High', 'Standardize encoding and parsing across all API components; reject unexpected content types.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V13.2.1', 'API Security', 'Verify that RESTful web services use anti-automation controls for unauthenticated endpoints.', ARRAY['API rate limiting', 'anti-automation', 'REST security'], 'API rate limiting configuration, throttling policies', 'High', 'Implement rate limiting and throttling on all public API endpoints.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V14.1.1', 'Configuration', 'Verify that the application build and deployment processes are performed in a secure and repeatable way.', ARRAY['CI/CD security', 'build pipeline', 'deployment security'], 'CI/CD pipeline security configuration, build process documentation', 'High', 'Secure CI/CD pipelines with signed artifacts, secret management, and immutable deployments.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V14.2.1', 'Configuration', 'Verify that compiler flags are configured to enable all available buffer-overflow protections.', ARRAY['compiler flags', 'buffer overflow', 'ASLR', 'DEP'], 'Compiler configuration, binary protection documentation', 'Medium', 'Enable stack canaries, ASLR, and DEP/NX bit in all compiled binaries.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V14.4.1', 'Configuration', 'Verify that every HTTP response contains a Content-Type header with a safe character set.', ARRAY['Content-Type', 'HTTP headers', 'charset', 'MIME sniffing'], 'HTTP security headers configuration, response header standards', 'Medium', 'Set Content-Type with explicit charset on all responses and enable X-Content-Type-Options: nosniff.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V14.5.1', 'Configuration - HTTP Headers', 'Verify that the application server sets Content-Security-Policy and X-Content-Type-Options headers.', ARRAY['CSP', 'security headers', 'X-Frame-Options', 'HSTS'], 'Security headers configuration, CSP policy documentation', 'High', 'Deploy comprehensive security headers: CSP, HSTS, X-Frame-Options, X-Content-Type-Options.'
FROM frameworks f WHERE f.name = 'OWASP ASVS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('CIS Controls', 'CIS Critical Security Controls v8 - prioritized cyber defense best practices', '8.0', false)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-1.1', 'CIS 1 - Inventory and Control of Enterprise Assets', 'Establish and maintain an accurate, detailed, and up-to-date inventory of all enterprise assets.', ARRAY['asset inventory', 'CMDB', 'hardware inventory', 'device management'], 'Asset inventory, CMDB records, discovery scan results', 'High', 'Deploy automated asset discovery and maintain a centralized asset inventory updated at least monthly.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-2.1', 'CIS 2 - Inventory and Control of Software Assets', 'Establish and maintain a detailed inventory of all licensed software installed on enterprise assets.', ARRAY['software inventory', 'license management', 'application catalog'], 'Software asset inventory, license compliance records', 'High', 'Implement software asset management to track all installed applications and versions.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-3.1', 'CIS 3 - Data Protection', 'Establish and maintain a data management process to identify, classify, and document sensitive data.', ARRAY['data classification', 'data inventory', 'sensitive data', 'DLP'], 'Data classification policy, data inventory, labeling procedures', 'Critical', 'Classify all data by sensitivity and implement handling requirements per classification level.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-3.2', 'CIS 3 - Data Protection', 'Encrypt sensitive data at rest on servers, applications, and databases.', ARRAY['encryption at rest', 'database encryption', 'disk encryption'], 'Encryption policy, encryption implementation for databases and storage', 'Critical', 'Enable AES-256 encryption for all sensitive data at rest including databases, file systems, and backups.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-3.3', 'CIS 3 - Data Protection', 'Encrypt sensitive data in transit using approved cryptographic protocols.', ARRAY['TLS', 'encryption in transit', 'HTTPS'], 'TLS configuration standards, certificate management', 'Critical', 'Enforce TLS 1.2+ on all data transmission channels.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-4.1', 'CIS 4 - Secure Configuration', 'Establish and maintain a secure configuration process for enterprise assets and software.', ARRAY['secure configuration', 'hardening', 'CIS benchmarks', 'baseline'], 'Configuration baselines, hardening guides, compliance scan results', 'High', 'Define and enforce secure configuration baselines based on CIS Benchmarks for all systems.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-5.1', 'CIS 5 - Account Management', 'Establish and maintain an inventory of all accounts managed in the organization.', ARRAY['account inventory', 'identity management', 'user accounts'], 'Account inventory, IAM system records', 'High', 'Maintain centralized inventory of all user and service accounts with ownership and purpose.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-5.2', 'CIS 5 - Account Management', 'Use unique passwords for all enterprise assets and rotate passwords periodically.', ARRAY['password policy', 'unique passwords', 'credential management'], 'Password policy, password manager deployment', 'High', 'Enforce unique passwords and deploy enterprise password management for all accounts.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-6.1', 'CIS 6 - Access Control Management', 'Establish and follow a process for granting access to enterprise assets based on least privilege.', ARRAY['least privilege', 'access control', 'RBAC', 'provisioning'], 'Access provisioning procedures, RBAC matrix', 'Critical', 'Implement least-privilege access with formal provisioning and deprovisioning workflows.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-6.2', 'CIS 6 - Access Control Management', 'Require multi-factor authentication for all externally-exposed enterprise applications.', ARRAY['MFA', 'multi-factor', 'external access'], 'MFA deployment for external apps, authentication policy', 'Critical', 'Deploy MFA on all internet-facing applications and VPN access.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-7.1', 'CIS 7 - Continuous Vulnerability Management', 'Establish and maintain a vulnerability management process.', ARRAY['vulnerability management', 'vulnerability scanning', 'patch management'], 'Vulnerability management policy, scan schedules, remediation tracking', 'Critical', 'Run automated vulnerability scans at least weekly and track remediation to completion.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-7.2', 'CIS 7 - Continuous Vulnerability Management', 'Perform automated vulnerability scans of enterprise assets at least monthly.', ARRAY['vulnerability scanning', 'automated scanning', 'CVE'], 'Vulnerability scan reports, scanning tool configuration', 'High', 'Deploy automated vulnerability scanning across all enterprise assets monthly at minimum.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-8.1', 'CIS 8 - Audit Log Management', 'Establish and maintain an audit log management process for enterprise assets.', ARRAY['audit logging', 'log management', 'SIEM', 'log retention'], 'Logging policy, centralized log management, retention schedules', 'High', 'Centralize logs from all critical systems with defined retention and review procedures.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-8.2', 'CIS 8 - Audit Log Management', 'Collect audit logs from enterprise assets and ensure logs are protected from tampering.', ARRAY['log collection', 'log integrity', 'tamper protection'], 'Log collection architecture, log integrity controls', 'High', 'Collect logs to a centralized SIEM with write-once storage and access controls.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-9.1', 'CIS 9 - Email and Web Browser Protections', 'Ensure only fully supported browsers and email clients are allowed in the enterprise.', ARRAY['browser security', 'email security', 'supported software'], 'Approved software list, browser/email security configuration', 'Medium', 'Maintain allowlist of supported browsers and email clients with security configurations enforced.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-10.1', 'CIS 10 - Malware Defenses', 'Deploy and maintain anti-malware software on all enterprise assets.', ARRAY['antivirus', 'anti-malware', 'EDR', 'endpoint protection'], 'EDR/antivirus deployment records, malware detection reports', 'Critical', 'Deploy EDR on all endpoints with real-time scanning and centralized management.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-11.1', 'CIS 11 - Data Recovery', 'Establish and maintain a data recovery process with tested backups.', ARRAY['backup', 'recovery', 'RTO', 'RPO', 'restore testing'], 'Backup policy, backup schedules, restore test results', 'Critical', 'Implement automated encrypted backups and test restoration quarterly.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-12.1', 'CIS 12 - Network Infrastructure Management', 'Ensure network infrastructure is kept up-to-date with security patches.', ARRAY['network patching', 'firmware updates', 'network devices'], 'Network device patch records, firmware update procedures', 'High', 'Patch network infrastructure firmware and software within defined SLAs.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-13.1', 'CIS 13 - Network Monitoring and Defense', 'Deploy network monitoring tools to identify and alert on malicious network activity.', ARRAY['network monitoring', 'IDS', 'NDR', 'network security'], 'Network monitoring tools, IDS/NDR deployment, alert configuration', 'High', 'Deploy network intrusion detection and monitor for anomalous traffic patterns.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-14.1', 'CIS 14 - Security Awareness Training', 'Establish and maintain a security awareness program for all workforce members.', ARRAY['security awareness', 'training', 'phishing simulation'], 'Training program, completion records, phishing test results', 'High', 'Deliver mandatory security awareness training annually with simulated phishing exercises.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-15.1', 'CIS 15 - Service Provider Management', 'Establish and maintain an inventory of service providers and assess their security posture.', ARRAY['vendor management', 'third party risk', 'service provider'], 'Vendor inventory, third-party risk assessments', 'High', 'Inventory all service providers and conduct security assessments before engagement.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-16.1', 'CIS 16 - Application Software Security', 'Establish secure coding practices and train developers in application security.', ARRAY['secure coding', 'developer training', 'OWASP', 'SAST'], 'Secure coding standards, developer training records, SAST integration', 'High', 'Train developers on OWASP Top 10 and integrate SAST into the development pipeline.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-17.1', 'CIS 17 - Incident Response Management', 'Establish and maintain an incident response process with defined roles and procedures.', ARRAY['incident response', 'IR plan', 'incident handling'], 'Incident response plan, playbooks, tabletop exercise records', 'Critical', 'Develop and test incident response plans with defined roles, escalation, and communication procedures.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CIS-18.1', 'CIS 18 - Penetration Testing', 'Establish and maintain a penetration testing program based on risk.', ARRAY['penetration testing', 'red team', 'security assessment'], 'Penetration test reports, testing schedule, remediation tracking', 'High', 'Conduct annual penetration tests with remediation tracking for all findings.'
FROM frameworks f WHERE f.name = 'CIS Controls'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('ISO/IEC 27001', 'ISO/IEC 27001:2022 Annex A Information Security Controls - representative control subset', '2022', false)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.1', 'Organizational Controls - Policies', 'Policies for information security shall be defined, approved by management, published, and communicated to relevant personnel.', ARRAY['information security policy', 'ISMS', 'security governance'], 'Information security policy, management approval, employee acknowledgment', 'Critical', 'Develop comprehensive information security policies approved by leadership and communicated to all personnel.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.2', 'Organizational Controls - Roles', 'Information security roles and responsibilities shall be defined and allocated.', ARRAY['roles and responsibilities', 'CISO', 'security governance'], 'RACI matrix, job descriptions with security responsibilities, org chart', 'High', 'Define and document security roles including CISO/security officer with clear accountability.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.9', 'Organizational Controls - Asset Inventory', 'An inventory of information and associated assets shall be developed and maintained.', ARRAY['asset inventory', 'information assets', 'asset register'], 'Asset register, information asset inventory', 'High', 'Maintain a comprehensive inventory of information assets with owners and classification.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.10', 'Organizational Controls - Acceptable Use', 'Rules for the acceptable use of information and assets shall be identified, documented, and implemented.', ARRAY['acceptable use policy', 'AUP', 'usage rules'], 'Acceptable use policy, employee acknowledgment records', 'Medium', 'Publish acceptable use rules covering email, internet, and data handling with employee sign-off.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.12', 'Organizational Controls - Classification', 'Information shall be classified according to the organization''s information security needs.', ARRAY['data classification', 'information classification', 'labeling'], 'Data classification scheme, classification labels on documents', 'High', 'Implement a data classification scheme (e.g., Public, Internal, Confidential, Restricted) and apply labels.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.15', 'Organizational Controls - Access Control', 'Rules to control physical and logical access to information and assets shall be established.', ARRAY['access control policy', 'logical access', 'physical access'], 'Access control policy, access management procedures', 'Critical', 'Define access control rules based on business need and least privilege principles.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.23', 'Organizational Controls - Cloud Security', 'Processes for acquisition, use, management, and exit from cloud services shall be established.', ARRAY['cloud security', 'cloud services', 'SaaS', 'shared responsibility'], 'Cloud security policy, cloud provider assessments, shared responsibility matrix', 'High', 'Establish cloud security governance including provider assessment and shared responsibility documentation.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.24', 'Organizational Controls - Incident Management', 'The organization shall plan and prepare for managing information security incidents.', ARRAY['incident management', 'incident response', 'security incidents'], 'Incident management plan, incident response procedures', 'Critical', 'Develop incident management procedures with detection, reporting, assessment, and response workflows.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.29', 'Organizational Controls - Business Continuity', 'Information security continuity shall be embedded in the organization''s business continuity management.', ARRAY['business continuity', 'BCP', 'disaster recovery', 'ISMS continuity'], 'Business continuity plan, DR plan, continuity test results', 'Critical', 'Integrate information security requirements into BCP/DR plans with defined RTOs and RPOs.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.5.30', 'Organizational Controls - Legal Compliance', 'Legal, statutory, regulatory, and contractual requirements relevant to information security shall be identified.', ARRAY['legal compliance', 'regulatory', 'GDPR', 'compliance register'], 'Compliance register, legal requirements mapping, regulatory assessments', 'High', 'Maintain a compliance register mapping applicable laws and regulations to security controls.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.6.3', 'People Controls - Awareness', 'Personnel shall receive appropriate information security awareness, education, and training.', ARRAY['security awareness', 'training', 'education'], 'Training program, completion records, awareness materials', 'High', 'Deliver role-based security awareness training with annual refreshers for all personnel.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.7.1', 'Physical Controls - Perimeters', 'Security perimeters shall be defined and used to protect areas containing information and assets.', ARRAY['physical security', 'perimeter security', 'secure areas'], 'Physical security policy, access control to facilities', 'Medium', 'Define security perimeters for offices and data centers with appropriate access controls.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.1', 'Technological Controls - Endpoint Devices', 'Information stored on, processed by, or accessible via endpoint devices shall be protected.', ARRAY['endpoint security', 'device protection', 'MDM', 'laptop security'], 'Endpoint protection policy, MDM configuration, disk encryption', 'High', 'Deploy endpoint protection including disk encryption, MDM, and anti-malware on all devices.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.2', 'Technological Controls - Privileged Access', 'The allocation and use of privileged access rights shall be restricted and managed.', ARRAY['privileged access', 'PAM', 'admin accounts', 'least privilege'], 'Privileged access management policy, admin account inventory', 'Critical', 'Implement PAM solution with just-in-time access and monitoring for all privileged accounts.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.3', 'Technological Controls - Access Restriction', 'Access to information and assets shall be restricted in accordance with the access control policy.', ARRAY['access restriction', 'RBAC', 'authorization'], 'Access control implementation, RBAC configuration', 'Critical', 'Enforce access restrictions aligned with the access control policy across all systems.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.5', 'Technological Controls - Secure Authentication', 'Secure authentication technologies and procedures shall be implemented.', ARRAY['authentication', 'MFA', 'secure login'], 'Authentication policy, MFA deployment', 'Critical', 'Deploy secure authentication including MFA for all users accessing sensitive systems.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.9', 'Technological Controls - Configuration Management', 'Configurations of hardware, software, services, and networks shall be established, documented, and monitored.', ARRAY['configuration management', 'hardening', 'baseline configuration'], 'Configuration baselines, change management records', 'High', 'Document and enforce secure configuration baselines with change control procedures.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.10', 'Technological Controls - Information Deletion', 'Information stored in systems, devices, or storage media shall be deleted when no longer required.', ARRAY['data deletion', 'data retention', 'secure disposal'], 'Data retention policy, secure deletion procedures', 'Medium', 'Define retention schedules and implement secure deletion when data is no longer needed.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.11', 'Technological Controls - Data Masking', 'Data masking shall be used in accordance with the organization''s topic-specific policy on access control.', ARRAY['data masking', 'anonymization', 'pseudonymization'], 'Data masking policy, masking implementation in non-production environments', 'Medium', 'Mask or anonymize sensitive data in development and test environments.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.12', 'Technological Controls - DLP', 'Data leakage prevention measures shall be applied to systems, networks, and endpoint devices.', ARRAY['DLP', 'data loss prevention', 'exfiltration'], 'DLP policy, DLP tool configuration', 'High', 'Deploy DLP controls to detect and prevent unauthorized data exfiltration.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.13', 'Technological Controls - Backup', 'Backup copies of information, software, and systems shall be maintained and regularly tested.', ARRAY['backup', 'restore testing', 'business continuity'], 'Backup policy, backup schedules, restore test records', 'Critical', 'Maintain encrypted backups with regular restore testing per defined RPO/RTO.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.15', 'Technological Controls - Logging', 'Logs that record activities, exceptions, faults, and information security events shall be produced and stored.', ARRAY['logging', 'audit trail', 'security events'], 'Logging policy, log sources, centralized log storage', 'High', 'Enable comprehensive logging on all critical systems with centralized storage and retention.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.16', 'Technological Controls - Monitoring', 'Networks, systems, and applications shall be monitored for anomalous behaviour and security events.', ARRAY['monitoring', 'SIEM', 'anomaly detection', 'security operations'], 'Monitoring tools, SIEM rules, SOC procedures', 'High', 'Deploy continuous monitoring with SIEM integration and defined alert response procedures.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.19', 'Technological Controls - Software Installation', 'Procedures and measures shall be implemented to securely manage software installation on operational systems.', ARRAY['software installation', 'change management', 'application whitelisting'], 'Software installation policy, change management procedures', 'Medium', 'Control software installation through change management and application allowlisting where feasible.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.20', 'Technological Controls - Network Security', 'Networks and network devices shall be secured, managed, and controlled to protect information in systems and applications.', ARRAY['network security', 'firewall', 'network segmentation', 'VPN'], 'Network security architecture, firewall rules, segmentation documentation', 'Critical', 'Implement network segmentation, firewall controls, and secure remote access.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.24', 'Technological Controls - Cryptography', 'Rules for the effective use of cryptography, including cryptographic key management, shall be defined and implemented.', ARRAY['cryptography', 'encryption', 'key management', 'PKI'], 'Cryptographic policy, key management procedures, encryption standards', 'Critical', 'Define cryptographic standards and implement centralized key management.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.25', 'Technological Controls - Secure Development', 'Rules for the secure development of software and systems shall be defined and applied.', ARRAY['secure SDLC', 'secure development', 'DevSecOps'], 'Secure development policy, SDLC documentation, security gates', 'Critical', 'Integrate security into the SDLC with threat modeling, code review, and security testing gates.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.28', 'Technological Controls - Secure Coding', 'Secure coding principles shall be applied to software development.', ARRAY['secure coding', 'OWASP', 'SAST', 'code review'], 'Secure coding standards, SAST results, code review records', 'High', 'Train developers on secure coding and enforce standards through automated scanning and review.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A.8.29', 'Technological Controls - Security Testing', 'Security testing processes shall be defined and implemented in the development life cycle.', ARRAY['security testing', 'penetration testing', 'DAST', 'vulnerability assessment'], 'Security test plan, penetration test reports, DAST/SAST results', 'High', 'Include security testing (SAST, DAST, penetration testing) in every release cycle.'
FROM frameworks f WHERE f.name = 'ISO/IEC 27001'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('NIST CSF', 'NIST Cybersecurity Framework 2.0 - Core Functions and Categories', '2.0', false)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'ID.AM-1', 'Identify - Asset Management', 'Physical devices and systems within the organization are inventoried.', ARRAY['asset inventory', 'hardware', 'device management', 'CMDB'], 'Asset inventory policy, CMDB documentation, hardware tracking procedures', 'High', 'Establish and maintain a comprehensive asset inventory including all physical devices, systems, and endpoints with ownership and classification.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'ID.AM-2', 'Identify - Asset Management', 'Software platforms and applications within the organization are inventoried.', ARRAY['software inventory', 'application catalog', 'license management'], 'Software asset management policy, application inventory list', 'High', 'Implement software asset management (SAM) to track all applications, versions, and licenses.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'ID.AM-3', 'Identify - Asset Management', 'Organizational communication and data flows are mapped.', ARRAY['data flow', 'network diagram', 'communication mapping'], 'Data flow diagrams, network architecture documentation', 'Medium', 'Create and maintain data flow diagrams showing how information moves between systems and external parties.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'ID.AM-5', 'Identify - Asset Management', 'Resources (hardware, devices, data, software) are prioritized based on their classification, criticality, and business value.', ARRAY['asset classification', 'criticality', 'business value'], 'Asset classification policy, criticality ratings documentation', 'High', 'Define asset classification criteria and assign criticality ratings to all inventoried assets.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'ID.RA-1', 'Identify - Risk Assessment', 'Asset vulnerabilities are identified and documented.', ARRAY['vulnerability assessment', 'vulnerability scanning', 'CVE'], 'Vulnerability scan reports, vulnerability management policy', 'Critical', 'Implement regular vulnerability scanning and maintain a documented vulnerability management program.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'ID.RA-2', 'Identify - Risk Assessment', 'Cyber threat intelligence is received from information sharing forums and sources.', ARRAY['threat intelligence', 'ISAC', 'threat feeds'], 'Threat intelligence subscription records, threat briefing documentation', 'Medium', 'Subscribe to relevant threat intelligence feeds and integrate findings into risk assessments.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'ID.RA-5', 'Identify - Risk Assessment', 'Threats, vulnerabilities, likelihoods, and impacts are used to determine risk.', ARRAY['risk assessment', 'risk matrix', 'threat modeling'], 'Risk assessment reports, risk register, risk treatment plans', 'Critical', 'Conduct formal risk assessments using a standardized methodology that evaluates threats, vulnerabilities, and business impact.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.AC-1', 'Protect - Access Control', 'Identities and credentials are issued, managed, verified, revoked, and audited for authorized devices, users and processes.', ARRAY['identity management', 'IAM', 'credential management', 'access control'], 'IAM policy, user provisioning procedures, access review records', 'Critical', 'Implement centralized identity and access management with automated provisioning, deprovisioning, and periodic access reviews.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.AC-3', 'Protect - Access Control', 'Remote access is managed.', ARRAY['remote access', 'VPN', 'zero trust', 'remote work'], 'Remote access policy, VPN configuration, MFA requirements for remote access', 'High', 'Enforce MFA for all remote access and implement zero-trust network access controls.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.AC-4', 'Protect - Access Control', 'Access permissions and authorizations are managed, incorporating the principles of least privilege and separation of duties.', ARRAY['least privilege', 'separation of duties', 'RBAC', 'access permissions'], 'RBAC matrix, least privilege policy, SoD controls documentation', 'Critical', 'Implement role-based access control with least privilege principles and enforce separation of duties for critical functions.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.AC-7', 'Protect - Access Control', 'Users, devices, and other assets are authenticated commensurate with the risk of the transaction.', ARRAY['authentication', 'MFA', 'multi-factor', 'adaptive authentication'], 'Authentication policy, MFA deployment documentation', 'Critical', 'Deploy multi-factor authentication for all users, especially for privileged and remote access.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.DS-1', 'Protect - Data Security', 'Data-at-rest is protected.', ARRAY['encryption at rest', 'data protection', 'disk encryption', 'database encryption'], 'Encryption policy, encryption implementation documentation for databases and storage', 'Critical', 'Encrypt all sensitive data at rest using industry-standard algorithms (AES-256) for databases, file systems, and backups.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.DS-2', 'Protect - Data Security', 'Data-in-transit is protected.', ARRAY['TLS', 'encryption in transit', 'HTTPS', 'VPN'], 'TLS configuration standards, certificate management policy', 'Critical', 'Enforce TLS 1.2+ for all data in transit and implement certificate management procedures.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.DS-5', 'Protect - Data Security', 'Protections against data leaks are implemented.', ARRAY['DLP', 'data loss prevention', 'data leakage', 'exfiltration'], 'DLP policy, DLP tool configuration, data classification labels', 'High', 'Deploy data loss prevention controls to detect and prevent unauthorized data exfiltration.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.IP-1', 'Protect - Information Protection', 'A baseline configuration of information technology/industrial control systems is created and maintained.', ARRAY['baseline configuration', 'hardening', 'CIS benchmarks', 'configuration management'], 'Baseline configuration standards, hardening guides, configuration management database', 'High', 'Define and enforce security baseline configurations based on CIS benchmarks or vendor hardening guides.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.IP-4', 'Protect - Information Protection', 'Backups of information are conducted, maintained, and tested periodically.', ARRAY['backup', 'disaster recovery', 'business continuity', 'restore testing'], 'Backup policy, backup schedules, restore test results', 'Critical', 'Implement automated backups with encryption and conduct quarterly restore testing.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.IP-6', 'Protect - Information Protection', 'Data is destroyed according to policy.', ARRAY['data destruction', 'media sanitization', 'data retention', 'secure disposal'], 'Data retention and destruction policy, sanitization certificates', 'Medium', 'Establish data retention schedules and secure destruction procedures for all media types.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.MA-1', 'Protect - Maintenance', 'Maintenance and repair of organizational assets are performed and logged, with approved and controlled tools.', ARRAY['maintenance', 'change management', 'patch management'], 'Maintenance procedures, change management records', 'Medium', 'Document maintenance procedures and ensure all changes are logged and approved through change management.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.PT-1', 'Protect - Protective Technology', 'Audit/log records are determined, documented, implemented, and reviewed in accordance with policy.', ARRAY['logging', 'audit trail', 'SIEM', 'log management'], 'Logging policy, SIEM configuration, log review procedures', 'High', 'Implement centralized logging with SIEM integration and define log retention and review schedules.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.PT-3', 'Protect - Protective Technology', 'The principle of least functionality is incorporated by configuring systems to provide only essential capabilities.', ARRAY['least functionality', 'system hardening', 'service minimization'], 'System hardening standards, unnecessary service disablement documentation', 'Medium', 'Disable unnecessary services, ports, and protocols on all systems per hardening standards.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'DE.AE-1', 'Detect - Anomalies and Events', 'A baseline of network operations and expected data flows for users and systems is established and managed.', ARRAY['network baseline', 'anomaly detection', 'behavioral analysis'], 'Network baseline documentation, anomaly detection configuration', 'High', 'Establish network traffic baselines and configure anomaly detection to identify deviations.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'DE.AE-3', 'Detect - Anomalies and Events', 'Event data are collected and correlated from multiple sources and sensors.', ARRAY['event correlation', 'SIEM', 'security monitoring', 'alerting'], 'SIEM correlation rules, security monitoring dashboard, alert configuration', 'High', 'Deploy SIEM with correlation rules across all security sensors and critical infrastructure.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'DE.CM-1', 'Detect - Continuous Monitoring', 'The network is monitored to detect potential cybersecurity events.', ARRAY['network monitoring', 'IDS', 'IPS', 'NDR'], 'Network monitoring tools configuration, IDS/IPS deployment documentation', 'High', 'Deploy network intrusion detection/prevention systems with 24/7 monitoring coverage.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'DE.CM-4', 'Detect - Continuous Monitoring', 'Malicious code is detected.', ARRAY['antivirus', 'EDR', 'malware detection', 'endpoint protection'], 'EDR/antivirus deployment documentation, malware detection reports', 'Critical', 'Deploy endpoint detection and response (EDR) on all endpoints with real-time malware scanning.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'RS.RP-1', 'Respond - Response Planning', 'Response plan is executed during or after an incident.', ARRAY['incident response', 'IR plan', 'incident handling'], 'Incident response plan, incident response playbooks, tabletop exercise records', 'Critical', 'Develop and maintain an incident response plan with defined roles, communication procedures, and regular tabletop exercises.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'RS.CO-2', 'Respond - Communications', 'Incidents are reported consistent with established criteria.', ARRAY['incident reporting', 'escalation', 'notification procedures'], 'Incident reporting procedures, escalation matrix, notification templates', 'High', 'Define incident severity criteria and establish clear reporting and escalation procedures.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'RS.AN-1', 'Respond - Analysis', 'Notifications from detection systems are investigated.', ARRAY['alert investigation', 'triage', 'security operations'], 'SOC procedures, alert triage documentation, investigation records', 'High', 'Establish SOC procedures for investigating and triaging security alerts within defined SLAs.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'RC.RP-1', 'Recover - Recovery Planning', 'Recovery plan is executed during or after a cybersecurity incident.', ARRAY['recovery plan', 'disaster recovery', 'business continuity'], 'Disaster recovery plan, BCP documentation, recovery test results', 'Critical', 'Maintain and test disaster recovery and business continuity plans with defined RTOs and RPOs.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'RC.IM-1', 'Recover - Improvements', 'Recovery plans incorporate lessons learned.', ARRAY['lessons learned', 'post-incident review', 'continuous improvement'], 'Post-incident review reports, plan update records', 'Medium', 'Conduct post-incident reviews and update recovery plans based on lessons learned.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GV.OC-1', 'Govern - Organizational Context', 'The organizational mission is understood and informs cybersecurity risk management.', ARRAY['governance', 'risk management', 'organizational context'], 'Cybersecurity governance charter, risk management framework documentation', 'High', 'Align cybersecurity program with organizational mission and establish a governance framework.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GV.RM-1', 'Govern - Risk Management Strategy', 'Risk management objectives are established and agreed to by organizational stakeholders.', ARRAY['risk appetite', 'risk tolerance', 'risk management strategy'], 'Risk appetite statement, risk management policy, board approval records', 'High', 'Define and document organizational risk appetite and tolerance levels approved by leadership.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GV.PO-1', 'Govern - Policy', 'Policy for managing cybersecurity risks is established based on organizational context and risk tolerance.', ARRAY['security policy', 'cybersecurity policy', 'information security policy'], 'Information security policy, policy review records, employee acknowledgment', 'Critical', 'Develop comprehensive information security policies reviewed annually and acknowledged by all personnel.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GV.SC-1', 'Govern - Supply Chain', 'A cybersecurity supply chain risk management program is established and agreed to by organizational stakeholders.', ARRAY['supply chain', 'third party risk', 'vendor management'], 'Third-party risk management policy, vendor assessment procedures', 'High', 'Implement a third-party risk management program with vendor security assessments and contractual requirements.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GV.OV-1', 'Govern - Oversight', 'Cybersecurity risk management strategy outcomes are reviewed to inform and adjust strategy and policy.', ARRAY['oversight', 'metrics', 'KPI', 'security reporting'], 'Security metrics dashboard, board reporting, program review records', 'Medium', 'Establish cybersecurity KPIs and report program effectiveness to leadership quarterly.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PR.AT-1', 'Protect - Awareness and Training', 'All users are informed and trained.', ARRAY['security awareness', 'training', 'phishing simulation'], 'Security awareness training program, training completion records, phishing test results', 'High', 'Implement mandatory security awareness training with annual refreshers and simulated phishing exercises.'
FROM frameworks f WHERE f.name = 'NIST CSF'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('OWASP Top 10', 'OWASP Top 10 Web Application Security Risks (2021) - critical web app vulnerabilities', '2021', false)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A01:2021', 'Broken Access Control', 'Access control enforces policy such that users cannot act outside of their intended permissions. Failures lead to unauthorized information disclosure, modification, or destruction.', ARRAY['access control', 'authorization', 'IDOR', 'privilege escalation', 'RBAC'], 'Access control policy, authorization matrix, penetration test results for access control', 'Critical', 'Implement deny-by-default access controls, enforce ownership checks server-side, and test for IDOR and privilege escalation.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A01.1', 'Broken Access Control', 'Deny access by default and enforce least privilege for all users and API endpoints.', ARRAY['least privilege', 'deny by default', 'API authorization'], 'Least privilege policy, API authorization configuration', 'Critical', 'Configure all endpoints to deny by default and grant only required permissions per role.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A02:2021', 'Cryptographic Failures', 'Sensitive data is protected at rest and in transit using strong cryptography. Failures include transmitting or storing sensitive data in cleartext.', ARRAY['encryption', 'TLS', 'cryptography', 'data protection', 'PII'], 'Encryption policy, TLS configuration, data classification with encryption requirements', 'Critical', 'Encrypt all sensitive data at rest (AES-256) and in transit (TLS 1.2+) and disable weak cipher suites.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A02.1', 'Cryptographic Failures', 'Classify data processed by the application and apply appropriate cryptographic protections.', ARRAY['data classification', 'encryption at rest', 'key management'], 'Data classification policy, encryption implementation documentation', 'High', 'Classify all application data and apply encryption proportional to sensitivity.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A03:2021', 'Injection', 'User-supplied data is validated, sanitized, and never interpreted as commands or queries. SQL, OS, LDAP, and other injection flaws are prevented.', ARRAY['SQL injection', 'injection', 'input validation', 'parameterized queries'], 'Secure coding standards, SAST/DAST results, parameterized query usage', 'Critical', 'Use parameterized queries/ORMs, validate all input, and run injection-focused security testing.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A03.1', 'Injection', 'All database queries use parameterized statements or safe ORM patterns.', ARRAY['SQL injection', 'ORM', 'prepared statements'], 'Code review records, ORM configuration, SAST scan results', 'Critical', 'Eliminate dynamic SQL concatenation; enforce parameterized queries across all data access layers.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A04:2021', 'Insecure Design', 'Security is integrated into the design and architecture phase. Threat modeling and secure design patterns are applied before implementation.', ARRAY['secure design', 'threat modeling', 'security architecture', 'STRIDE'], 'Threat models, security design reviews, secure architecture documentation', 'High', 'Conduct threat modeling for all new features and apply secure design patterns from the design phase.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A05:2021', 'Security Misconfiguration', 'Systems are securely configured with hardened defaults, minimal attack surface, and disabled unnecessary features.', ARRAY['hardening', 'security configuration', 'default credentials', 'CIS benchmarks'], 'Hardening baselines, configuration management, security scan results', 'High', 'Apply CIS/vendor hardening guides, remove default accounts, and automate configuration compliance scanning.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A05.1', 'Security Misconfiguration', 'Security headers (CSP, HSTS, X-Frame-Options) are properly configured on all HTTP responses.', ARRAY['security headers', 'CSP', 'HSTS', 'X-Frame-Options'], 'HTTP security header configuration, security header scan results', 'Medium', 'Deploy comprehensive security headers on all web application responses.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A06:2021', 'Vulnerable and Outdated Components', 'Components (libraries, frameworks, OS) are inventoried, monitored for vulnerabilities, and kept up to date.', ARRAY['SCA', 'dependency management', 'vulnerable libraries', 'SBOM', 'patch management'], 'Dependency inventory, SCA scan results, patch management policy', 'Critical', 'Maintain SBOM, scan dependencies continuously, and patch critical vulnerabilities within defined SLAs.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A07:2021', 'Identification and Authentication Failures', 'Authentication mechanisms confirm user identity and resist credential stuffing, brute force, and session hijacking.', ARRAY['authentication', 'MFA', 'password policy', 'session management', 'brute force'], 'Authentication policy, MFA deployment, account lockout configuration', 'Critical', 'Enforce MFA, strong password policies, rate limiting on login, and secure session management.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A07.1', 'Identification and Authentication Failures', 'Multi-factor authentication is required for all privileged and administrative accounts.', ARRAY['MFA', '2FA', 'admin authentication'], 'MFA policy for admins, MFA enrollment records', 'Critical', 'Require MFA for all administrative accounts without exception.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A08:2021', 'Software and Data Integrity Failures', 'Software updates and CI/CD pipelines are protected against unauthorized modification. Integrity of data and code is verified.', ARRAY['CI/CD security', 'code integrity', 'supply chain', 'signed artifacts'], 'CI/CD pipeline security, signed build artifacts, integrity verification', 'High', 'Sign and verify build artifacts, secure CI/CD pipelines, and validate third-party component integrity.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A09:2021', 'Security Logging and Monitoring Failures', 'Security-relevant events are logged, monitored, and alerted on. Logs are protected from tampering.', ARRAY['logging', 'SIEM', 'monitoring', 'audit trail', 'alerting'], 'Logging policy, SIEM configuration, alert rules, log retention policy', 'High', 'Log all authentication, authorization, and input validation failures; integrate with SIEM with real-time alerting.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A09.1', 'Security Logging and Monitoring Failures', 'Failed login attempts and access control violations are logged and monitored.', ARRAY['failed login', 'access violation', 'security events'], 'Security event logging configuration, monitoring dashboard', 'High', 'Configure logging and alerting for all failed authentication and authorization events.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A10:2021', 'Server-Side Request Forgery (SSRF)', 'The application validates and sanitizes URLs and prevents server-side requests to unintended destinations.', ARRAY['SSRF', 'URL validation', 'network segmentation', 'allowlist'], 'SSRF prevention controls, URL validation implementation, network segmentation', 'High', 'Validate and allowlist outbound URLs, segment application servers from internal networks.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A01.2', 'Broken Access Control', 'CORS policy is restrictive and does not allow unauthorized cross-origin access to sensitive resources.', ARRAY['CORS', 'cross-origin', 'access control'], 'CORS configuration documentation', 'Medium', 'Restrict CORS to trusted origins only; never use wildcard CORS with credentials.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A02.2', 'Cryptographic Failures', 'Cryptographic keys and secrets are managed securely and never hardcoded in source code.', ARRAY['secrets management', 'key management', 'hardcoded secrets'], 'Secrets management solution, code scanning for hardcoded secrets', 'Critical', 'Use a secrets manager; scan code for hardcoded credentials; rotate keys regularly.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A04.1', 'Insecure Design', 'Rate limiting is implemented on authentication, API, and resource-intensive endpoints.', ARRAY['rate limiting', 'throttling', 'DoS prevention', 'API security'], 'Rate limiting configuration, API gateway throttling policies', 'High', 'Deploy rate limiting on all public endpoints, especially authentication and data export APIs.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A06.1', 'Vulnerable Components', 'A process exists to remove unused dependencies, features, and accounts.', ARRAY['dependency cleanup', 'attack surface reduction', 'unused services'], 'Dependency audit records, decommissioning procedures', 'Medium', 'Regularly audit and remove unused libraries, services, and user accounts.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A07.2', 'Authentication Failures', 'Session tokens are invalidated on logout and expire after a defined idle timeout.', ARRAY['session timeout', 'logout', 'session invalidation'], 'Session management policy, session timeout configuration', 'High', 'Invalidate sessions server-side on logout and enforce idle session timeouts.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A08.1', 'Data Integrity', 'Deserialization of untrusted data is prevented or strictly controlled.', ARRAY['deserialization', 'untrusted data', 'object injection'], 'Deserialization controls, secure coding standards', 'High', 'Avoid deserializing untrusted data; use safe serialization formats like JSON with schema validation.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A10.1', 'SSRF', 'Internal network metadata services (e.g., cloud metadata endpoints) are blocked from application access.', ARRAY['SSRF', 'metadata endpoint', 'cloud security', 'IMDS'], 'Network egress controls, metadata endpoint protection', 'Critical', 'Block access to cloud metadata endpoints (169.254.169.254) and internal IP ranges from application servers.'
FROM frameworks f WHERE f.name = 'OWASP Top 10'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('PCI DSS', 'Payment Card Industry Data Security Standard v4.0 (Optional) - for organizations handling cardholder data', '4.0', true)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-1.1', 'Requirement 1 - Network Security Controls', 'Network security controls (NSCs) are defined and implemented to protect the cardholder data environment (CDE).', ARRAY['firewall', 'network segmentation', 'CDE', 'NSC'], 'Network diagram with CDE boundaries, firewall rule documentation', 'Critical', 'Define and document CDE boundaries with firewall rules restricting traffic to only necessary services.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-1.2', 'Requirement 1 - Network Security Controls', 'Network security controls are configured to restrict inbound and outbound traffic to the CDE.', ARRAY['firewall rules', 'traffic restriction', 'CDE access'], 'Firewall configuration standards, rule review records', 'Critical', 'Implement deny-all default firewall rules with explicit allow rules for required CDE traffic only.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-2.1', 'Requirement 2 - Secure Configurations', 'Configuration standards are developed, implemented, and maintained for all system components.', ARRAY['secure configuration', 'hardening', 'configuration standards'], 'Configuration standards, hardening guides, configuration audit results', 'High', 'Develop PCI-compliant configuration standards and verify compliance through regular audits.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-2.2', 'Requirement 2 - Secure Configurations', 'Vendor default accounts and passwords are changed or removed before systems are placed on the network.', ARRAY['default passwords', 'vendor defaults', 'account hardening'], 'Default account removal records, password change verification', 'Critical', 'Change or disable all vendor default credentials before deploying systems to production.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-3.1', 'Requirement 3 - Protect Stored Account Data', 'Account data storage is kept to a minimum with defined retention and disposal procedures.', ARRAY['data retention', 'cardholder data', 'data minimization', 'PAN storage'], 'Data retention policy, data flow diagram, PAN storage inventory', 'Critical', 'Minimize stored cardholder data, define retention limits, and implement secure disposal procedures.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-3.2', 'Requirement 3 - Protect Stored Account Data', 'Sensitive authentication data (SAD) is not stored after authorization.', ARRAY['SAD', 'CVV', 'PIN', 'track data', 'sensitive authentication data'], 'Data storage audit confirming no SAD retention, application configuration', 'Critical', 'Ensure CVV, full track data, and PIN blocks are never stored post-authorization.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-3.3', 'Requirement 3 - Protect Stored Account Data', 'PAN is rendered unreadable anywhere it is stored using strong cryptography or truncation.', ARRAY['PAN encryption', 'tokenization', 'hashing', 'truncation'], 'Encryption/tokenization implementation, key management documentation', 'Critical', 'Encrypt or tokenize all stored PAN using PCI-approved methods with proper key management.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-4.1', 'Requirement 4 - Protect Data in Transit', 'Strong cryptography and security protocols are used to safeguard PAN during transmission over open, public networks.', ARRAY['TLS', 'PAN transmission', 'encryption in transit', 'HTTPS'], 'TLS configuration, certificate management, network transmission encryption', 'Critical', 'Enforce TLS 1.2+ for all PAN transmission with strong cipher suites and valid certificates.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-5.1', 'Requirement 5 - Malware Protection', 'Anti-malware solutions are deployed on all system components except those specifically confirmed as not at risk.', ARRAY['anti-malware', 'antivirus', 'malware protection', 'EDR'], 'Anti-malware deployment records, scan schedules, detection logs', 'High', 'Deploy anti-malware on all CDE systems with automatic updates and regular scanning.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-6.1', 'Requirement 6 - Secure Systems and Software', 'Security vulnerabilities are identified and addressed through secure development practices and patch management.', ARRAY['vulnerability management', 'patch management', 'secure development'], 'Vulnerability management policy, patch records, secure SDLC documentation', 'Critical', 'Establish vulnerability identification and patching SLAs for all CDE system components.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-6.2', 'Requirement 6 - Secure Systems and Software', 'Bespoke and custom software is developed securely following PCI DSS and industry best practices.', ARRAY['secure coding', 'custom software', 'OWASP', 'code review'], 'Secure coding standards, code review records, SAST/DAST results', 'High', 'Apply secure coding practices and security testing to all custom payment applications.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-7.1', 'Requirement 7 - Restrict Access', 'Access to system components and cardholder data is limited to only those individuals whose job requires such access.', ARRAY['least privilege', 'need to know', 'access control', 'CDE access'], 'Access control policy, role-based access matrix, access reviews', 'Critical', 'Implement least-privilege access to CDE with quarterly access reviews.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-8.1', 'Requirement 8 - Identify Users and Authenticate Access', 'Processes and mechanisms for identifying users and authenticating access to system components are defined and documented.', ARRAY['user identification', 'authentication', 'unique IDs'], 'Authentication policy, unique user ID assignment procedures', 'Critical', 'Assign unique IDs to all users and define authentication requirements for CDE access.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-8.2', 'Requirement 8 - Authentication', 'Multi-factor authentication is implemented for all access into the CDE.', ARRAY['MFA', 'CDE access', 'multi-factor authentication'], 'MFA deployment for CDE access, authentication configuration', 'Critical', 'Require MFA for all personnel accessing the cardholder data environment.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-9.1', 'Requirement 9 - Physical Access', 'Physical access controls limit and monitor physical access to systems in the CDE.', ARRAY['physical access', 'data center security', 'badge access'], 'Physical access policy, access logs, visitor management procedures', 'High', 'Implement physical access controls with logging for all CDE locations.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-10.1', 'Requirement 10 - Logging and Monitoring', 'Audit logs are enabled and active for all system components and cardholder data.', ARRAY['audit logging', 'CDE monitoring', 'log management'], 'Logging configuration for CDE systems, log retention policy', 'Critical', 'Enable comprehensive audit logging on all CDE components with minimum 12-month retention.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-10.2', 'Requirement 10 - Logging and Monitoring', 'Audit logs capture all individual access to cardholder data and all actions by privileged users.', ARRAY['access logging', 'privileged user monitoring', 'cardholder data access'], 'Log content verification, privileged access monitoring', 'Critical', 'Configure logs to capture all cardholder data access and privileged user actions.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-11.1', 'Requirement 11 - Security Testing', 'Wireless access points are identified and tested for unauthorized devices at least quarterly.', ARRAY['wireless scanning', 'rogue AP detection', 'wireless security'], 'Wireless scan results, rogue AP detection procedures', 'Medium', 'Scan for unauthorized wireless access points quarterly in and around the CDE.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-11.2', 'Requirement 11 - Security Testing', 'Internal and external vulnerability scans are performed at least quarterly and after significant changes.', ARRAY['vulnerability scanning', 'ASV scan', 'quarterly scans'], 'Quarterly scan reports, ASV scan results, remediation records', 'Critical', 'Perform quarterly internal and external vulnerability scans with passing ASV scans.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-11.3', 'Requirement 11 - Security Testing', 'External and internal penetration testing is performed at least annually and after significant changes.', ARRAY['penetration testing', 'annual pentest', 'CDE testing'], 'Penetration test reports, remediation tracking', 'Critical', 'Conduct annual penetration tests covering CDE with remediation of all critical findings.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PCI-12.1', 'Requirement 12 - Information Security Policy', 'An information security policy is established, published, maintained, and disseminated to all relevant personnel.', ARRAY['information security policy', 'PCI policy', 'security program'], 'Information security policy, annual review records, employee acknowledgment', 'High', 'Maintain a PCI-aligned information security policy reviewed annually and acknowledged by personnel.'
FROM frameworks f WHERE f.name = 'PCI DSS'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('OWASP SAMM', 'OWASP Software Assurance Maturity Model v2.0', '2.0', false)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-SM-1-A', 'Governance - Strategy & Metrics', 'Understand drivers for application security and establish a strategic plan aligned with business objectives.', ARRAY['security strategy', 'appsec program', 'business alignment', 'security metrics'], 'Application security strategy document, KPI definitions, executive sponsorship records', 'High', 'Develop an application security strategy aligned with business goals with defined KPIs and executive sponsorship.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-SM-2-A', 'Governance - Strategy & Metrics', 'Measure and report application security metrics to track program effectiveness.', ARRAY['security metrics', 'KPI', 'reporting', 'dashboard'], 'Security metrics dashboard, quarterly reporting records', 'Medium', 'Define and track application security KPIs with regular reporting to stakeholders.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-SM-3-A', 'Governance - Strategy & Metrics', 'Classify data and applications based on business risk and regulatory requirements.', ARRAY['data classification', 'application risk', 'risk tiering'], 'Application inventory with risk tiers, data classification policy', 'High', 'Classify all applications by business criticality and apply proportional security controls.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-PO-1-A', 'Governance - Policy & Compliance', 'Establish and maintain application security policies and standards.', ARRAY['security policy', 'secure coding standards', 'compliance'], 'Application security policy, secure coding standards documentation', 'Critical', 'Create comprehensive application security policies and secure coding standards reviewed annually.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-PO-2-A', 'Governance - Policy & Compliance', 'Ensure compliance with relevant regulatory and industry requirements.', ARRAY['compliance', 'regulatory', 'GDPR', 'PCI-DSS', 'HIPAA'], 'Compliance mapping documentation, audit results, regulatory assessment', 'Critical', 'Map application security controls to applicable regulations and conduct periodic compliance assessments.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-PO-3-A', 'Governance - Policy & Compliance', 'Define and enforce security requirements in vendor and third-party contracts.', ARRAY['vendor security', 'third party', 'contractual requirements'], 'Vendor security requirements in contracts, third-party assessment records', 'High', 'Include security requirements and right-to-audit clauses in all vendor contracts.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-EG-1-A', 'Governance - Education & Guidance', 'Provide role-based application security training for all development team members.', ARRAY['security training', 'developer education', 'secure coding training'], 'Training program documentation, completion records, training materials', 'High', 'Implement role-based security training for developers, testers, and architects with annual refreshers.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-EG-2-A', 'Governance - Education & Guidance', 'Provide security guidance and resources accessible to development teams.', ARRAY['security guidance', 'knowledge base', 'security champions'], 'Security knowledge base, security champion program documentation', 'Medium', 'Maintain a security knowledge base and establish a security champion program within development teams.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'D-SR-1-A', 'Design - Security Requirements', 'Derive security requirements from business functionality and risk analysis.', ARRAY['security requirements', 'threat modeling', 'risk analysis'], 'Security requirements documentation, threat model outputs', 'Critical', 'Derive explicit security requirements from threat models and risk assessments for each project.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'D-SR-2-A', 'Design - Security Requirements', 'Review security requirements and design against security best practices.', ARRAY['design review', 'security architecture review', 'threat modeling'], 'Security design review records, architecture review checklist', 'High', 'Conduct security design reviews for all new features and major changes before implementation.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'D-SR-3-A', 'Design - Security Requirements', 'Perform threat modeling to identify and mitigate design-level security risks.', ARRAY['threat modeling', 'STRIDE', 'attack trees', 'risk mitigation'], 'Threat model documents, threat modeling workshop records', 'Critical', 'Perform STRIDE-based threat modeling for all applications and significant feature changes.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'D-TA-1-A', 'Design - Security Architecture', 'Maintain an accurate and up-to-date application security architecture.', ARRAY['security architecture', 'architecture documentation', 'trust boundaries'], 'Security architecture diagrams, trust boundary documentation', 'High', 'Document security architecture including trust boundaries, data flows, and security controls.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'D-TA-2-A', 'Design - Security Architecture', 'Evaluate and select security technologies and frameworks appropriate for the application.', ARRAY['security technology', 'framework selection', 'security controls'], 'Technology evaluation records, security framework adoption documentation', 'Medium', 'Evaluate and document security technology choices with justification based on application requirements.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'I-SB-1-A', 'Implementation - Secure Build', 'Use a secure and repeatable build process with integrity verification.', ARRAY['secure build', 'CI/CD', 'build integrity', 'artifact signing'], 'CI/CD pipeline security configuration, build integrity verification', 'High', 'Implement signed and verified build artifacts with immutable deployment pipelines.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'I-SB-2-A', 'Implementation - Secure Build', 'Manage dependencies and third-party libraries with known vulnerability tracking.', ARRAY['dependency management', 'SCA', 'vulnerable libraries', 'SBOM'], 'Dependency scanning results, SBOM documentation, library update procedures', 'Critical', 'Scan dependencies for known vulnerabilities and maintain a Software Bill of Materials (SBOM).'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'I-SB-3-A', 'Implementation - Secure Build', 'Enforce secure coding standards through automated and manual review processes.', ARRAY['secure coding', 'code review', 'SAST', 'coding standards'], 'Secure coding standards, SAST tool results, code review records', 'Critical', 'Integrate SAST into CI/CD and require security-focused code reviews for all changes.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'I-DM-1-A', 'Implementation - Defect Management', 'Track and manage security defects through a defined lifecycle.', ARRAY['defect management', 'vulnerability tracking', 'remediation SLA'], 'Defect tracking process, remediation SLA documentation, defect metrics', 'High', 'Track security defects in a centralized system with defined remediation SLAs by severity.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'I-DM-2-A', 'Implementation - Defect Management', 'Classify and prioritize security defects based on risk and business impact.', ARRAY['risk prioritization', 'CVSS', 'defect classification'], 'Defect classification criteria, risk-based prioritization documentation', 'High', 'Classify vulnerabilities using CVSS and prioritize remediation based on exploitability and business impact.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'I-DM-3-A', 'Implementation - Defect Management', 'Analyze root causes of security defects to prevent recurrence.', ARRAY['root cause analysis', 'defect trends', 'continuous improvement'], 'Root cause analysis records, defect trend reports', 'Medium', 'Perform root cause analysis on recurring security defects and implement preventive measures.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V-ST-1-A', 'Verification - Security Testing', 'Perform security testing aligned with the application''s risk profile.', ARRAY['security testing', 'penetration testing', 'DAST', 'security test plan'], 'Security test plan, penetration test reports, DAST scan results', 'Critical', 'Conduct security testing proportional to application risk including SAST, DAST, and periodic penetration tests.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V-ST-2-A', 'Verification - Security Testing', 'Automate security testing in the CI/CD pipeline.', ARRAY['automated testing', 'CI/CD security', 'DAST automation'], 'Automated security testing in CI/CD, test automation configuration', 'High', 'Integrate automated security testing (SAST, DAST, SCA) into every CI/CD pipeline run.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V-ST-3-A', 'Verification - Security Testing', 'Perform manual security testing for complex vulnerabilities not caught by automation.', ARRAY['manual testing', 'penetration testing', 'business logic testing'], 'Manual test plans, penetration test reports, business logic test results', 'High', 'Supplement automated testing with manual penetration testing and business logic testing annually.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V-RT-1-A', 'Verification - Requirements Testing', 'Verify that security requirements are implemented and tested.', ARRAY['requirements testing', 'security verification', 'test coverage'], 'Security requirements test cases, verification test results', 'High', 'Create test cases for each security requirement and verify implementation before release.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V-RT-2-A', 'Verification - Requirements Testing', 'Test security controls for effectiveness against defined threat scenarios.', ARRAY['control testing', 'threat scenarios', 'security validation'], 'Threat scenario test cases, control effectiveness test results', 'High', 'Test security controls against defined threat scenarios from threat models.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'O-EM-1-A', 'Operations - Environment Management', 'Maintain secure configurations for all application environments.', ARRAY['configuration management', 'hardening', 'environment security'], 'Environment hardening standards, configuration baseline documentation', 'High', 'Apply security hardening baselines to all environments and monitor for configuration drift.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'O-EM-2-A', 'Operations - Environment Management', 'Manage secrets and credentials securely across all environments.', ARRAY['secrets management', 'credential management', 'vault', 'key management'], 'Secrets management solution documentation, credential rotation procedures', 'Critical', 'Use a dedicated secrets management solution with automated rotation and audit logging.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'O-EM-3-A', 'Operations - Environment Management', 'Implement monitoring and alerting for security events in production.', ARRAY['security monitoring', 'alerting', 'SIEM', 'runtime protection'], 'Security monitoring configuration, alert rules, incident detection records', 'Critical', 'Deploy runtime application self-protection (RASP) and security monitoring with real-time alerting.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'O-IM-1-A', 'Operations - Incident Management', 'Establish an incident response process for application security incidents.', ARRAY['incident response', 'security incident', 'IR playbook'], 'Application security incident response plan, playbooks, tabletop exercise records', 'Critical', 'Develop application-specific incident response playbooks and conduct regular exercises.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'O-IM-2-A', 'Operations - Incident Management', 'Conduct post-incident reviews and implement improvements.', ARRAY['post-incident review', 'lessons learned', 'improvement'], 'Post-incident review reports, improvement action items', 'Medium', 'Conduct blameless post-incident reviews and track improvement actions to completion.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'O-IM-3-A', 'Operations - Incident Management', 'Maintain communication plans for security incident disclosure.', ARRAY['incident communication', 'disclosure', 'breach notification'], 'Incident communication plan, breach notification procedures', 'High', 'Define incident communication and breach notification procedures compliant with regulatory requirements.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'G-SM-1-B', 'Governance - Strategy & Metrics (Level 2)', 'Establish a formal application security program with dedicated resources and budget.', ARRAY['appsec program', 'dedicated resources', 'budget allocation'], 'AppSec program charter, team structure, budget documentation', 'High', 'Establish a dedicated application security team with defined roles, responsibilities, and budget.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'D-SR-1-B', 'Design - Security Requirements (Level 2)', 'Integrate security requirements into the standard development workflow and tooling.', ARRAY['workflow integration', 'security requirements', 'JIRA', 'requirements traceability'], 'Security requirements in project management tools, traceability matrix', 'High', 'Integrate security requirements as first-class items in project management with traceability to tests.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'I-SB-1-B', 'Implementation - Secure Build (Level 2)', 'Implement security gates in the CI/CD pipeline that block deployment on critical findings.', ARRAY['security gates', 'CI/CD blocking', 'quality gate'], 'CI/CD security gate configuration, blocking criteria documentation', 'Critical', 'Configure CI/CD pipelines to block deployments when critical or high security findings are detected.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'V-ST-1-B', 'Verification - Security Testing (Level 2)', 'Conduct regular penetration testing by qualified internal or external testers.', ARRAY['penetration testing', 'red team', 'security assessment'], 'Penetration test reports, tester qualifications, remediation tracking', 'Critical', 'Engage qualified penetration testers annually with remediation tracking for all findings.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'O-EM-1-B', 'Operations - Environment Management (Level 2)', 'Implement infrastructure as code with security configuration validation.', ARRAY['IaC', 'infrastructure as code', 'configuration validation', 'Terraform'], 'IaC security scanning results, infrastructure security standards', 'High', 'Use infrastructure as code with automated security configuration validation before deployment.'
FROM frameworks f WHERE f.name = 'OWASP SAMM'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('SOC 2', 'SOC 2 Trust Services Criteria (Optional) - Security, Availability, Confidentiality for service organizations', '2017', true)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC1.1', 'Common Criteria - Control Environment', 'The entity demonstrates a commitment to integrity and ethical values.', ARRAY['code of conduct', 'ethics', 'integrity', 'control environment'], 'Code of conduct, ethics policy, employee acknowledgment', 'High', 'Establish and communicate a code of conduct with ethics training for all personnel.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC1.2', 'Common Criteria - Board Oversight', 'The board of directors demonstrates independence from management and exercises oversight of system controls.', ARRAY['board oversight', 'governance', 'independence'], 'Board charter, governance documentation, oversight meeting records', 'Medium', 'Document board/management oversight responsibilities for internal control over systems.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC2.1', 'Common Criteria - Communication', 'The entity obtains or generates and uses relevant, quality information to support the functioning of internal control.', ARRAY['information quality', 'internal communication', 'control information'], 'Internal communication procedures, control documentation', 'Medium', 'Ensure quality security and operational information flows to those responsible for controls.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC3.1', 'Common Criteria - Risk Assessment', 'The entity specifies objectives with sufficient clarity to enable the identification and assessment of risks.', ARRAY['risk assessment', 'objectives', 'risk identification'], 'Risk assessment documentation, security objectives', 'High', 'Define clear security objectives and conduct formal risk assessments annually.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC3.2', 'Common Criteria - Risk Assessment', 'The entity identifies risks to the achievement of its objectives and analyzes risks as a basis for determining how to manage them.', ARRAY['risk analysis', 'threat assessment', 'risk register'], 'Risk register, risk analysis reports, threat modeling', 'High', 'Maintain a risk register with analyzed risks and treatment plans reviewed quarterly.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC5.1', 'Common Criteria - Control Activities', 'The entity selects and develops control activities that contribute to the mitigation of risks.', ARRAY['control activities', 'risk mitigation', 'security controls'], 'Control matrix mapping risks to controls, control documentation', 'High', 'Map identified risks to specific control activities and verify effectiveness.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC6.1', 'Common Criteria - Logical Access', 'The entity implements logical access security software, infrastructure, and architectures over protected information assets.', ARRAY['logical access', 'access control', 'authentication', 'authorization'], 'Access control policy, IAM configuration, access review records', 'Critical', 'Implement comprehensive logical access controls with authentication and authorization.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC6.2', 'Common Criteria - User Registration', 'Prior to issuing system credentials and granting system access, the entity registers and authorizes new users.', ARRAY['user provisioning', 'access authorization', 'onboarding'], 'User provisioning procedures, authorization records', 'High', 'Require formal authorization before granting system access to new users.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC6.3', 'Common Criteria - User Removal', 'The entity removes access to protected information assets when appropriate.', ARRAY['deprovisioning', 'access removal', 'offboarding', 'termination'], 'Offboarding procedures, access removal records, termination checklists', 'Critical', 'Revoke all system access promptly upon employee termination or role change.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC6.6', 'Common Criteria - Boundary Protection', 'The entity implements logical access security measures to protect against threats from sources outside its system boundaries.', ARRAY['boundary protection', 'firewall', 'WAF', 'network security'], 'Network security architecture, firewall/WAF configuration', 'Critical', 'Deploy perimeter security controls including firewalls and WAF to protect system boundaries.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC6.7', 'Common Criteria - Transmission Security', 'The entity restricts the transmission, movement, and removal of information to authorized internal and external users and processes.', ARRAY['data transmission', 'encryption in transit', 'DLP', 'data movement'], 'Data transmission policy, encryption configuration, DLP controls', 'High', 'Encrypt data in transit and restrict data movement to authorized channels.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC6.8', 'Common Criteria - Malware Prevention', 'The entity implements controls to prevent or detect and act upon the introduction of unauthorized or malicious software.', ARRAY['malware prevention', 'EDR', 'anti-malware', 'intrusion detection'], 'Anti-malware deployment, EDR configuration, detection logs', 'Critical', 'Deploy endpoint protection and intrusion detection across all production systems.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC7.1', 'Common Criteria - System Monitoring', 'The entity uses detection and monitoring procedures to identify changes to configurations and new vulnerabilities.', ARRAY['configuration monitoring', 'vulnerability detection', 'change detection'], 'Configuration monitoring tools, vulnerability scanning, change detection alerts', 'High', 'Monitor system configurations and vulnerabilities with automated detection and alerting.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC7.2', 'Common Criteria - Anomaly Detection', 'The entity monitors system components and the operation of controls to detect anomalies indicative of malicious acts or system failures.', ARRAY['anomaly detection', 'SIEM', 'security monitoring', 'SOC'], 'SIEM configuration, monitoring dashboards, alert procedures', 'Critical', 'Implement continuous monitoring with SIEM to detect anomalies and security events.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC7.3', 'Common Criteria - Incident Response', 'The entity evaluates security events to determine whether they could or have resulted in a failure of controls.', ARRAY['incident evaluation', 'security events', 'incident response'], 'Incident response procedures, event evaluation records', 'High', 'Establish procedures to evaluate security events and determine control impact.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC7.4', 'Common Criteria - Incident Response', 'The entity responds to identified security incidents by executing a defined incident response program.', ARRAY['incident response', 'IR program', 'incident handling'], 'Incident response plan, incident records, post-incident reviews', 'Critical', 'Maintain and test an incident response program with defined roles and communication plans.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC8.1', 'Common Criteria - Change Management', 'The entity authorizes, designs, develops, configures, documents, tests, approves, and implements changes to infrastructure and software.', ARRAY['change management', 'CAB', 'deployment process', 'change control'], 'Change management policy, change records, CAB meeting minutes', 'High', 'Implement formal change management with authorization, testing, and approval before production deployment.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'CC9.1', 'Common Criteria - Risk Mitigation (Vendors)', 'The entity identifies, selects, and develops risk mitigation activities for risks arising from vendor and business partner relationships.', ARRAY['vendor risk', 'third party', 'supplier management', 'subservice organizations'], 'Vendor risk assessment, third-party management policy', 'High', 'Assess vendor security posture before engagement and monitor ongoing compliance.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A1.1', 'Availability Criteria', 'The entity maintains, monitors, and evaluates current processing capacity and use of system components to manage capacity demand.', ARRAY['capacity planning', 'availability', 'performance monitoring', 'scalability'], 'Capacity planning documentation, performance monitoring dashboards', 'Medium', 'Monitor system capacity and plan for demand to maintain availability SLAs.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'A1.2', 'Availability Criteria', 'The entity authorizes, designs, develops, implements, maintains, and monitors environmental protections, software, and recovery infrastructure.', ARRAY['disaster recovery', 'backup', 'high availability', 'redundancy'], 'DR plan, backup procedures, HA architecture documentation', 'Critical', 'Implement DR/HA infrastructure with tested recovery procedures meeting availability commitments.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'C1.1', 'Confidentiality Criteria', 'The entity identifies and maintains confidential information to meet the entity''s objectives related to confidentiality.', ARRAY['confidentiality', 'data classification', 'confidential information'], 'Confidential data inventory, classification policy', 'High', 'Identify and classify all confidential information with appropriate handling requirements.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'C1.2', 'Confidentiality Criteria', 'The entity disposes of confidential information to meet the entity''s objectives related to confidentiality.', ARRAY['data disposal', 'confidential data destruction', 'secure deletion'], 'Data disposal procedures, destruction certificates', 'Medium', 'Implement secure disposal procedures for confidential information at end of retention.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'PI1.1', 'Processing Integrity Criteria', 'The entity obtains or generates, uses, and communicates relevant, quality information regarding the processing of data.', ARRAY['processing integrity', 'data quality', 'data validation'], 'Data validation procedures, processing integrity controls', 'Medium', 'Implement data validation and quality checks throughout processing pipelines.'
FROM frameworks f WHERE f.name = 'SOC 2'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;
