All identifier searches SHALL be system-qualified (`system|value`). Unqualified searches are rejected.

### NZ Base identifiers

| Identifier | System | Used on |
|---|---|---|
| NHI | `https://standards.digital.health.nz/ns/nhi-id` | `Patient.identifier` (mandatory) |
| HPI CPN | `https://standards.digital.health.nz/ns/hpi-person-id` | `Practitioner.identifier` (Applicant, optional in payload) |
| HPI Organisation | `https://standards.digital.health.nz/ns/hpi-organisation-id` | `Organization.identifier` |
| HPI Facility | `https://standards.digital.health.nz/ns/hpi-facility-id` | `Organization.identifier` |
{:.grid}

### Practitioner registration

The **registration authority is carried in `Identifier.system`** and the registration number in `Identifier.value`, using
the NZ Base responsible-authority naming systems. Every SA Practitioner SHALL carry one (invariant `sa-prac-1`). Common
prescriber authorities:

| Responsible authority | System |
|---|---|
| Medical Council | `https://standards.digital.health.nz/ns/medical-council-id` |
| Nursing Council | `https://standards.digital.health.nz/ns/nursing-council-id` |
| Midwifery Council | `https://standards.digital.health.nz/ns/midwifery-council-id` |
| Dental Council | `https://standards.digital.health.nz/ns/dental-council-id` |
| Pharmacy Council | `https://standards.digital.health.nz/ns/pharmacy-council-id` |
| Optometrists and Dispensing Opticians Board | `https://standards.digital.health.nz/ns/optometrists-dispensing-opticians-board-id` |
{:.grid}

All other NZ Base responsible-authority systems are also accepted; whether a practitioner is in scope of practice to apply
is assessed by the service. `requestor:Practitioner.identifier` searches on `Claim` and `ClaimResponse` accept both the
HPI CPN system and any of these registration systems.

### Special Authority identifiers

| Identifier | Naming system | Used on |
|---|---|---|
| Application Number | [SA Application Number](NamingSystem-sa-application-number.html) | `Claim.identifier`, `ClaimResponse.request.identifier` |
| Approval Number | [SA Approval Number](NamingSystem-sa-approval-number.html) | `ClaimResponse.identifier`, `ClaimResponse.preAuthRef` (value only) |
| Practice Id | [SA Practice Id](NamingSystem-sa-legacy-practice-id.html) | `Organization.identifier` |
| Pharmacy claimant number | [SA Pharmacy Claimant Number](NamingSystem-sa-pharmacy-claimant-number.html) | `approval-detail.providerId` |
| Pharmacode | [SA Pharmacode](NamingSystem-sa-pharmacode.html) | `Claim.item.productOrService.coding` (NPPA / panel only) |
{:.grid}

The Application Number is the only identifier carried on `Claim`. The Approval Number is an adjudication result and is
carried only on `ClaimResponse`.

CTPP IDs use the NZMT system `http://nzmt.org.nz`.

### Questionnaire canonical base

```
https://fhir-ig.digital.health.nz/special-authority/Questionnaire/{formNumber}
```

See [Form and Criterion Identity](form-identity.html).
