// ---------------------------------------------------------------------------
// Example form and submissions
// ---------------------------------------------------------------------------

Instance: SA9999
InstanceOf: SAQuestionnaire
Usage: #example
Title: "Example SA Form SA9999 (illustrative)"
Description: "An illustrative, fictional Special Authority form. In Phase 1 no Questionnaire is published at the canonical URL of a real form; this example only demonstrates the url, version and linkId conventions."
* url = "https://fhir-ig.digital.health.nz/special-authority/Questionnaire/SA9999"
* version = "a3f2b8c91d4e7062"
* name = "SA9999"
* title = "Example Special Authority form SA9999 - Initial application"
* status = #draft
* item[0].linkId = "initial"
* item[0].type = #group
* item[0].text = "Initial application - applications from any relevant practitioner. Approvals valid for 1 year."
* item[0].item[0].linkId = "00001"
* item[0].item[0].type = #boolean
* item[0].item[0].text = "Patient has a confirmed diagnosis of the relevant condition"
* item[0].item[1].linkId = "00002"
* item[0].item[1].type = #boolean
* item[0].item[1].text = "Patient has had an inadequate response to at least 3 months of first-line treatment"
* item[0].item[2].linkId = "00003"
* item[0].item[2].type = #string
* item[0].item[2].text = "First-line treatment trialled"

// --- Direct FHIR submission ---------------------------------------------------

Instance: sa-example-qr
InstanceOf: SAQuestionnaireResponse
Usage: #example
Title: "Example QuestionnaireResponse (version pinned)"
Description: "Clinical answers from a FHIR-native PMS. The questionnaire canonical is version pinned, and a referrer is supplied."
* identifier.system = "https://pms.example.co.nz/sa-reference"
* identifier.value = "PMS-REF-000981"
* extension[requestForWaiver].valueBoolean = false
* extension[referringPractitioner].valueReference = Reference(sa-example-referrer)
* questionnaire = "https://fhir-ig.digital.health.nz/special-authority/Questionnaire/SA9999|a3f2b8c91d4e7062"
* status = #completed
* subject = Reference(sa-example-patient)
* authored = "2026-10-14T10:32:00+13:00"
* author = Reference(sa-example-applicant)
* item[0].linkId = "initial"
* item[0].item[0].linkId = "00001"
* item[0].item[0].text = "Patient has a confirmed diagnosis of the relevant condition"
* item[0].item[0].answer[0].valueBoolean = true
* item[0].item[1].linkId = "00002"
* item[0].item[1].text = "Patient has had an inadequate response to at least 3 months of first-line treatment"
* item[0].item[1].answer[0].valueBoolean = true
* item[0].item[2].linkId = "00003"
* item[0].item[2].text = "First-line treatment trialled"
* item[0].item[2].answer[0].valueString = "Example first-line medicine, 6 months"

Instance: sa-example-claim
InstanceOf: SAClaim
Usage: #example
Title: "Example Special Authority Application (Claim)"
Description: "A standard Special Authority Application as submitted. No identifier (allocated by the API) and no item (coverage is derived from the form)."
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2026-10-14T10:35:00+13:00"
* provider = Reference(sa-example-applicant)
* priority = $processpriority#normal
* supportingInfo[questionnaireResponse].sequence = 1
* supportingInfo[questionnaireResponse].category = SASupportingInfoCategoryCS#questionnaire-response
* supportingInfo[questionnaireResponse].valueReference = Reference(sa-example-qr)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Pharmaceutical Schedule"

Instance: sa-example-submission-bundle
InstanceOf: SASubmissionBundle
Usage: #example
Title: "Example Submission Bundle (direct FHIR)"
Description: "Request body for POST [base]/Claim/$submit from a FHIR-native PMS."
* type = #collection
* timestamp = "2026-10-14T10:35:05+13:00"
* entry[claim].fullUrl = "https://api.example.health.nz/fhir/Claim/sa-example-claim"
* entry[claim].resource = sa-example-claim
* entry[questionnaireResponse].fullUrl = "https://api.example.health.nz/fhir/QuestionnaireResponse/sa-example-qr"
* entry[questionnaireResponse].resource = sa-example-qr
* entry[patient].fullUrl = "https://api.example.health.nz/fhir/Patient/sa-example-patient"
* entry[patient].resource = sa-example-patient
* entry[practitioner][0].fullUrl = "https://api.example.health.nz/fhir/Practitioner/sa-example-applicant"
* entry[practitioner][0].resource = sa-example-applicant
* entry[practitioner][1].fullUrl = "https://api.example.health.nz/fhir/Practitioner/sa-example-referrer"
* entry[practitioner][1].resource = sa-example-referrer

// --- NPPA Application with requested pharmaceuticals ---------------------------

Instance: sa-example-claim-nppa
InstanceOf: SAClaim
Usage: #example
Title: "Example NPPA Application with requested pharmaceutical"
Description: "An NPPA Application. No form declares coverage, so the requested pharmaceutical is supplied in Claim.item."
* status = #active
* type = $claim-type#pharmacy
* use = #preauthorization
* patient = Reference(sa-example-patient)
* created = "2026-10-14T12:00:00+13:00"
* provider = Reference(sa-example-applicant)
* priority = $processpriority#normal
* supportingInfo[questionnaireResponse].sequence = 1
* supportingInfo[questionnaireResponse].category = SASupportingInfoCategoryCS#questionnaire-response
* supportingInfo[questionnaireResponse].valueReference = Reference(sa-example-qr)
* insurance[0].sequence = 1
* insurance[0].focal = true
* insurance[0].coverage.display = "Pharmaceutical Schedule"
* item[0].sequence = 1
* item[0].productOrService.coding[ctpp] = $NZMT#50002411000117100 "Myleran 2 mg tablet: film-coated, 100 tablets, bottle"
* item[0].productOrService.coding[pharmacode] = $SA-Pharmacode#2000001 "Example medicine 10 mg tablet, 30"
