// ---------------------------------------------------------------------------
// Bundles and OperationOutcome
// ---------------------------------------------------------------------------

Profile: SASubmissionBundle
Parent: Bundle
Id: sa-submission-bundle
Title: "SA Submission Bundle"
Description: """
The request body of `POST [base]/Claim/$submit`. A `collection` Bundle containing the Special Authority Application
(`Claim`), the clinical criteria and answers (`QuestionnaireResponse`), the `Patient`, the Applicant and optional
Referrer (`Practitioner`) and the optional submitting `Organization`. The Bundle is accepted or rejected atomically.

All references between entries SHALL resolve within the Bundle.
"""
* ^status = #draft
* type = #collection
* timestamp MS
* entry 4..* MS
* entry.fullUrl 1..1 MS
* entry.resource 1..1 MS
* entry.search 0..0
* entry.request 0..0
* entry.response 0..0
* entry ^slicing.discriminator.type = #profile
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #closed
* entry ^slicing.description = "Sliced by the profile of the contained resource"
* entry contains
    claim 1..1 MS and
    questionnaireResponse 1..1 MS and
    patient 1..1 MS and
    practitioner 1..2 MS and
    organization 0..1 MS
* entry[claim].resource only SAClaim
* entry[questionnaireResponse].resource only SAQuestionnaireResponse
* entry[patient].resource only SAPatient
* entry[practitioner].resource only SAPractitioner
* entry[practitioner] ^short = "Applicant, and optional Referrer"
* entry[organization].resource only SAOrganization

Profile: SAResponseBundle
Parent: Bundle
Id: sa-response-bundle
Title: "SA Response Bundle"
Description: """
The response to `POST [base]/Claim/$submit`. A `collection` Bundle containing the SA Application ClaimResponse, the
`OperationOutcome` rendering the single outcome, and the resources the ClaimResponse references.
"""
* ^status = #draft
* type = #collection
* timestamp MS
* entry 1..* MS
* entry.fullUrl 1..1 MS
* entry.resource 1..1 MS
* entry ^slicing.discriminator.type = #profile
* entry ^slicing.discriminator.path = "resource"
* entry ^slicing.rules = #open
* entry contains
    claimResponse 1..1 MS and
    operationOutcome 0..1 MS
* entry[claimResponse].resource only SAApplicationClaimResponse
* entry[operationOutcome].resource only SAOutcomeOperationOutcome

Profile: SAOutcomeOperationOutcome
Parent: OperationOutcome
Id: sa-outcome-operationoutcome
Title: "SA Outcome OperationOutcome"
Description: """
Renders the single business outcome of a Special Authority Application in a `$submit` response. The machine readable
reason (`outcomeCode`) is carried in `issue.details.coding` and the human readable reason (`outcomeReason`) in
`issue.diagnostics`.

This profile does **not** apply to OperationOutcomes returned with HTTP 4xx/5xx for requests rejected by the API before
reaching the service (e.g. profile validation failures), which may carry several issues.
"""
* ^status = #draft
* issue 1..1 MS
* issue.severity MS
* issue.code MS
* issue.details 1..1 MS
* issue.details.coding 1..* MS
* issue.details.coding from SAOutcomeCodeVS (extensible)
* issue.diagnostics MS
