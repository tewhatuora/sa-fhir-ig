This page records where this guide departs from, or adds to, *HSAAP Special Authority - Sector Facing APIs Detailed
Design* v0.8.1, and the items still to be confirmed. Each departure was needed because the design cannot be expressed
exactly in FHIR R4.

### Departures from the detailed design

#### Claim requestor

The design uses `Claim.requestor` for the Applicant. **FHIR R4 `Claim` has no `requestor` element** (only `ClaimResponse`
has one). The Applicant is therefore carried in `Claim.provider` - "the provider which is responsible for the claim,
predetermination or preauthorization" - restricted to SA Practitioner.

FHIR R4 also defines no `requestor` search parameter on `Claim`. To preserve the API contract in the design,
`requestor:Practitioner.identifier` and `_include=Claim:requestor`, this guide defines a custom
[claim-requestor](SearchParameter-claim-requestor.html) parameter with code `requestor` whose expression is
`Claim.provider`. The core `provider` parameter is equivalent.

**Decision needed:** confirm `Claim.provider`, and whether to keep the `requestor` alias or publish `provider` instead.

#### Claim supportinginfo include

FHIR R4 defines no search parameter for `Claim.supportingInfo`, so `_include=Claim:supportinginfo` needs the custom
[claim-supportinginfo](SearchParameter-claim-supportinginfo.html) parameter.

#### submission-context location

The design places `submission-context` on `Bundle`. **FHIR R4 `Bundle` is a `Resource`, not a `DomainResource`, and has no
`extension` element.** This guide places the extension on the focal `Claim`, which also means it is returned naturally on
Application Enquiry. `Bundle.meta.extension` was considered and rejected as a non-idiomatic workaround.

#### Mandatory core elements

| Element | Issue | Approach |
|---|---|---|
| `Claim.insurance` (1..\*) | Mandatory; no insurer concept in Special Authority | One entry, `focal = true`, `coverage.display = "Pharmaceutical Schedule"`, no resolvable reference |
| `ClaimResponse.insurer` (1..1) | Mandatory | `display` only, e.g. "Health New Zealand \| Te Whatu Ora" |
| `ClaimResponse.outcome` (1..1) | Design says "not mapped" | Approval: fixed `complete`. Application: mapped from HSAAP status (see [Validation and Outcomes](validation-and-outcomes.html)) |
| `ClaimResponse.status` (1..1) | Design says "not mapped" | Fixed `active` |
| `Claim.provider`, `Claim.priority` (1..1) | Mandatory | Applicant; `normal` |
{:.grid}

**Decision needed:** confirm the insurer display value and whether a resolvable Pharmac or Health NZ Organization should be
referenced instead.

#### application-status search on Claim

The design defines `application-status` as a search parameter on `Claim` but places the extension on `ClaimResponse`. A
FHIRPath expression on `Claim` cannot reach a `ClaimResponse`. This guide allows the
[application-status](StructureDefinition-application-status.html) extension on both, populates it on `Claim` in enquiry
results only, and defines the search parameter on both resources.

#### Approval Number search on Claim

The Search Applications table in the design lists an Approval Number `identifier` search on `Claim`, which contradicts
D23. This guide follows **D23**: `Claim.identifier` carries only the Application Number, and Approval Number search is on
`ClaimResponse` with `_include=ClaimResponse:request`.

#### Submitting Organization is unreferenced

The submission Bundle may contain an Organization, but no R4 `Claim` element is suitable for referencing the submitting
practice once `provider` holds the Applicant (`facility` is a `Location`). The Organization is therefore an unreferenced
entry, identified by its legacy Practice Id. **Option:** add an optional `submittingOrganization` reference to
`submission-context`.

#### Requested pharmaceuticals (NPPA and panel)

The design maps coverage from "requested pharmaceutical coding" without naming the element. This guide uses
`Claim.item.productOrService.coding`, sliced by CTPP (`http://nzmt.org.nz`) and Pharmacode.

#### Other modelling choices

* **existing-approval** is a separate extension rather than a sub-extension of `application-status`, so
  `application-status` has an identical shape at submission and enquiry (D22).
* **approval-detail.providerId** is an `Identifier` (not a string) so that the
  [approval-provider-id](SearchParameter-approval-provider-id.html) token search is system-qualified.
* **approval-valid-on** has custom containment semantics (start &le; date &le; end); standard FHIR date search on a
  Period does not mean this.
* **approval-version-state** has no FHIRPath expression; it is a result-control parameter.
* The design's example "Search All Approvals by Prescribing Practitioner" omits `approval-version-state=ALL` on the FHIR
  request; this guide includes it.
* **Version pinning** of the form canonical depends on the authenticated channel, so the profile can only warn
  (`sa-qr-2`); the API enforces it.
* `QuestionnaireResponse.status` is fixed to `completed`.
* `preApprovalType`, `exemptionType` and `comments` are not mapped, per the design.

