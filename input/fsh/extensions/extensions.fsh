// ---------------------------------------------------------------------------
// Extensions
// ---------------------------------------------------------------------------

// --- QuestionnaireResponse extensions ---------------------------------------

Extension: ReferringPractitioner
Id: referring-practitioner
Title: "Referring Practitioner"
Description: """
The referring practitioner for a Special Authority Application.

The referrer is **asserted by the applicant**. It is never authenticated and never verified, and the service does not establish
that the named referrer agreed to the referral. Only registration details are held for the referrer.
"""
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "QuestionnaireResponse"
* value[x] 1..1
* value[x] only Reference(SAPractitioner)

Extension: RequestForWaiver
Id: request-for-waiver
Title: "Request For Waiver"
Description: "Indicates the applicant is requesting a waiver. Treated as `false` when absent."
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "QuestionnaireResponse"
* value[x] 1..1
* value[x] only boolean

// --- Claim extensions --------------------------------------------------------

Extension: SubmissionContext
Id: submission-context
Title: "Submission Context"
Description: """
**Asserted** source context for a submission. This is provenance only: it MUST NOT override the authenticated identity,
and MUST NOT be used for authentication or authorisation.

Clients may omit it, in which case the API derives the values from the authenticated channel context.

In FHIR R4 `Bundle` is a `Resource`, not a `DomainResource`, and cannot carry extensions, so this extension is carried
on the focal `Claim`. See Modelling Notes.
"""
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "Claim"
* extension contains
    practiceId 0..1 MS and
    workstationId 0..1 MS and
    sourceSystemId 0..1 MS and
    sourceSystemVendor 0..1 MS and
    sourceSubmittedAt 0..1 MS and
    submittingUserName 0..1 MS
* extension[practiceId] ^short = "Practice Id"
* extension[practiceId].value[x] only string
* extension[workstationId] ^short = "PMS workstation / PC Id"
* extension[workstationId].value[x] only string
* extension[sourceSystemId] ^short = "PMS Id"
* extension[sourceSystemId].value[x] only string
* extension[sourceSystemVendor] ^short = "Client vendor"
* extension[sourceSystemVendor].value[x] only string
* extension[sourceSubmittedAt] ^short = "Client timestamp, source system clock"
* extension[sourceSubmittedAt].value[x] only dateTime
* extension[submittingUserName] ^short = "PMS login user name - not an authenticated identity"
* extension[submittingUserName].value[x] only string

// --- ClaimResponse extensions ------------------------------------------------

Extension: ApplicationStatus
Id: application-status
Title: "Application Status"
Description: """
The status and outcome of a Special Authority Application. The same shape is returned whether the status
arrives synchronously from `$submit` or later through Application Enquiry.

Carried on `ClaimResponse`. It may also be carried on `Claim` in Application Enquiry results so that the
`application-status` search parameter on `Claim` has an element to evaluate (see Modelling Notes).
"""
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "ClaimResponse"
* ^context[1].type = #element
* ^context[1].expression = "Claim"
* obeys sa-appstatus-1
* extension contains
    status 1..1 MS and
    outcome 0..1 MS and
    outcomeCode 0..1 MS and
    outcomeReason 0..1 MS
* extension[status] ^short = "SUBMITTED | PENDING_REVIEW | CANCELLED | DONE"
* extension[status].value[x] only code
* extension[status].valueCode from SAApplicationStatusVS (required)
* extension[outcome] ^short = "APPROVED | INVALID | DECLINED - present only where status is DONE"
* extension[outcome].value[x] only code
* extension[outcome].valueCode from SAApplicationOutcomeVS (required)
* extension[outcomeCode] ^short = "Machine readable reason, from the Error Code Catalogue"
* extension[outcomeCode].value[x] only Coding
* extension[outcomeCode].valueCoding from SAOutcomeCodeVS (extensible)
* extension[outcomeReason] ^short = "Human readable reason"
* extension[outcomeReason].value[x] only string

Extension: ExistingApproval
Id: existing-approval
Title: "Existing Approval"
Description: """
Detail of a conflicting Approval, returned only on the synchronous `$submit` response where the Application was
declined because a conflicting Approval exists. Not returned on Application Enquiry.
"""
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "ClaimResponse"
* extension contains
    approvalType 1..1 MS and
    approvalNumber 1..1 MS and
    effectiveDate 0..1 MS and
    expiryDate 0..1 MS
* extension[approvalType].value[x] only code
* extension[approvalType].valueCode from SAApprovalTypeVS (extensible)
* extension[approvalNumber].value[x] only Identifier
* extension[approvalNumber].valueIdentifier.system = $SA-ApprovalNumber
* extension[approvalNumber].valueIdentifier.value 1..1
* extension[effectiveDate].value[x] only date
* extension[expiryDate].value[x] only date

Extension: ApprovalDetail
Id: approval-detail
Title: "Approval Detail"
Description: """
Approval facts that have no existing FHIR element, including the Approval status and the provider (pharmacy)
identity. Approval status is carried here because `ClaimResponse.status` is bound to the financial
resource status value set, which cannot express ACTIVE, CANCELLED or REVOKED.

`formNumber` and `formVersion` are facts about the Approval. They deliberately do **not** reuse the
`Questionnaire.url|version` canonical used for submission.
"""
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "ClaimResponse"
* obeys sa-detail-1
* extension contains
    approvalType 1..1 MS and
    status 1..1 MS and
    formNumber 0..1 MS and
    formVersion 0..1 MS and
    providerIdType 0..1 MS and
    providerId 0..1 MS
* extension[approvalType] ^short = "CHEM | RISK | HOSP | EXCP | TEMPLETON ..."
* extension[approvalType].value[x] only code
* extension[approvalType].valueCode from SAApprovalTypeVS (extensible)
* extension[status] ^short = "ACTIVE | CANCELLED | REVOKED"
* extension[status].value[x] only code
* extension[status].valueCode from SAApprovalStatusVS (required)
* extension[formNumber] ^short = "Schedule form number. Absent for EXCP and TEMPLETON."
* extension[formNumber].value[x] only string
* extension[formVersion] ^short = "Schedule form version. May be absent for older Approvals."
* extension[formVersion].value[x] only string
* extension[providerIdType] ^short = "CLAIMANT_NUMBER"
* extension[providerIdType].value[x] only code
* extension[providerIdType].valueCode from SAProviderIdTypeVS (required)
* extension[providerId] ^short = "Pharmacy (provider) identifier"
* extension[providerId] ^definition = "The pharmacy's identifier, system-qualified so that the approval-provider-id token search can match on system|value. Present only where the Approval carries a provider, e.g. a dispensing-linked Approval."
* extension[providerId].value[x] only Identifier
* extension[providerId].valueIdentifier.system 1..1
* extension[providerId].valueIdentifier.value 1..1

Extension: ApprovalCoverage
Id: approval-coverage
Title: "Approval Coverage"
Description: """
Coverage of an Approval, carried **only** for EXPLICIT_PHARMACEUTICALS, PRODUCT_CATEGORY and ALL_PHARMACEUTICALS.
Absent for SCHEDULE_HIERARCHY coverage: a standard CHEM/RISK Approval's coverage is re-derivable from
`approval-detail.formNumber` and `formVersion` against the schedule. NPPA and panel Approvals have no schedule
form to derive coverage from, so their coverage is carried explicitly.
"""
* ^status = #draft
* ^context[0].type = #element
* ^context[0].expression = "ClaimResponse"
* obeys sa-cov-1 and sa-cov-2
* extension contains
    type 1..1 MS and
    pharmaceutical 0..* MS and
    category 0..1 MS
* extension[type].value[x] only code
* extension[type].valueCode from SACoverageTypeVS (required)
* extension[pharmaceutical] ^short = "Covered pharmaceutical - only when type is EXPLICIT_PHARMACEUTICALS"
* extension[pharmaceutical] obeys sa-cov-3
* extension[pharmaceutical].value[x] 0..0
* extension[pharmaceutical].extension contains
    pharmacode 0..1 MS and
    ctppId 0..1 MS and
    description 0..1 MS
* extension[pharmaceutical].extension[pharmacode].value[x] only string
* extension[pharmaceutical].extension[ctppId].value[x] only string
* extension[pharmaceutical].extension[description].value[x] only string
* extension[category] ^short = "Product category - only when type is PRODUCT_CATEGORY"
* extension[category].value[x] only string
