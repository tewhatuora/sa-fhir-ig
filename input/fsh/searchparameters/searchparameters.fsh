// ---------------------------------------------------------------------------
// Custom SearchParameters
// ---------------------------------------------------------------------------

RuleSet: SASearchParameter(id, code)
* url = "https://fhir-ig.digital.health.nz/special-authority/SearchParameter/{id}"
* version = "0.1.2"
* status = #draft
* experimental = false
* date = "2026-10-15"
* publisher = "Health New Zealand | Te Whatu Ora"
* jurisdiction = urn:iso:std:iso:3166#NZ "New Zealand"
* code = #{code}

// --- Claim -----------------------------------------------------------------

Instance: claim-requestor
InstanceOf: SearchParameter
Usage: #definition
Title: "Claim requestor"
* insert SASearchParameter(claim-requestor, requestor)
* name = "ClaimRequestor"
* description = "The Applicant of the Special Authority Application. FHIR R4 Claim has no requestor element, so the Applicant is carried in Claim.provider and this parameter evaluates Claim.provider. It supports requestor:Practitioner.identifier and _include=Claim:requestor. The chained identifier accepts the HPI CPN system or an NZ responsible-authority registration system. The core provider parameter is equivalent."
* base[0] = #Claim
* type = #reference
* expression = "Claim.provider"
* xpathUsage = #normal
* target[0] = #Practitioner
* chain[0] = "identifier"

Instance: claim-supportinginfo
InstanceOf: SearchParameter
Usage: #definition
Title: "Claim supportinginfo"
* insert SASearchParameter(claim-supportinginfo, supportinginfo)
* name = "ClaimSupportingInfo"
* description = "Resources referenced from Claim.supportingInfo, i.e. the QuestionnaireResponse. FHIR R4 defines no such search parameter on Claim; this parameter supports _include=Claim:supportinginfo."
* base[0] = #Claim
* type = #reference
* expression = "Claim.supportingInfo.value.ofType(Reference)"
* xpathUsage = #normal
* target[0] = #QuestionnaireResponse

Instance: application-status
InstanceOf: SearchParameter
Usage: #definition
Title: "Application status"
* insert SASearchParameter(application-status, application-status)
* name = "ApplicationStatus"
* description = "Application status: SUBMITTED, PENDING_REVIEW, CANCELLED or DONE. Claim.status cannot express these values."
* base[0] = #Claim
* base[1] = #ClaimResponse
* type = #token
* expression = "Claim.extension('https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/application-status').extension('status').value | ClaimResponse.extension('https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/application-status').extension('status').value"
* xpathUsage = #normal

// --- ClaimResponse (Approval) --------------------------------------------------

Instance: approval-status
InstanceOf: SearchParameter
Usage: #definition
Title: "Approval status"
* insert SASearchParameter(approval-status, approval-status)
* name = "ApprovalStatus"
* description = "Approval status: ACTIVE, CANCELLED or REVOKED, as carried in the approval-detail extension. Narrows a result set."
* base[0] = #ClaimResponse
* type = #token
* expression = "ClaimResponse.extension('https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/approval-detail').extension('status').value"
* xpathUsage = #normal

Instance: approval-valid-on
InstanceOf: SearchParameter
Usage: #definition
Title: "Approval valid on"
* insert SASearchParameter(approval-valid-on, approval-valid-on)
* name = "ApprovalValidOn"
* description = "Matches Approvals whose preAuthPeriod contains the supplied date, i.e. preAuthPeriod.start <= date <= preAuthPeriod.end. This is containment of a single date, which differs from standard FHIR date search semantics on a Period, hence a custom parameter. Only the eq comparator is supported. Mutually exclusive with approval-expiring."
* base[0] = #ClaimResponse
* type = #date
* expression = "ClaimResponse.preAuthPeriod"
* xpathUsage = #normal
* comparator[0] = #eq

Instance: approval-expiring
InstanceOf: SearchParameter
Usage: #definition
Title: "Approval expiring"
* insert SASearchParameter(approval-expiring, approval-expiring)
* name = "ApprovalExpiring"
* description = "Range query on the Approval expiry date (preAuthPeriod.end), e.g. approval-expiring=ge2026-10-01&approval-expiring=le2026-12-31. Mutually exclusive with approval-valid-on."
* base[0] = #ClaimResponse
* type = #date
* expression = "ClaimResponse.preAuthPeriod.end"
* xpathUsage = #normal
* comparator[0] = #eq
* comparator[1] = #ge
* comparator[2] = #le
* comparator[3] = #gt
* comparator[4] = #lt

Instance: approval-provider-id
InstanceOf: SearchParameter
Usage: #definition
Title: "Approval provider id"
* insert SASearchParameter(approval-provider-id, approval-provider-id)
* name = "ApprovalProviderId"
* description = "The provider (pharmacy) on the Approval, as carried in approval-detail.providerId. System-qualified against the provider id type namespace, e.g. approval-provider-id=https://fhir-ig.digital.health.nz/special-authority/ns/pharmacy-claimant-number|1234."
* base[0] = #ClaimResponse
* type = #token
* expression = "ClaimResponse.extension('https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/approval-detail').extension('providerId').value"
* xpathUsage = #normal

Instance: approval-version-state
InstanceOf: SearchParameter
Usage: #definition
Title: "Approval version state"
* insert SASearchParameter(approval-version-state, approval-version-state)
* name = "ApprovalVersionState"
* description = "Controls which Approval versions are returned: LATEST (default), PREVIOUS or ALL. This is a result-control parameter with no FHIRPath expression - Approval versions are not FHIR resource versions. Each version is returned as a distinct ClaimResponse ordered by meta.lastUpdated. Values are from the SA Approval Version State value set."
* base[0] = #ClaimResponse
* type = #token
