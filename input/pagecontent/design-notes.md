This page explains modelling choices made where the Special Authority API does not map directly onto the FHIR R4 base
resources.

### Claim requestor

**FHIR R4 `Claim` has no `requestor` element** (only `ClaimResponse` has one). The Applicant is therefore carried in
`Claim.provider` - "the provider which is responsible for the claim, predetermination or preauthorization" - restricted
to SA Practitioner.

FHIR R4 also defines no `requestor` search parameter on `Claim`. So that `requestor:Practitioner.identifier` and
`_include=Claim:requestor` can be used in the same way on `Claim` and `ClaimResponse`, this guide defines a custom
[claim-requestor](SearchParameter-claim-requestor.html) parameter with code `requestor` whose expression is
`Claim.provider`. The core `provider` parameter is equivalent.

### Claim supportinginfo include

FHIR R4 defines no search parameter for `Claim.supportingInfo`, so `_include=Claim:supportinginfo` needs the custom
[claim-supportinginfo](SearchParameter-claim-supportinginfo.html) parameter.

### submission-context location

**FHIR R4 `Bundle` is a `Resource`, not a `DomainResource`, and has no `extension` element.** The
[submission-context](StructureDefinition-submission-context.html) extension is therefore carried on the focal `Claim`,
which also means it is returned naturally on Application Enquiry. `Bundle.meta.extension` was considered and rejected as
a non-idiomatic workaround.

### Mandatory core elements

| Element | Issue | Approach |
|---|---|---|
| `Claim.insurance` (1..\*) | Mandatory; no insurer concept in Special Authority | One entry, `focal = true`, `coverage.display = "Pharmaceutical Schedule"`, no resolvable reference |
| `ClaimResponse.insurer` (1..1) | Mandatory | `display` only, e.g. "Health New Zealand \| Te Whatu Ora" |
| `ClaimResponse.outcome` (1..1) | Mandatory; no direct Special Authority equivalent | Approval: fixed `complete`. Application: mapped from the Application status (see [Validation and Outcomes](validation-and-outcomes.html)) |
| `ClaimResponse.status` (1..1) | Mandatory; no direct Special Authority equivalent | Fixed `active` |
| `Claim.provider`, `Claim.priority` (1..1) | Mandatory | Applicant; `normal` |
{:.grid}

### application-status search on Claim

The Application status is carried in the [application-status](StructureDefinition-application-status.html) extension.
An `application-status` search on `Claim` needs an element on `Claim` to evaluate, and a FHIRPath expression on `Claim`
cannot reach a `ClaimResponse`. This guide therefore allows the extension on both resources, populates it on `Claim` in
enquiry results only, and defines the search parameter on both resources.

### Approval Number search

The Approval Number is an adjudication result, so `Claim.identifier` carries only the Application Number. Approval
Number search is on `ClaimResponse`, with `_include=ClaimResponse:request` to return the originating `Claim`.

### Submitting Organization is unreferenced

The submission Bundle may contain an Organization, but no R4 `Claim` element is suitable for referencing the submitting
practice once `provider` holds the Applicant (`facility` is a `Location`). The Organization is therefore an unreferenced
entry in the Bundle, identified by its HPI identifier or Practice Id.

### Requested pharmaceuticals (NPPA and panel)

For NPPA and panel approval Applications, the requested pharmaceuticals are carried in
`Claim.item.productOrService.coding`, sliced by CTPP (`http://nzmt.org.nz`) and Pharmacode.

### Other modelling choices

* **existing-approval** is a separate extension rather than a sub-extension of `application-status`, so
  `application-status` has an identical shape at submission and enquiry.
* **approval-detail.providerId** is an `Identifier` (not a string) so that the
  [approval-provider-id](SearchParameter-approval-provider-id.html) token search is system-qualified.
* **approval-valid-on** has custom containment semantics (start &le; date &le; end); standard FHIR date search on a
  Period does not mean this.
* **approval-version-state** has no FHIRPath expression; it is a result-control parameter.
* **Version pinning** of the form canonical is enforced by the API against the authenticated client, so the profile can
  only warn (`sa-qr-2`).
* `QuestionnaireResponse.status` is fixed to `completed`.
