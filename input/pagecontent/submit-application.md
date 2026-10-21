### Request

```
POST [base]/Claim/$submit
Content-Type: application/fhir+json
```

Defined by [Submit Special Authority Application](OperationDefinition-sa-claim-submit.html). The request body is an
[SA Submission Bundle](StructureDefinition-sa-submission-bundle.html) of type `collection`, posted directly (not wrapped
in `Parameters`):

```
Bundle (collection)
├── Claim                    use = preauthorization
├── QuestionnaireResponse    referenced from Claim.supportingInfo
├── Patient                  NHI identifier
├── Practitioner             Applicant
├── Practitioner             Referrer (optional)
└── Organization             submitting practice or facility (optional)
```

`$submit` is used rather than a plain `POST /Claim` because the unit of submission is the Bundle. A Special Authority
Application is only meaningful with its questionnaire, patient and practitioner context, and these are accepted or
rejected atomically. All references between entries SHALL resolve within the Bundle.

Example: [submission Bundle](Bundle-sa-example-submission-bundle.html).

### The Application (Claim)

* `use` is `preauthorization`, `type` is `pharmacy`, `status` is `active`, `priority` is `normal`.
* `patient` references the SA Patient.
* `provider` references the **Applicant** - the same Practitioner as `QuestionnaireResponse.author`.
* `supportingInfo` contains exactly one entry with category `questionnaire-response` referencing the QuestionnaireResponse.
* `identifier` is **absent** on submission. The Application Number is allocated by the service.
* `insurance` is mandatory in FHIR R4 and is populated with a single logical reference whose display is
  `Pharmaceutical Schedule`. It carries no other meaning.
* `item` is supplied **only** for NPPA and panel approval Applications (see [Coverage](#coverage)).

### Clinical criteria and answers (QuestionnaireResponse)

* `questionnaire` identifies the form and its version as `{form canonical}|{form version}`. See
  [Form and Criterion Identity](form-identity.html). FHIR-native clients **SHALL** version-pin this canonical.
* `subject` references the Patient; `author` references the **Applicant**; `authored` is the date the practitioner
  completed the form.
* `status` is always `completed`.
* `identifier` MAY carry the submitter's own reference, used for support and duplicate investigation.
* Each answered criterion is an `item` whose `linkId` is the five character, zero padded `criterionIdentifier` and whose
  single `answer` is `valueBoolean` or `valueString`. Any other answer datatype is rejected.
* `item.text` (criterion name) is stored but never used to identify an answer.
* Items with no answer are ignored. Nested `item` structures are flattened, since `criterionIdentifier` is unique across
  the whole form.
* The `request-for-waiver` extension MAY be supplied; it is treated as `false` when absent.

The API does **not** check that every criterion has been answered, and does not validate `criterionIdentifier` against
the form definition - both are assessed by the service. An incomplete Application is valid against these profiles and is
declined on assessment if information is insufficient.

### Applicant and Referrer

There are only ever two practitioner roles. The role is carried by which element refers to the Practitioner, not by a
role code:

| Role | Referenced from | Required identifiers |
|---|---|---|
| Applicant | `QuestionnaireResponse.author` and `Claim.provider` | Registration (authority in `system`, number in `value`). HPI CPN optional. |
| Referrer | `QuestionnaireResponse` extension [referring-practitioner](StructureDefinition-referring-practitioner.html) (0..1) | Registration only. No CPN is held. |
{:.grid}

The Applicant's CPN is taken from the validated access token in preference to the payload. Where a CPN is present in the
payload and disagrees with the token, the submission is rejected.

The Referrer is **asserted by the Applicant**. It is never authenticated or verified, and the service does not establish that
the named Referrer agreed to the referral.

### Patient

The Patient is profiled from NZ Base `NzPatient`. The NHI is mandatory. Suburb is carried only in the NZ Base
[suburb](http://hl7.org.nz/fhir/StructureDefinition/suburb) extension on `Address`; the API does not fall back to
`district` or parse `line`. Suburb is not mandatory, because NHI addresses are not always validated (no fixed abode,
overseas and unknown addresses). `NzAddress` building name, domicile code and geocode are accepted but dropped.

### Coverage

Coverage is **not** supplied for a standard Special Authority Application. The form declares the pharmaceuticals it
covers, and coverage is derived from the resolved form at decision time and recorded on the Approval. This prevents a
later schedule change silently altering the scope of an existing approval.

For NPPA and panel approval Applications, where no form declares coverage, the requested pharmaceuticals are carried in
`Claim.item.productOrService.coding`, identified by NZMT CTPP ID (`http://nzmt.org.nz`, preferred) and/or Pharmacode,
with `display` populated for support purposes. See the [NPPA example](Claim-sa-example-claim-nppa.html).

### Submission context

The authenticated requester identity is **never** taken from the FHIR payload. It is taken from the validated access token
and the validated signed Request-Context header.

### Response

The response is an [SA Response Bundle](StructureDefinition-sa-response-bundle.html) of type `collection` containing an
[SA Application ClaimResponse](StructureDefinition-sa-application-claimresponse.html), an
[SA Outcome OperationOutcome](StructureDefinition-sa-outcome-operationoutcome.html) where there is a reason to report, and
the resources the ClaimResponse references. See [Validation and Outcomes](validation-and-outcomes.html).

Examples: [approved](Bundle-sa-example-response-bundle-approved.html) and
[declined because a conflicting Approval exists](Bundle-sa-example-response-bundle-declined.html).

### Resubmission

The service assesses fail fast and returns one outcome per submission. A prescriber who corrects one problem and
resubmits will receive an assessment of the corrected Application.
