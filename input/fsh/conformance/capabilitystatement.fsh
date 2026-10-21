RuleSet: SearchParam(name, definition, type, doc)
* searchParam[+].name = "{name}"
* searchParam[=].definition = "{definition}"
* searchParam[=].type = #{type}
* searchParam[=].documentation = "{doc}"

// Conforms to the Health NZ Digital Tooling profile so the fhir-openapi-converter can generate the OpenAPI spec.
// https://fhir-ig.digital.health.nz/hnz-digital-tooling/StructureDefinition/hnz-capability-statement
Instance: SpecialAuthorityFHIRAPICapabilityStatement
InstanceOf: HnzToolingCapabilityStatement
Usage: #definition
Title: "Special Authority FHIR API"

// * url = "https://fhir-ig.digital.health.nz/special-authority/CapabilityStatement/SpecialAuthorityCapabilityStatement"
* version = "0.1.2"
* name = "SpecialAuthorityFHIRAPICapabilityStatement"
* title = "Special Authority FHIR Server Capability Statement"
* description = "Health NZ | Te Whatu Ora Special Authority FHIR API"
* status = #draft
* experimental = false
* kind = #instance
* date = "2026-10-15"
* publisher = "Health New Zealand | Te Whatu Ora"
* contact[+].name = "Health New Zealand | Te Whatu Ora"
* contact[=].telecom[+].system = #url
* contact[=].telecom[=].value = "https://www.tewhatuora.govt.nz"
* contact[=].telecom[+].system = #email
* contact[=].telecom[=].value = "integration@tewhatuora.govt.nz"

* implementation.description = "Production Special Authority FHIR API"
* implementation.url = "https://api.sa.digital.health.nz/s2s/fhir/R4"
* fhirVersion = #4.0.1
* format = #application/fhir+json

* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].url = "globalHeaders"
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[+].url = Canonical(HnzCustomHeadersExtension)
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[key].valueString = "Request-Context"
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[value].valueUri = "https://raw.githubusercontent.com/tewhatuora/schemas/main/openapi-definitions/Request-Context.json"
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[documentation].valueString = "Signed Request-Context header asserting the authenticated user, organisation and facility. Validated on every request."
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[required].valueBoolean = true
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[+].url = Canonical(HnzCustomHeadersExtension)
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[key].valueString = "X-Correlation-Id"
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[value].valueUri = "https://raw.githubusercontent.com/tewhatuora/schemas/main/shared-care/Correlation-Id.json"
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[documentation].valueString = "Optional client-supplied correlation id, returned in the response and recorded in audit events."
* extension[HnzApiSpecBuilderExtension].extension[globalHeaders].extension[=].extension[required].valueBoolean = false
* extension[HnzApiSpecBuilderExtension].extension[licenseURL].valueUri = "https://www.tewhatuora.govt.nz/assets/Our-health-system/Digital-health/Digital-Service-Hub/API-Access-and-Use-Agreement.docx"
* extension[HnzApiSpecBuilderExtension].extension[licenseName].valueString = "Health New Zealand Digital Services Hub API Access and Use Agreement"
* extension[HnzApiSpecBuilderExtension].extension[externalDocs].valueUri = "https://fhir-ig.digital.health.nz/special-authority"

* rest[0].mode = #server
* rest[0].documentation = "All token searches on identifiers SHALL be system-qualified (system|value). All requests require a validated access token and a validated signed Request-Context header."
* rest[0].security.cors = false
* rest[0].security.service = http://terminology.hl7.org/CodeSystem/restful-security-service#SMART-on-FHIR
* rest[0].security.description = "OAuth 2.0 client credentials flow and signed Request-Context header, per the Health NZ Digital Services Hub onboarding process. The authenticated requester identity is never taken from the FHIR payload."
* rest[0].security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/oauth-uris"
* rest[0].security.extension[=].extension[+].url = "token"
* rest[0].security.extension[=].extension[=].valueUri = "https://auth.services.health.nz/realms/hnz-integration/protocol/openid-connect/token"
* rest[0].security.extension[=].extension[+].url = "authorize"
* rest[0].security.extension[=].extension[=].valueUri = "https://auth.services.health.nz/realms/hnz-integration/protocol/openid-connect/auth"
* rest[0].security.extension[+].url = "http://fhir-registry.smarthealthit.org/StructureDefinition/capabilities"
* rest[0].security.extension[=].valueCode = #client-confidential-symmetric

// --- Claim ---
* rest[0].resource[0].type = #Claim
* rest[0].resource[0].profile = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-claim"
* rest[0].resource[0].supportedProfile[0] = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-claim"
* rest[0].resource[0].documentation = "Special Authority Applications. Submitted with $submit; enquired with search."
* rest[0].resource[0].interaction[0].code = #search-type
* rest[0].resource[0].interaction[0].documentation = "Search Applications, or retrieve a submitted Application by Application Number with _include. Search results are summary representations: referenced resources are only resolved via _include."
* rest[0].resource[0].searchInclude[0] = "Claim:patient"
* rest[0].resource[0].searchInclude[1] = "Claim:requestor"
* rest[0].resource[0].searchInclude[2] = "Claim:supportinginfo"
* rest[0].resource[0] insert SearchParam(identifier, http://hl7.org/fhir/SearchParameter/Claim-identifier, token, Application Number. SHALL be system-qualified.)
* rest[0].resource[0] insert SearchParam(patient, http://hl7.org/fhir/SearchParameter/Claim-patient, reference, Supports the chained form patient.identifier=nhi-system|NHI only.)
* rest[0].resource[0] insert SearchParam(requestor, https://fhir-ig.digital.health.nz/special-authority/SearchParameter/claim-requestor, reference, Supports requestor:Practitioner.identifier with the HPI CPN system or an NZ registration authority system.)
* rest[0].resource[0] insert SearchParam(application-status, https://fhir-ig.digital.health.nz/special-authority/SearchParameter/application-status, token, SUBMITTED | PENDING_REVIEW | CANCELLED | DONE)
* rest[0].resource[0] insert SearchParam(created, http://hl7.org/fhir/SearchParameter/Claim-created, date, Submission date range using ge and le.)
* rest[0].resource[0].operation[0].name = "submit"
* rest[0].resource[0].operation[0].definition = "https://fhir-ig.digital.health.nz/special-authority/OperationDefinition/sa-claim-submit"

// --- ClaimResponse ---
* rest[0].resource[1].type = #ClaimResponse
* rest[0].resource[1].supportedProfile[0] = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-application-claimresponse"
* rest[0].resource[1].supportedProfile[1] = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-approval-claimresponse"
* rest[0].resource[1].documentation = "Application outcomes (searched by request.identifier) and Approvals (searched by Approval Number, NHI or practitioner). An Approval search SHALL supply at least one of identifier, patient.identifier or requestor:Practitioner.identifier. approval-valid-on and approval-expiring are mutually exclusive."
* rest[0].resource[1].interaction[0].code = #search-type
* rest[0].resource[1].searchInclude[0] = "ClaimResponse:request"
* rest[0].resource[1] insert SearchParam(identifier, http://hl7.org/fhir/SearchParameter/ClaimResponse-identifier, token, Approval Number. SHALL be system-qualified.)
* rest[0].resource[1] insert SearchParam(request, http://hl7.org/fhir/SearchParameter/ClaimResponse-request, reference, Supports the chained form request.identifier=application-number-system|applicationNumber.)
* rest[0].resource[1] insert SearchParam(patient, http://hl7.org/fhir/SearchParameter/ClaimResponse-patient, reference, Supports the chained form patient.identifier=nhi-system|NHI only.)
* rest[0].resource[1] insert SearchParam(requestor, http://hl7.org/fhir/SearchParameter/ClaimResponse-requestor, reference, Supports requestor:Practitioner.identifier with the HPI CPN system or an NZ registration authority system.)
* rest[0].resource[1] insert SearchParam(approval-status, https://fhir-ig.digital.health.nz/special-authority/SearchParameter/approval-status, token, ACTIVE | CANCELLED | REVOKED)
* rest[0].resource[1] insert SearchParam(approval-valid-on, https://fhir-ig.digital.health.nz/special-authority/SearchParameter/approval-valid-on, date, Approvals valid on the supplied date.)
* rest[0].resource[1] insert SearchParam(approval-expiring, https://fhir-ig.digital.health.nz/special-authority/SearchParameter/approval-expiring, date, Approvals expiring within a date range.)
* rest[0].resource[1] insert SearchParam(approval-provider-id, https://fhir-ig.digital.health.nz/special-authority/SearchParameter/approval-provider-id, token, Provider - pharmacy - on the Approval. SHALL be system-qualified.)
* rest[0].resource[1] insert SearchParam(approval-version-state, https://fhir-ig.digital.health.nz/special-authority/SearchParameter/approval-version-state, token, LATEST - default - or PREVIOUS or ALL.)
* rest[0].resource[1].searchParam[+].name = "_elements"
* rest[0].resource[1].searchParam[=].type = #special
* rest[0].resource[1].searchParam[=].documentation = "Supported for Retrieve Application Outcome: _elements=extension,preAuthRef."


// --- Resources returned only via _include or inside Bundles ---
// * rest[0].resource[2].type = #QuestionnaireResponse
// * rest[0].resource[2].profile = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-questionnaire-response"
// * rest[0].resource[2].documentation = "Returned only inside a submission Bundle or via _include=Claim:supportinginfo. No direct interactions."
// * rest[0].resource[3].type = #Patient
// * rest[0].resource[3].profile = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-patient"
// * rest[0].resource[3].documentation = "Returned only inside Bundles or via _include. No direct interactions."
// * rest[0].resource[4].type = #Practitioner
// * rest[0].resource[4].profile = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-practitioner"
// * rest[0].resource[4].documentation = "Returned only inside Bundles or via _include. No direct interactions."
// * rest[0].resource[5].type = #Organization
// * rest[0].resource[5].profile = "https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-organization"
// * rest[0].resource[5].documentation = "Returned only inside Bundles. No direct interactions."
