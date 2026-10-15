An Application is enquired by its business identifier, the **Application Number**. The resources are the same `Claim` and
`ClaimResponse` used for [Submit Application](submit-application.html), so a retrieved Application and a submitted one
share one shape.

The Application record is mutable. Enquiry always reflects the Application's **current** state; prior states cannot be
retrieved. Retrieval by FHIR resource id (`GET [base]/Claim/[id]`) is not supported.

All identifier searches SHALL be system-qualified (`system|value`). See [Identifiers and Naming Systems](identifiers.html).

### Retrieve a submitted Application

```
GET [base]/Claim?identifier=https://fhir-ig.digital.health.nz/special-authority/ns/application-number|{applicationNumber}
    &_include=Claim:patient
    &_include=Claim:requestor
    &_include=Claim:supportinginfo
```

The `_include` parameters resolve the full shape produced at submission - `Claim`, `QuestionnaireResponse`, `Patient` and
`Practitioner` - so a retrieval and a submission return structurally identical content. `Claim:requestor` is a custom
search parameter that resolves to the Applicant in `Claim.provider` (see [Design Notes](design-notes.html#claim-requestor)).

On retrieval, `Claim.identifier` carries the Application Number, and asserted source context is returned in the
[submission-context](StructureDefinition-submission-context.html) extension. The stored source payload is never returned.

### Retrieve Application Outcome

```
GET [base]/ClaimResponse?request.identifier=https://fhir-ig.digital.health.nz/special-authority/ns/application-number|{applicationNumber}
    &_elements=extension,preAuthRef
```

Returns an [SA Application ClaimResponse](StructureDefinition-sa-application-claimresponse.html) whose
[application-status](StructureDefinition-application-status.html) extension carries the same `status`, `outcome`,
`outcomeCode` and `outcomeReason` returned synchronously at submission (D22). `preAuthRef` carries the Approval Number
where the Application was approved. `_elements` limits the response to the status and Approval Number.

`existing-approval` is **not** returned on enquiry. A conflicting Approval is resolved at submission, so that detail is
only useful in the immediate response.

Example: [pending review](ClaimResponse-sa-example-cr-pending.html).

### Search Applications

```
GET [base]/Claim?identifier={application-number-system}|{applicationNumber}
GET [base]/Claim?patient.identifier=https://standards.digital.health.nz/ns/nhi-id|{nhi}
GET [base]/Claim?requestor:Practitioner.identifier=https://standards.digital.health.nz/ns/hpi-person-id|{cpn}
GET [base]/Claim?requestor:Practitioner.identifier=https://standards.digital.health.nz/ns/medical-council-id|{registrationNumber}
GET [base]/Claim?application-status=PENDING_REVIEW
GET [base]/Claim?created=ge2026-01-01&created=le2026-01-31
```

| Parameter | Definition | Notes |
|---|---|---|
| `identifier` | core | Application Number system only. |
| `patient.identifier` | core, chained | NHI. |
| `requestor:Practitioner.identifier` | [claim-requestor](SearchParameter-claim-requestor.html), chained | Supply **either** the HPI CPN **or** a registration identifier. The registration authority is the identifier system (e.g. Medical Council), the registration number the value. |
| `application-status` | [application-status](SearchParameter-application-status.html) | `SUBMITTED`, `PENDING_REVIEW`, `CANCELLED`, `DONE`. `Claim.status` cannot express these. |
| `created` | core | `ge` / `le` map to submitted-from and submitted-to. |
{:.grid}

Filters may be combined. Search results are **summary** representations: referenced `Patient`, `Practitioner`,
`Organization` and `QuestionnaireResponse` resources are not resolved. Use
[Retrieve a submitted Application](#retrieve-a-submitted-application) for full detail.

### Search Application by Approval Number

```
GET [base]/ClaimResponse?identifier=https://fhir-ig.digital.health.nz/special-authority/ns/approval-number|{approvalNumber}
    &_include=ClaimResponse:request
```

The Approval Number is an adjudication result, so it is carried on `ClaimResponse`, never on `Claim` (D23). The
`_include` returns the originating `Claim` in the same response.
