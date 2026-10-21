// ---------------------------------------------------------------------------
// Questionnaire and QuestionnaireResponse
// ---------------------------------------------------------------------------

Profile: SAQuestionnaire
Parent: Questionnaire
Id: sa-questionnaire
Title: "SA Questionnaire"
Description: """
The Health NZ interpretation of a Pharmac Special Authority form at a point in time.

**Phase 1:** the `Questionnaire` canonical is an **identifier, not a resolvable address**. No `Questionnaire` resource is
published at the canonical URL in Phase 1; form definitions continue to be distributed in their
existing XML format. This profile documents the constraints the canonical and `linkId` values must satisfy.

* `url` is `https://fhir-ig.digital.health.nz/special-authority/Questionnaire/{formNumber}` and SHALL NOT contain `|` or `#`.
* `version` is the form version (a truncated hash of the form definition) and SHALL be identical, character
  for character, to the form version in `QuestionnaireResponse.questionnaire`. No case folding, trimming or normalisation.
* The `linkId` of each criterion is the `criterionIdentifier`: five characters, zero padded, numeric.
* Criteria items are not marked `required`, so a partial `QuestionnaireResponse` is valid against the profile.
"""
* ^status = #draft
* obeys sa-q-1 and sa-q-2 and sa-q-3 and sa-q-4 and sa-q-5
* url 1..1 MS
* url ^short = "Canonical of the form: .../Questionnaire/{formNumber}"
* version 1..1 MS
* version ^short = "Form version - identical to the version in QuestionnaireResponse.questionnaire"
* name MS
* title MS
* status MS
* item MS
* item.linkId MS
* item.linkId ^short = "criterionIdentifier (five character, zero padded) for boolean/string items"
* item.text MS
* item.type MS
* item.required ^short = "SHALL NOT be true for criteria items"

Profile: SAQuestionnaireResponse
Parent: QuestionnaireResponse
Id: sa-questionnaire-response
Title: "SA QuestionnaireResponse"
Description: """
The clinical criteria and answers for a Special Authority Application. Referenced from `Claim.supportingInfo`.

**Form identity.** `questionnaire` carries both parts of the form identity: `{canonical}|{formVersion}`. The API splits on
the pipe to obtain the form number (the final path segment of the canonical) and the form version. Clients SHALL
version-pin the canonical (see Form and Criterion Identity).

**Answers.** Only `valueBoolean` and `valueString` answers are supported. Each answered item's `linkId` is the
`criterionIdentifier`. Unanswered items are not processed. Nested items are flattened by the API, since the
`criterionIdentifier` is unique across the whole form.

**Roles.** The Applicant is `author`. The optional Referrer is the `referring-practitioner` extension.

**Status.** The Application status is never mapped to `QuestionnaireResponse.status`. It is always `completed`.
"""
* ^status = #draft
* obeys sa-qr-1 and sa-qr-2 and sa-qr-3 and sa-qr-4
* extension contains
    RequestForWaiver named requestForWaiver 0..1 MS and
    ReferringPractitioner named referringPractitioner 0..1 MS
* identifier MS
* identifier ^short = "Submitter's own reference, used for support and duplicate investigation"
* questionnaire 1..1 MS
* questionnaire only Canonical(SAQuestionnaire)
* questionnaire ^short = "Form canonical, version pinned: .../Questionnaire/{formNumber}|{formVersion}"
* status = #completed
* status MS
* subject 1..1 MS
* subject only Reference(SAPatient)
* authored 1..1 MS
* authored ^short = "When the practitioner completed the form"
* author 1..1 MS
* author only Reference(SAPractitioner)
* author ^short = "The Applicant"
* source 0..0
* item MS
* item.linkId MS
* item.linkId ^short = "criterionIdentifier (five character, zero padded) where answered"
* item.text MS
* item.text ^short = "Criterion name - stored, never used to identify an answer"
* item.answer MS
* item.answer ^short = "At most one answer per item (sa-qr-3)"
* item.answer.value[x] only boolean or string
* item.answer.value[x] MS
