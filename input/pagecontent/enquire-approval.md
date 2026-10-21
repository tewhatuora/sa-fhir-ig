An Approval is enquired **independently** of the Application that created it; no Application Number needs to be known.
Approvals are returned as [SA Approval ClaimResponse](StructureDefinition-sa-approval-claimresponse.html) resources.

### How an Approval is represented

| FHIR element | Meaning |
|---|---|
| `identifier`, `preAuthRef` | Approval Number (same value in both) |
| `preAuthPeriod.start` / `.end` | Effective and expiry dates. A lifetime Approval has a far-future expiry date; there is no sentinel value. |
| `patient` | The patient (resolved from the NHI) |
| `requestor` | The prescribing Practitioner who authored the originating Application |
| `request` | The originating Application, where still retrievable |
| `meta.lastUpdated` | When this Approval version was created |
| [approval-detail](StructureDefinition-approval-detail.html) | Approval type, **status** (ACTIVE / CANCELLED / REVOKED), form number and version, provider (pharmacy) |
| [approval-coverage](StructureDefinition-approval-coverage.html) | Coverage - **only** for NPPA and panel Approvals |
| `status`, `outcome` | Always `active` and `complete`. Mandatory in FHIR R4; carry no Special Authority meaning. |
{:.grid}

**Status.** `ClaimResponse.status` is bound to the financial resource status value set and cannot express the Approval
statuses ACTIVE, CANCELLED or REVOKED. Read the Approval status from `approval-detail.status`.

**Coverage.** A standard CHEM/RISK Approval's coverage is derivable from `approval-detail.formNumber` and `formVersion`
against the schedule, so it is not returned. NPPA and panel Approvals have no schedule form, so their coverage is carried
explicitly.

**Freshness.** The ClaimResponse is built from the current Approval record on every enquiry. It is not a replay of
the ClaimResponse returned at submission, because cancellation, revocation and update all create new Approval versions.

Examples: [CHEM Approval](ClaimResponse-sa-example-approval-chem.html),
[NPPA Approval with coverage and provider](ClaimResponse-sa-example-approval-nppa.html).

### Retrieve an Approval

```
GET [base]/ClaimResponse?identifier=https://fhir-ig.digital.health.nz/special-authority/ns/approval-number|{approvalNumber}
```

### Search Approvals

| Filter | FHIR parameter | Example |
|---|---|---|
| NHI | `patient.identifier` | `patient.identifier=https://standards.digital.health.nz/ns/nhi-id\|ZZZ0016` |
| Prescriber by CPN | `requestor:Practitioner.identifier` | `requestor:Practitioner.identifier=https://standards.digital.health.nz/ns/hpi-person-id\|99ZZZZ` |
| Prescriber by registration | `requestor:Practitioner.identifier` | `requestor:Practitioner.identifier=https://standards.digital.health.nz/ns/medical-council-id\|12345` |
| Approval status | [approval-status](SearchParameter-approval-status.html) | `approval-status=ACTIVE` |
| Valid on date | [approval-valid-on](SearchParameter-approval-valid-on.html) | `approval-valid-on=2026-09-18` |
| Expiring between | [approval-expiring](SearchParameter-approval-expiring.html) | `approval-expiring=ge2026-10-01&approval-expiring=le2026-12-31` |
| Provider (pharmacy) | [approval-provider-id](SearchParameter-approval-provider-id.html) | `approval-provider-id=https://fhir-ig.digital.health.nz/special-authority/ns/pharmacy-claimant-number\|1234` |
| Version state | [approval-version-state](SearchParameter-approval-version-state.html) | `approval-version-state=ALL` |
{:.grid}

Rules:

* A search SHALL supply at least one of the Approval Number (`identifier`), the NHI, or a practitioner identifier. The
  other filters narrow a result set rather than define one. A search supplying none of these is rejected.
* `approval-valid-on` and `approval-expiring` are **mutually exclusive**. Supplying both is rejected.
* `approval-valid-on` matches Approvals whose `preAuthPeriod` **contains** the date. This is not standard FHIR date
  search on a Period, which is why it is a custom parameter.
* A registration search is a query-time input only. Approvals are stored against the practitioner's CPN, so the service
  resolves the registration to a CPN first. If it does not resolve, an empty result set is returned.

### Approval versions

Approval versions are **not** FHIR resource versions. `meta.versionId` is not populated and `vread` / `_history`
are not supported. By default only the latest version of each Approval is returned. With `approval-version-state=ALL`,
each version is returned as a **distinct** ClaimResponse sharing the same Approval Number, ordered by
`meta.lastUpdated`. `PREVIOUS` returns superseded versions only. A specific historical version cannot be retrieved
directly.

Example: [all versions of an Approval for a patient](Bundle-sa-example-approval-search-all-versions.html).

### Worked examples

| Purpose | FHIR request |
|---|---|
| All (current and historical) Approvals for a patient | `GET [base]/ClaimResponse?patient.identifier={nhi-system}\|{nhi}&approval-version-state=ALL` |
| Current Approvals for a patient valid today | `GET [base]/ClaimResponse?patient.identifier={nhi-system}\|{nhi}&approval-valid-on=2026-10-15` |
| Current Approvals for a pharmacy | `GET [base]/ClaimResponse?approval-provider-id={claimant-number-system}\|{providerId}` |
| Current Approvals by prescriber | `GET [base]/ClaimResponse?requestor:Practitioner.identifier={hpi-cpn-system}\|{cpn}` |
| All Approvals by prescriber | `GET [base]/ClaimResponse?requestor:Practitioner.identifier={hpi-cpn-system}\|{cpn}&approval-version-state=ALL` |
| Active Approvals expiring this quarter, by registration | `GET [base]/ClaimResponse?requestor:Practitioner.identifier={registration-system}\|{number}&approval-expiring=ge2026-10-01&approval-expiring=le2026-12-31&approval-status=ACTIVE` |
{:.grid}
