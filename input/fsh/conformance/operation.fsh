Instance: sa-claim-submit
InstanceOf: OperationDefinition
Usage: #definition
Title: "Submit Special Authority Application"
Description: "Submits a Special Authority Application. The request body is an SA Submission Bundle; the response is an SA Response Bundle."
* url = "https://fhir-ig.digital.health.nz/special-authority/OperationDefinition/sa-claim-submit"
* version = "0.1.1"
* name = "SASubmitApplication"
* title = "Submit Special Authority Application"
* status = #draft
* kind = #operation
* experimental = false
* date = "2026-10-15"
* publisher = "Health New Zealand | Te Whatu Ora"
* description = "Submits a Special Authority Application as a single, atomically accepted or rejected SA Submission Bundle. The Bundle is POSTed directly as the request body (Content-Type application/fhir+json). The response is an SA Response Bundle containing an SA Application ClaimResponse."
* affectsState = true
* code = #submit
* base = "http://hl7.org/fhir/OperationDefinition/Claim-submit"
* resource[0] = #Claim
* system = false
* type = true
* instance = false
* parameter[0].name = #resource
* parameter[0].use = #in
* parameter[0].min = 1
* parameter[0].max = "1"
* parameter[0].documentation = "An SA Submission Bundle (https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-submission-bundle)."
* parameter[0].type = #Bundle
* parameter[1].name = #return
* parameter[1].use = #out
* parameter[1].min = 1
* parameter[1].max = "1"
* parameter[1].documentation = "An SA Response Bundle (https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/sa-response-bundle)."
* parameter[1].type = #Bundle
