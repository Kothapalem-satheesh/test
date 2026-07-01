-- GDPR and HIPAA frameworks (run after 004_seed_frameworks_data.sql)
-- Safe to re-run: uses ON CONFLICT

INSERT INTO frameworks (name, description, version, optional)
VALUES ('GDPR', 'EU General Data Protection Regulation — core privacy and data protection obligations', '2016/679', true)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-5.1', 'Principles - Lawfulness', 'Personal data shall be processed lawfully, fairly, and in a transparent manner.', ARRAY['lawful basis', 'transparency', 'privacy notice', 'legal basis'], 'Privacy policy, lawful basis documentation, transparency notices', 'Critical', 'Document lawful basis for each processing activity and publish clear privacy notices.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-5.2', 'Principles - Purpose Limitation', 'Personal data shall be collected for specified, explicit, and legitimate purposes and not further processed incompatibly.', ARRAY['purpose limitation', 'data minimization', 'processing purpose'], 'Data processing register, purpose statements in privacy policy', 'High', 'Maintain a record of processing purposes and restrict secondary use without new legal basis.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-6.1', 'Lawfulness - Legal Basis', 'Processing shall be lawful only if and to the extent that a valid legal basis applies (consent, contract, legal obligation, etc.).', ARRAY['consent', 'legal basis', 'legitimate interest', 'Article 6'], 'Legal basis assessment, consent records, LIAs', 'Critical', 'Map each processing activity to an Article 6 legal basis with supporting documentation.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-7.1', 'Consent', 'Where consent is the legal basis, the controller shall demonstrate that the data subject has consented to processing.', ARRAY['consent management', 'opt-in', 'consent records', 'withdrawal'], 'Consent logs, consent UI screenshots, withdrawal mechanism', 'High', 'Implement auditable consent capture with easy withdrawal equal to granting.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-12.1', 'Transparency', 'The controller shall provide transparent, intelligible, and easily accessible information about data processing to data subjects.', ARRAY['privacy notice', 'transparency', 'data subject information'], 'Published privacy policy, layered notices, FAQ', 'High', 'Publish layered privacy notices covering identity, purposes, rights, and retention.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-13.1', 'Transparency - Collection', 'When data is collected from the data subject, required information shall be provided at the time of collection.', ARRAY['collection notice', 'privacy at collection', 'Article 13'], 'Collection point notices, in-app disclosures', 'High', 'Display Article 13 information at every personal data collection point.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-15.1', 'Data Subject Rights - Access', 'Data subjects have the right to obtain confirmation and access to their personal data being processed.', ARRAY['DSAR', 'subject access request', 'right of access'], 'DSAR procedure, request tracking, response templates', 'High', 'Establish a DSAR intake and fulfillment process within 30-day SLA.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-17.1', 'Data Subject Rights - Erasure', 'Data subjects have the right to obtain erasure of personal data without undue delay where grounds apply.', ARRAY['right to erasure', 'right to be forgotten', 'data deletion'], 'Deletion procedure, retention schedule, erasure logs', 'High', 'Define erasure workflows across primary systems and backups where feasible.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-25.1', 'Privacy by Design', 'The controller shall implement appropriate technical and organizational measures for data protection by design and by default.', ARRAY['privacy by design', 'data protection by default', 'PbD'], 'SDLC privacy requirements, DPIA templates, architecture reviews', 'Critical', 'Integrate privacy requirements into SDLC gates and default to minimal data collection.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-30.1', 'Records of Processing', 'Controllers shall maintain records of processing activities under their responsibility.', ARRAY['ROPA', 'processing register', 'Article 30', 'data inventory'], 'Record of Processing Activities (ROPA), data flow maps', 'Critical', 'Maintain an Article 30 ROPA updated at least quarterly.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-32.1', 'Security of Processing', 'Controllers and processors shall implement appropriate technical and organizational security measures.', ARRAY['encryption', 'security measures', 'pseudonymization', 'confidentiality'], 'Security policy, encryption standards, access controls', 'Critical', 'Implement encryption at rest and in transit for personal data with documented key management.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-33.1', 'Breach Notification', 'Personal data breaches shall be notified to the supervisory authority within 72 hours where feasible.', ARRAY['breach notification', '72 hours', 'supervisory authority', 'incident'], 'Breach response plan, notification templates, incident register', 'Critical', 'Define 72-hour breach notification workflow with DPO and legal involvement.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-34.1', 'Breach Communication', 'When a breach is likely to result in high risk, data subjects shall be informed without undue delay.', ARRAY['data subject notification', 'high risk breach', 'breach communication'], 'Breach communication templates, risk assessment criteria', 'High', 'Include data subject notification criteria and templates in the breach response plan.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-35.1', 'DPIA', 'A data protection impact assessment shall be carried out where processing is likely to result in high risk.', ARRAY['DPIA', 'privacy impact assessment', 'high risk processing'], 'DPIA procedure, completed DPIAs, risk register', 'High', 'Screen new processing for DPIA triggers and complete assessments before go-live.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-37.1', 'DPO', 'A Data Protection Officer shall be designated where required by law or organizational practice.', ARRAY['DPO', 'data protection officer', 'privacy officer'], 'DPO appointment letter, contact details, independence documentation', 'Medium', 'Designate a DPO or privacy lead with published contact details and independence.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-28.1', 'Processors', 'Processing by a processor shall be governed by a contract with required Article 28 clauses.', ARRAY['DPA', 'data processing agreement', 'subprocessor', 'vendor'], 'Signed DPAs, subprocessor list, vendor assessments', 'High', 'Execute Article 28 DPAs with all processors and maintain subprocessor register.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-44', 'International Transfers', 'Transfers of personal data outside the EEA shall only occur with appropriate safeguards.', ARRAY['international transfer', 'SCCs', 'adequacy', 'cross-border'], 'Transfer impact assessments, SCCs, transfer register', 'High', 'Document all cross-border transfers with SCCs or adequacy decisions and TIAs.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'GDPR-5.1.e', 'Principles - Retention', 'Personal data shall be kept in a form permitting identification for no longer than necessary.', ARRAY['retention', 'data lifecycle', 'deletion schedule'], 'Retention policy, automated deletion jobs, retention schedule', 'High', 'Define retention periods per data category and enforce via automated deletion.'
FROM frameworks f WHERE f.name = 'GDPR'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO frameworks (name, description, version, optional)
VALUES ('HIPAA', 'HIPAA Security Rule — administrative, physical, and technical safeguards for ePHI', '45 CFR Part 164', true)
ON CONFLICT (name) DO UPDATE SET description = EXCLUDED.description, version = EXCLUDED.version, optional = EXCLUDED.optional;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.a1', 'Administrative - Security Management', 'Implement policies and procedures to prevent, detect, contain, and correct security violations (Security Management Process).', ARRAY['security management', 'risk analysis', 'sanction policy', 'HIPAA'], 'Security policies, risk analysis, sanction policy', 'Critical', 'Establish a formal security management program with documented risk analysis and sanction policy.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.a3', 'Administrative - Workforce Security', 'Implement policies and procedures to ensure workforce members have appropriate access to ePHI and prevent unauthorized access.', ARRAY['workforce security', 'authorization', 'supervision', 'termination'], 'Access authorization procedures, termination checklist, role definitions', 'Critical', 'Document workforce authorization, supervision, and termination procedures for ePHI access.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.a4', 'Administrative - Information Access', 'Implement policies and procedures for authorizing access to ePHI based on user role and minimum necessary.', ARRAY['information access management', 'minimum necessary', 'role-based access'], 'Access control policy, role matrix, provisioning procedures', 'Critical', 'Implement role-based access with minimum necessary principle for all ePHI systems.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.a5', 'Administrative - Security Awareness', 'Implement a security awareness and training program for all workforce members.', ARRAY['security training', 'awareness', 'phishing', 'HIPAA training'], 'Training program, completion records, annual training schedule', 'High', 'Deliver annual HIPAA security awareness training with documented completion tracking.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.a6', 'Administrative - Incident Procedures', 'Implement policies and procedures to address security incidents including identification, response, and mitigation.', ARRAY['incident response', 'security incident', 'breach', 'ePHI'], 'Incident response plan, incident log, breach notification procedures', 'Critical', 'Maintain HIPAA incident response procedures including breach assessment and notification.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.a7', 'Administrative - Contingency Plan', 'Establish policies and procedures for responding to emergencies that damage systems containing ePHI.', ARRAY['contingency plan', 'disaster recovery', 'backup', 'emergency mode'], 'Contingency plan, DR tests, backup procedures, emergency access', 'Critical', 'Document and test contingency plans including data backup, DR, and emergency mode operations.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.b1', 'Administrative - Evaluation', 'Perform periodic technical and nontechnical evaluations of security policies and controls.', ARRAY['security evaluation', 'periodic review', 'audit', 'assessment'], 'Annual security evaluation reports, audit findings, remediation tracking', 'High', 'Conduct annual evaluations of HIPAA safeguards with documented remediation.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.310.a1', 'Physical - Facility Access', 'Implement policies and procedures to limit physical access to facilities and systems containing ePHI.', ARRAY['facility access', 'physical security', 'data center', 'badge'], 'Physical access policy, visitor logs, facility controls', 'High', 'Control physical access to ePHI systems with badges, logs, and visitor procedures.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.310.d1', 'Physical - Device and Media', 'Implement policies governing receipt, movement, and disposal of hardware and media containing ePHI.', ARRAY['media disposal', 'device controls', 'hard drive', 'sanitization'], 'Media disposal policy, destruction certificates, asset tracking', 'High', 'Define secure media disposal with certificates of destruction for ePHI media.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.312.a1', 'Technical - Access Control', 'Implement technical policies and procedures allowing only authorized access to ePHI.', ARRAY['access control', 'unique user ID', 'automatic logoff', 'encryption'], 'Technical access controls, unique IDs, session timeout configuration', 'Critical', 'Enforce unique user identification, emergency access, automatic logoff, and encryption.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.312.b', 'Technical - Audit Controls', 'Implement hardware, software, and procedural mechanisms to record and examine activity in ePHI systems.', ARRAY['audit controls', 'audit logs', 'ePHI access logging'], 'Audit logging policy, log retention, SIEM configuration', 'Critical', 'Enable comprehensive audit logging for all ePHI access with retention and review.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.312.c1', 'Technical - Integrity', 'Implement policies and procedures to protect ePHI from improper alteration or destruction.', ARRAY['integrity', 'checksum', 'tamper protection', 'ePHI'], 'Integrity controls documentation, change management, hashing', 'High', 'Protect ePHI integrity with change controls and tamper detection mechanisms.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.312.d', 'Technical - Authentication', 'Implement procedures to verify that persons or entities seeking access to ePHI are who they claim to be.', ARRAY['authentication', 'MFA', 'password policy', 'identity verification'], 'Authentication policy, MFA enforcement, password standards', 'Critical', 'Require MFA for remote and privileged access to ePHI systems.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.312.e1', 'Technical - Transmission Security', 'Implement technical security measures to guard against unauthorized access to ePHI transmitted over networks.', ARRAY['transmission security', 'TLS', 'encryption in transit', 'VPN'], 'Encryption standards, TLS configuration, VPN policy', 'Critical', 'Encrypt all ePHI in transit using TLS 1.2+ and secure VPN for remote access.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.314.a1', 'Organizational - Business Associates', 'Covered entities shall have contracts or agreements with business associates ensuring appropriate safeguards.', ARRAY['BAA', 'business associate agreement', 'vendor', 'third party'], 'Signed BAAs, vendor risk assessments, BA register', 'Critical', 'Execute BAAs with all business associates before sharing ePHI.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.316.b1', 'Policies and Documentation', 'Maintain written policies and procedures and documentation of required actions, activities, and assessments for six years.', ARRAY['documentation', 'policy retention', 'six years', 'records'], 'Policy repository, version control, retention schedule', 'Medium', 'Maintain HIPAA documentation with version control and 6-year retention.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.308.a2', 'Administrative - Risk Analysis', 'Conduct an accurate and thorough assessment of potential risks and vulnerabilities to the confidentiality, integrity, and availability of ePHI.', ARRAY['risk analysis', 'risk assessment', 'vulnerability', 'ePHI'], 'Risk analysis report, risk register, remediation plan', 'Critical', 'Perform comprehensive HIPAA risk analysis annually and after significant changes.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;

INSERT INTO requirements (framework_id, requirement_code, category, requirement_text, keywords, expected_evidence, severity, recommendation_text)
SELECT f.id, 'HIPAA-164.312.a2', 'Technical - Encryption', 'Implement a mechanism to encrypt and decrypt ePHI where reasonable and appropriate (addressable).', ARRAY['encryption at rest', 'ePHI encryption', 'AES', 'key management'], 'Encryption policy, at-rest encryption configuration, key management', 'High', 'Encrypt ePHI at rest on all systems storing PHI with documented key management.'
FROM frameworks f WHERE f.name = 'HIPAA'
ON CONFLICT (framework_id, requirement_code) DO UPDATE SET
  category = EXCLUDED.category, requirement_text = EXCLUDED.requirement_text, keywords = EXCLUDED.keywords,
  expected_evidence = EXCLUDED.expected_evidence, severity = EXCLUDED.severity, recommendation_text = EXCLUDED.recommendation_text;
