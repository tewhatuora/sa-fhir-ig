### Authentication and authorisation

Authentication and authorisation follow the Health NZ Digital Services Hub security model. In summary:

* Every request requires a validated OAuth 2.0 access token and a validated signed **Request-Context** header.
* The authenticated requester identity is taken from the token and Request-Context header, **never** from the FHIR payload.
* Values asserted in the payload - the [submission-context](StructureDefinition-submission-context.html) extension, the
  submitting Organization, and any practitioner CPN - are provenance only. They are checked for consistency with the
  authenticated context and never used for authentication or authorisation.

#### Access tokens

Access tokens are issued by the Health NZ identity service using the OAuth 2.0 client credentials flow. The API checks the
token's issuer, signature, expiry (`exp`), not-before (`nbf`), audience (`aud`), scopes and that the client is an
onboarded consumer. A request that fails any check is rejected before it is processed.

The token audience SHALL be the public base domain of the environment being called (see [Environments](#environments)),
e.g. `https://api.sa.digital.health.nz` in production.

#### Scopes

| Interaction | Request | Required scope |
|---|---|---|
| [Submit Application](submit-application.html) | `POST [base]/Claim/$submit` | `system/Claim.c` |
| [Retrieve a submitted Application](enquire-application.html#retrieve-a-submitted-application) | `GET [base]/Claim?identifier=...` | `system/Claim.rs` |
| [Search Applications](enquire-application.html#search-applications) | `POST [base]/Claim/_search` | `system/Claim.rs` |
| [Retrieve Application Outcome](enquire-application.html#retrieve-application-outcome) | `GET [base]/ClaimResponse?request.identifier=...` | `system/ClaimResponse.rs` |
| [Search Application by Approval Number](enquire-application.html#search-application-by-approval-number) | `GET [base]/ClaimResponse?identifier=...` | `system/ClaimResponse.rs` |
| [Retrieve an Approval](enquire-approval.html#retrieve-an-approval) | `GET [base]/ClaimResponse?identifier=...` | `system/ClaimResponse.rs` |
| [Search Approvals](enquire-approval.html#search-approvals) | `POST [base]/ClaimResponse/_search` | `system/ClaimResponse.rs` |
{:.grid}

Enquiry interactions additionally require a validated named-user Request-Context and the role approved for that
interaction.

### Environments

| Environment | Base URL |
|---|---|
| UAT | `https://api.uat.sa.digital.health.nz/s2s/fhir/r4` |
| Production | `https://api.sa.digital.health.nz/s2s/fhir/r4` |
{:.grid}

UAT credentials are issued on completion of the onboarding assessment described below.

### Rate limiting

Requests are rate limited per onboarded consumer. The default limit is **10 transactions per second**. Requests over the
limit are rejected with HTTP `429 Too Many Requests` and may be retried after a back-off.

### Correlation

Clients SHOULD send an `X-Correlation-Id` header. It is propagated end to end, returned in the response and recorded in
audit events, and should be quoted when raising a support request.

### Onboarding

The API uses the established Health NZ **Digital Services Hub** (DSH) processes. The API is onboarded through the Digital
Asset Onboarding process. PMS vendors follow the Digital Asset Subscriber Onboarding process, which assesses the
organisation, product and intended use cases against security, information-handling and lawful-disclosure requirements
before UAT credentials are issued. Successful onboarding accredits the subscriber product for an approved business
function. Contact <integration@tewhatuora.govt.nz>.

### Auditing

The API aligns with the Health NZ DSH centralised logging and auditing design. Audit events are captured and processed
asynchronously, transformed into FHIR `AuditEvent` resources and persisted to the centralised auditing solution. See the
[Audit Events Implementation Guide](https://fhir-ig.digital.health.nz/auditevents).
