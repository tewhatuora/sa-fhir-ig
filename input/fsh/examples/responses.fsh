// ---------------------------------------------------------------------------
// Example responses. Application and Approval Numbers are fictional.
// ---------------------------------------------------------------------------

// --- $submit: approved -------------------------------------------------------

Instance: sa-example-cr-approved
InstanceOf: SAApplicationClaimResponse
Usage: #example
Title: "Example Application ClaimResponse - Approved"
Description: "Synchronous $submit response for an approved Application."
* extension[applicationStatus].extension[status].valueCode = #DONE
* extension[applicationStatus].extension[outcome].valueCode = #APPROVED
* identifier.system = $SA-ApprovalNumber
* identifier.value = "26SA0004567"
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2026-10-14T10:35:07+13:00"
* insurer.display = "Health New Zealand | Te Whatu Ora"
* requestor = Reference(sa-example-applicant)
* request.identifier.system = $SA-ApplicationNumber
* request.identifier.value = "000123456"
* outcome = #complete
* disposition = "Application approved"
* preAuthRef = "26SA0004567"
* preAuthPeriod.start = "2026-10-14"
* preAuthPeriod.end = "2027-10-14"

Instance: sa-example-response-bundle-approved
InstanceOf: SAResponseBundle
Usage: #example
Title: "Example Response Bundle - Approved"
Description: "Response to POST [base]/Claim/$submit for an approved Application."
* type = #collection
* timestamp = "2026-10-14T10:35:07+13:00"
* entry[0].fullUrl = "https://api.example.health.nz/fhir/ClaimResponse/sa-example-cr-approved"
* entry[0].resource = sa-example-cr-approved
* entry[1].fullUrl = "https://api.example.health.nz/fhir/Patient/sa-example-patient"
* entry[1].resource = sa-example-patient
* entry[2].fullUrl = "https://api.example.health.nz/fhir/Practitioner/sa-example-applicant"
* entry[2].resource = sa-example-applicant

// --- $submit: declined, conflicting Approval ---------------------------------

Instance: sa-example-cr-declined
InstanceOf: SAApplicationClaimResponse
Usage: #example
Title: "Example Application ClaimResponse - Declined (existing Approval)"
Description: "Synchronous $submit response where the Application was declined because a conflicting Approval exists. The outcome code shown is illustrative; codes come from the Error Code Catalogue."
* extension[applicationStatus].extension[status].valueCode = #DONE
* extension[applicationStatus].extension[outcome].valueCode = #DECLINED
* extension[applicationStatus].extension[outcomeCode].valueCoding = SAOutcomeCodeCS#URNSA011
* extension[applicationStatus].extension[outcomeReason].valueString = "An approval already exists for this patient and form."
* extension[existingApproval].extension[approvalType].valueCode = #CHEM
* extension[existingApproval].extension[approvalNumber].valueIdentifier.system = $SA-ApprovalNumber
* extension[existingApproval].extension[approvalNumber].valueIdentifier.value = "25SA0001234"
* extension[existingApproval].extension[effectiveDate].valueDate = "2026-02-01"
* extension[existingApproval].extension[expiryDate].valueDate = "2027-02-01"
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2026-10-14T10:35:07+13:00"
* insurer.display = "Health New Zealand | Te Whatu Ora"
* requestor = Reference(sa-example-applicant)
* request.identifier.system = $SA-ApplicationNumber
* request.identifier.value = "000123457"
* outcome = #complete
* disposition = "An approval already exists for this patient and form."
* error[0].code = SAOutcomeCodeCS#URNSA011

Instance: sa-example-outcome-declined
InstanceOf: SAOutcomeOperationOutcome
Usage: #example
Title: "Example Outcome OperationOutcome - Declined"
Description: "The single outcome for a declined Application, rendered as an OperationOutcome."
* issue[0].severity = #error
* issue[0].code = #business-rule
* issue[0].details.coding[0] = SAOutcomeCodeCS#URNSA011
* issue[0].diagnostics = "An approval already exists for this patient and form."

Instance: sa-example-response-bundle-declined
InstanceOf: SAResponseBundle
Usage: #example
Title: "Example Response Bundle - Declined"
Description: "Response to POST [base]/Claim/$submit for a declined Application."
* type = #collection
* timestamp = "2026-10-14T10:35:07+13:00"
* entry[0].fullUrl = "https://api.example.health.nz/fhir/ClaimResponse/sa-example-cr-declined"
* entry[0].resource = sa-example-cr-declined
* entry[1].fullUrl = "urn:uuid:7d9c6b1e-3c55-4a7a-9f4e-2b8d3a1c9e01"
* entry[1].resource = sa-example-outcome-declined
* entry[2].fullUrl = "https://api.example.health.nz/fhir/Patient/sa-example-patient"
* entry[2].resource = sa-example-patient
* entry[3].fullUrl = "https://api.example.health.nz/fhir/Practitioner/sa-example-applicant"
* entry[3].resource = sa-example-applicant

// --- Enquiry: pending review --------------------------------------------------

Instance: sa-example-cr-pending
InstanceOf: SAApplicationClaimResponse
Usage: #example
Title: "Example Application ClaimResponse - Pending review"
Description: "Application outcome returned by GET [base]/ClaimResponse?request.identifier=... while the Application awaits manual review."
* extension[applicationStatus].extension[status].valueCode = #PENDING_REVIEW
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2026-10-14T11:03:15+13:00"
* insurer.display = "Health New Zealand | Te Whatu Ora"
* requestor = Reference(sa-example-applicant)
* request.identifier.system = $SA-ApplicationNumber
* request.identifier.value = "000123458"
* outcome = #queued

// --- Approval enquiry ---------------------------------------------------------

Instance: sa-example-approval-chem
InstanceOf: SAApprovalClaimResponse
Usage: #example
Title: "Example Approval - CHEM"
Description: "A standard CHEM Approval. Coverage is not returned; it is derivable from the form number and version."
* meta.lastUpdated = "2026-10-14T10:35:07+13:00"
* extension[approvalDetail].extension[approvalType].valueCode = #CHEM
* extension[approvalDetail].extension[status].valueCode = #ACTIVE
* extension[approvalDetail].extension[formNumber].valueString = "SA9999"
* extension[approvalDetail].extension[formVersion].valueString = "a3f2b8c91d4e7062"
* identifier.system = $SA-ApprovalNumber
* identifier.value = "26SA0004567"
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2026-10-14T10:35:07+13:00"
* insurer.display = "Health New Zealand | Te Whatu Ora"
* requestor = Reference(sa-example-applicant)
* request.identifier.system = $SA-ApplicationNumber
* request.identifier.value = "000123456"
* outcome = #complete
* preAuthRef = "26SA0004567"
* preAuthPeriod.start = "2026-10-14"
* preAuthPeriod.end = "2027-10-14"

Instance: sa-example-approval-nppa
InstanceOf: SAApprovalClaimResponse
Usage: #example
Title: "Example Approval - NPPA with explicit coverage and provider"
Description: "An exceptional circumstances (NPPA) Approval. There is no schedule form, so coverage is carried explicitly. The Approval is linked to a dispensing pharmacy."
* meta.lastUpdated = "2026-09-01T09:00:00+12:00"
* extension[approvalDetail].extension[approvalType].valueCode = #EXCP
* extension[approvalDetail].extension[status].valueCode = #ACTIVE
* extension[approvalDetail].extension[providerIdType].valueCode = #CLAIMANT_NUMBER
* extension[approvalDetail].extension[providerId].valueIdentifier.system = $SA-ClaimantNumber
* extension[approvalDetail].extension[providerId].valueIdentifier.value = "1234"
* extension[approvalCoverage].extension[type].valueCode = #EXPLICIT_PHARMACEUTICALS
* extension[approvalCoverage].extension[pharmaceutical][0].extension[ctppId].valueString = "10000000000000"
* extension[approvalCoverage].extension[pharmaceutical][0].extension[pharmacode].valueString = "2000001"
* extension[approvalCoverage].extension[pharmaceutical][0].extension[description].valueString = "Example medicine 10 mg tablet, 30"
* identifier.system = $SA-ApprovalNumber
* identifier.value = "26NP0000088"
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2026-09-01T09:00:00+12:00"
* insurer.display = "Health New Zealand | Te Whatu Ora"
* requestor = Reference(sa-example-applicant)
* outcome = #complete
* preAuthRef = "26NP0000088"
* preAuthPeriod.start = "2026-09-01"
* preAuthPeriod.end = "2027-03-01"

Instance: sa-example-approval-chem-v1
InstanceOf: SAApprovalClaimResponse
Usage: #inline
Title: "Example Approval - superseded version"
Description: "An earlier, superseded version of a CHEM Approval, returned only with approval-version-state=ALL or PREVIOUS."
* meta.lastUpdated = "2025-02-01T08:15:00+13:00"
* extension[approvalDetail].extension[approvalType].valueCode = #CHEM
* extension[approvalDetail].extension[status].valueCode = #ACTIVE
* extension[approvalDetail].extension[formNumber].valueString = "SA9999"
* identifier.system = $SA-ApprovalNumber
* identifier.value = "25SA0001234"
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2025-02-01T08:15:00+13:00"
* insurer.display = "Health New Zealand | Te Whatu Ora"
* requestor = Reference(sa-example-applicant)
* outcome = #complete
* preAuthRef = "25SA0001234"
* preAuthPeriod.start = "2025-02-01"
* preAuthPeriod.end = "2026-02-01"

Instance: sa-example-approval-chem-v2
InstanceOf: SAApprovalClaimResponse
Usage: #inline
Title: "Example Approval - current version (revoked)"
Description: "The current version of the same Approval after revocation. Same Approval Number; distinct ClaimResponse; later meta.lastUpdated."
* meta.lastUpdated = "2025-08-20T14:40:00+12:00"
* extension[approvalDetail].extension[approvalType].valueCode = #CHEM
* extension[approvalDetail].extension[status].valueCode = #REVOKED
* extension[approvalDetail].extension[formNumber].valueString = "SA9999"
* identifier.system = $SA-ApprovalNumber
* identifier.value = "25SA0001234"
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2025-08-20T14:40:00+12:00"
* insurer.display = "Health New Zealand | Te Whatu Ora"
* requestor = Reference(sa-example-applicant)
* outcome = #complete
* preAuthRef = "25SA0001234"
* preAuthPeriod.start = "2025-02-01"
* preAuthPeriod.end = "2026-02-01"

Instance: sa-example-approval-search-all-versions
InstanceOf: Bundle
Usage: #example
Title: "Example Approval search - all versions"
Description: "Result of GET [base]/ClaimResponse?patient.identifier=https://standards.digital.health.nz/ns/nhi-id|ZZZ0016&approval-version-state=ALL, showing two versions of one Approval as distinct ClaimResponses ordered by meta.lastUpdated (most recent first)."
* type = #searchset
* total = 2
* link[0].relation = "self"
* link[0].url = "https://api.example.health.nz/fhir/ClaimResponse?patient.identifier=https://standards.digital.health.nz/ns/nhi-id|ZZZ0016&approval-version-state=ALL"
* entry[0].fullUrl = "https://api.example.health.nz/fhir/ClaimResponse/sa-example-approval-chem-v2"
* entry[0].resource = sa-example-approval-chem-v2
* entry[0].search.mode = #match
* entry[1].fullUrl = "https://api.example.health.nz/fhir/ClaimResponse/sa-example-approval-chem-v1"
* entry[1].resource = sa-example-approval-chem-v1
* entry[1].search.mode = #match
* entry[2].fullUrl = "https://api.example.health.nz/fhir/Patient/sa-example-patient"
* entry[2].resource = sa-example-patient
* entry[2].search.mode = #include
* entry[3].fullUrl = "https://api.example.health.nz/fhir/Practitioner/sa-example-applicant"
* entry[3].resource = sa-example-applicant
* entry[3].search.mode = #include
