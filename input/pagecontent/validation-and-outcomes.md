### Where validation happens

The API (MuleSoft) validates only what it can determine without schedule or clinical knowledge. Everything requiring the
form definition, patient or practitioner resolution, or prior approval state is assessed by the
*special-authority-application-service* (D8). This guarantees every channel receives the same outcome for equivalent
Applications.

| Performed by the API | Performed by the service |
|---|---|
| Token validity, scopes and client identity | Form number and version resolve to a form in the schedule store |
| Well formed FHIR and conformance to the SA profiles | Every `criterionIdentifier` exists in that exact form version, with no duplicates |
| Presence of the QuestionnaireResponse and mandatory referenced resources | Answer datatypes match the criterion types in the form |
| Form canonical present and well formed; version present except for the Broker | NHI is well formed and resolves |
| Answer datatypes are boolean or string | Practitioner registration is valid and in scope of practice |
| Payload CPN, where present, agrees with the token | Prior approval state, eligibility and clinical criteria |
| Asserted submission context does not conflict with authenticated context | Application Number allocation and check digit |
{:.grid}

The service does not reproduce the legacy criteria-count check (D14). An incomplete Application is valid against these
profiles and is declined on assessment.

### Request errors

A request rejected by the API before reaching the service (authentication failure, profile non-conformance, malformed
canonical, conflicting context) is returned with an HTTP 4xx status and an `OperationOutcome`, which may carry several
issues. No Application is created.

### One outcome per submission

The service assesses **fail fast**: it stops at the first rule that fails and returns a **single** outcome (D9). An
Application failing several checks surfaces them one submission at a time; the prescriber corrects and resubmits until the
Application is approved or declined on a substantive ground (D20).

### How the outcome is rendered

| Service value | FHIR element |
|---|---|
| Application Number | `ClaimResponse.request.identifier` |
| Status: SUBMITTED, PENDING_REVIEW, CANCELLED, DONE | `application-status.status` |
| Outcome: APPROVED, INVALID, DECLINED (DONE only) | `application-status.outcome` |
| Machine readable reason | `application-status.outcomeCode`, `ClaimResponse.error.code`, `OperationOutcome.issue.details.coding` |
| Human readable reason | `application-status.outcomeReason`, `ClaimResponse.disposition`, `OperationOutcome.issue.diagnostics` |
| Approval Number (approved only) | `ClaimResponse.identifier`, `ClaimResponse.preAuthRef` |
| Approval dates (approved only) | `ClaimResponse.preAuthPeriod` |
| Conflicting Approval (declined only, `$submit` only) | [existing-approval](StructureDefinition-existing-approval.html) |
{:.grid}

The HSAAP status is **never** mapped to `QuestionnaireResponse.status`, which cannot distinguish PENDING_REVIEW from DONE.

`ClaimResponse.outcome` is mandatory in FHIR R4. It is populated as follows, but `application-status` is authoritative:

| HSAAP status / outcome | `ClaimResponse.outcome` |
|---|---|
| SUBMITTED, PENDING_REVIEW | `queued` |
| DONE / APPROVED, DONE / DECLINED | `complete` |
| DONE / INVALID | `error` |
| CANCELLED | `complete` |
{:.grid}

### Outcome codes

Outcome codes, their conditions and rule evaluation order are specified in the Application Decisioning design. A single
**Error Code Catalogue** is authored and published by the service and consumed by every channel, so the reason text is
identical everywhere (D10).

The catalogue is represented by the [SA Outcome Code](CodeSystem-sa-outcome-code.html) code system, which is defined with
`content = not-present` until the catalogue is published.
