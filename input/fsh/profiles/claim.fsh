// ---------------------------------------------------------------------------
// Claim and ClaimResponse
// ---------------------------------------------------------------------------

RuleSet: SANoFinancialClaimResponse
// Monetary amounts are never present on a Special Authority Application or Approval
* payeeType 0..0
* item 0..0
* addItem 0..0
* adjudication 0..0
* total 0..0
* payment 0..0
* fundsReserve 0..0
* formCode 0..0
* form 0..0
* insurance 0..0

Profile: SAClaim
Parent: Claim
Id: sa-claim
Title: "SA Claim"
Description: """
A Special Authority Application: a request for authorisation of funded pharmaceuticals in advance of their supply, i.e.
a `Claim` with `use = preauthorization`. Submitted inside an SA Submission Bundle to `Claim/$submit`.

* The clinical criteria and answers are carried by the `QuestionnaireResponse` referenced from `supportingInfo`.
* `provider` references the Applicant - the same `Practitioner` as `QuestionnaireResponse.author`. FHIR R4 `Claim` has
  no `requestor` element; the custom `requestor` search parameter evaluates `Claim.provider`, so
  `requestor:Practitioner.identifier` searches and `_include=Claim:requestor` resolve to the Applicant.
* `identifier` carries the **Application Number only**. It is absent on submission and is populated by the API.
* `item` is used **only** for NPPA and panel approval Applications, where no form declares coverage. Standard Special
  Authority Applications SHALL NOT supply `item`; coverage is derived from the resolved form at decision time.
* Financial elements are constrained out. Monetary amounts are never present.
* `insurance` is mandatory in FHIR R4 `Claim`. It carries a logical reference to the Pharmaceutical Schedule and has no
  other meaning (see Modelling Notes).
"""
* ^status = #draft
* extension contains
    SubmissionContext named submissionContext 0..1 MS and
    ApplicationStatus named applicationStatus 0..1 MS
* extension[submissionContext] ^short = "Asserted source context - provenance only"
* extension[applicationStatus] ^short = "Populated by the API on Application Enquiry. SHALL NOT be sent on submission."
* identifier 0..1 MS
* identifier ^short = "Application Number - populated by the API, absent on submission"
* identifier.system 1..1
* identifier.system = $SA-ApplicationNumber (exactly)
* identifier.value 1..1
* status = #active
* type = $claim-type#pharmacy
* subType 0..0
* use = #preauthorization
* patient MS
* patient only Reference(SAPatient)
* billablePeriod 0..0
* created MS
* enterer 0..0
* insurer 0..0
* provider MS
* provider only Reference(SAPractitioner)
* provider ^short = "The Applicant - same Practitioner as QuestionnaireResponse.author"
* provider ^comment = "FHIR R4 Claim has no requestor element, so Claim.provider ('the provider responsible for the preauthorization') carries the Applicant. The custom 'requestor' search parameter on Claim evaluates Claim.provider, so requestor searches behave the same on Claim and ClaimResponse."
* priority = $processpriority#normal
* fundsReserve 0..0
* related 0..0
* prescription 0..0
* originalPrescription 0..0
* payee 0..0
* referral 0..0
* referral ^comment = "The referrer is carried by the referring-practitioner extension on the QuestionnaireResponse."
* facility 0..0
* careTeam 0..0
* supportingInfo 1..* MS
* supportingInfo ^slicing.discriminator.type = #pattern
* supportingInfo ^slicing.discriminator.path = "category"
* supportingInfo ^slicing.rules = #open
* supportingInfo contains questionnaireResponse 1..1 MS
* supportingInfo[questionnaireResponse].category = SASupportingInfoCategoryCS#questionnaire-response
* supportingInfo[questionnaireResponse].value[x] 1..1 MS
* supportingInfo[questionnaireResponse].value[x] only Reference(SAQuestionnaireResponse)
* diagnosis 0..0
* procedure 0..0
* insurance 1..1
* insurance ^short = "Mandatory in FHIR R4 - logical reference to the Pharmaceutical Schedule only"
* insurance.sequence = 1
* insurance.focal = true (exactly)
* insurance.identifier 0..0
* insurance.coverage.reference 0..0
* insurance.coverage.display 1..1
* insurance.coverage.display = "Pharmaceutical Schedule"
* insurance.businessArrangement 0..0
* insurance.preAuthRef 0..0
* insurance.claimResponse 0..0
* accident 0..0
* item MS
* item ^short = "Requested pharmaceuticals - NPPA and panel approval Applications only"
* item obeys sa-claim-1
* item.careTeamSequence 0..0
* item.diagnosisSequence 0..0
* item.procedureSequence 0..0
* item.informationSequence 0..0
* item.revenue 0..0
* item.category 0..0
* item.modifier 0..0
* item.programCode 0..0
* item.serviced[x] 0..0
* item.location[x] 0..0
* item.unitPrice 0..0
* item.factor 0..0
* item.net 0..0
* item.udi 0..0
* item.bodySite 0..0
* item.subSite 0..0
* item.encounter 0..0
* item.detail 0..0
* item.productOrService MS
* item.productOrService.coding 1..* MS
* item.productOrService.coding ^slicing.discriminator.type = #value
* item.productOrService.coding ^slicing.discriminator.path = "system"
* item.productOrService.coding ^slicing.rules = #open
* item.productOrService.coding contains
    ctpp 0..1 MS and
    pharmacode 0..1 MS
* item.productOrService.coding[ctpp] ^short = "NZMT CTPP ID (preferred)"
* item.productOrService.coding[ctpp].system = $NZMT (exactly)
* item.productOrService.coding[ctpp].code 1..1
* item.productOrService.coding[ctpp].display MS
* item.productOrService.coding[pharmacode] ^short = "Pharmac Pharmacode"
* item.productOrService.coding[pharmacode].system = $SA-Pharmacode (exactly)
* item.productOrService.coding[pharmacode].code 1..1
* item.productOrService.coding[pharmacode].display MS
* total 0..0

Profile: SAApplicationClaimResponse
Parent: ClaimResponse
Id: sa-application-claimresponse
Title: "SA Application ClaimResponse"
Description: """
The status and outcome of a Special Authority Application. Returned in the SA Response Bundle from `Claim/$submit`, and
from Application Enquiry (`GET [base]/ClaimResponse?request.identifier=...`).

* Application status, outcome, outcome code and outcome reason are carried in the `application-status` extension. The shape is
  identical at submission and enquiry.
* `existing-approval` is returned **only** on the synchronous `$submit` response, where the Application was declined
  because a conflicting Approval exists.
* The Approval Number, once approved, is carried on `identifier` and `preAuthRef`.
* `error` carries the single machine readable outcome code. The same code and reason are also rendered in the
  `OperationOutcome` in the response Bundle.
* `status`, `type`, `use`, `insurer` and `outcome` are mandatory in FHIR R4. `outcome` is set per the mapping on the
  Validation and Outcomes page; it does not replace `application-status`.
"""
* ^status = #draft
* obeys sa-cr-1 and sa-cr-2 and sa-cr-3
* extension contains
    ApplicationStatus named applicationStatus 1..1 MS and
    ExistingApproval named existingApproval 0..1 MS
* identifier 0..1 MS
* identifier ^short = "Approval Number - present only once approved"
* identifier.system 1..1
* identifier.system = $SA-ApprovalNumber (exactly)
* identifier.value 1..1
* status = #active
* type = $claim-type#pharmacy
* subType 0..0
* use = #preauthorization
* patient MS
* patient only Reference(SAPatient)
* created MS
* insurer MS
* insurer.reference 0..0
* insurer.display 1..1
* requestor MS
* requestor only Reference(SAPractitioner)
* request 1..1 MS
* request only Reference(SAClaim)
* request ^short = "The Application (Claim). Carries the Application Number in request.identifier"
* request.identifier 1..1 MS
* request.identifier.system = $SA-ApplicationNumber (exactly)
* request.identifier.value 1..1
* outcome MS
* disposition MS
* disposition ^short = "Human readable outcome reason (mirrors application-status.outcomeReason)"
* preAuthRef MS
* preAuthRef ^short = "Approval Number - same value as identifier"
* preAuthPeriod MS
* preAuthPeriod ^short = "Approval effective and expiry dates"
* insert SANoFinancialClaimResponse
* error 0..1 MS
* error ^short = "The single outcome code (fail fast)"
* error.itemSequence 0..0
* error.detailSequence 0..0
* error.subDetailSequence 0..0
* error.code from SAOutcomeCodeVS (extensible)

Profile: SAApprovalClaimResponse
Parent: ClaimResponse
Id: sa-approval-claimresponse
Title: "SA Approval ClaimResponse"
Description: """
A Special Authority Approval, returned by Approval Enquiry (`GET [base]/ClaimResponse?...`). Constructed fresh from the
current Approval record on every enquiry; it is **not** a replay of the ClaimResponse returned at submission.

* `identifier` and `preAuthRef` carry the Approval Number; `preAuthPeriod` the effective and expiry dates. A lifetime
  Approval carries a far-future expiry date - there is no sentinel value.
* `requestor` is the prescribing Practitioner who authored the originating Application. The provider (pharmacy)
  is carried in the `approval-detail` extension.
* Approval type, status, form number and form version are carried in the `approval-detail` extension.
* Coverage is carried in `approval-coverage` only for NPPA and panel Approvals.
* Approval versions are **not** FHIR resource versions. `meta.versionId` is not used and `vread`/`_history` are not
  supported. When `approval-version-state=ALL` returns several versions, each is a distinct ClaimResponse and recency is
  carried on `meta.lastUpdated` (when the Approval version was created).
* `status` is always `active` and `outcome` always `complete`. Both are mandatory in FHIR R4 and carry no Special Authority meaning;
  the Approval status is `approval-detail.status`.
"""
* ^status = #draft
* obeys sa-cr-1
* meta 1..1
* meta.versionId 0..0
* meta.lastUpdated 1..1 MS
* meta.lastUpdated ^short = "When the Approval version was created - orders versions by recency"
* extension contains
    ApprovalDetail named approvalDetail 1..1 MS and
    ApprovalCoverage named approvalCoverage 0..1 MS
* identifier 1..1 MS
* identifier.system 1..1
* identifier.system = $SA-ApprovalNumber (exactly)
* identifier.value 1..1
* status = #active
* status ^comment = "Always active. The Approval status is carried in approval-detail.status."
* type = $claim-type#pharmacy
* subType 0..0
* use = #preauthorization
* patient MS
* patient only Reference(SAPatient)
* created MS
* insurer MS
* insurer.reference 0..0
* insurer.display 1..1
* requestor 1..1 MS
* requestor only Reference(SAPractitioner)
* requestor ^short = "Prescribing Practitioner who authored the originating Application"
* request MS
* request only Reference(SAClaim)
* request ^short = "The originating Application, where still retrievable"
* outcome = #complete
* outcome ^comment = "Always complete. Carries no Special Authority meaning."
* preAuthRef 1..1 MS
* preAuthPeriod 1..1 MS
* preAuthPeriod.start 1..1 MS
* preAuthPeriod.end 1..1 MS
* insert SANoFinancialClaimResponse
* error 0..0
