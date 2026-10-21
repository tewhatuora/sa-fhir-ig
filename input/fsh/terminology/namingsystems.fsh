// ---------------------------------------------------------------------------
// Naming systems
// ---------------------------------------------------------------------------

RuleSet: SANamingSystem(name, kind, uri)
* name = "{name}"
* status = #draft
* kind = #{kind}
* date = "2026-10-15"
* publisher = "Health New Zealand | Te Whatu Ora"
* responsible = "Health New Zealand | Te Whatu Ora"
* jurisdiction = urn:iso:std:iso:3166#NZ "New Zealand"
* uniqueId[0].type = #uri
* uniqueId[0].value = "{uri}"
* uniqueId[0].preferred = true

Instance: sa-application-number
InstanceOf: NamingSystem
Usage: #definition
Title: "SA Application Number"
* insert SANamingSystem(SAApplicationNumber, identifier, https://fhir-ig.digital.health.nz/special-authority/ns/application-number)
* description = "Special Authority Application Number, allocated on submission. The only identifier carried on Claim.identifier."

Instance: sa-approval-number
InstanceOf: NamingSystem
Usage: #definition
Title: "SA Approval Number"
* insert SANamingSystem(SAApprovalNumber, identifier, https://fhir-ig.digital.health.nz/special-authority/ns/approval-number)
* description = "Special Authority Approval Number. Carried on ClaimResponse.identifier and ClaimResponse.preAuthRef."

Instance: sa-legacy-practice-id
InstanceOf: NamingSystem
Usage: #definition
Title: "SA Practice Id"
* insert SANamingSystem(SALegacyPracticeId, identifier, https://fhir-ig.digital.health.nz/special-authority/ns/legacy-practice-id)
* description = "Special Authority Practice Id, used on the submitting Organization."

Instance: sa-pharmacy-claimant-number
InstanceOf: NamingSystem
Usage: #definition
Title: "SA Pharmacy Claimant Number"
* insert SANamingSystem(SAPharmacyClaimantNumber, identifier, https://fhir-ig.digital.health.nz/special-authority/ns/pharmacy-claimant-number)
* description = "Pharmacy claimant number. Identifies the provider (pharmacy) on an Approval and is the system used by the approval-provider-id search parameter."

Instance: sa-pharmacode
InstanceOf: NamingSystem
Usage: #definition
Title: "SA Pharmacode"
* insert SANamingSystem(SAPharmacode, codesystem, https://fhir-ig.digital.health.nz/special-authority/ns/pharmacode)
* description = "Pharmac Pharmacode."
