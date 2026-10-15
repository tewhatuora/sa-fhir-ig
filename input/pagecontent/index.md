### Introduction

This Implementation Guide defines the **HSAAP Special Authority sector facing FHIR API**. It allows Practice Management
Systems (PMS), the SOAP to FHIR Broker, the Special Authority application in the Population Health Salesforce org, and
any future FHIR-native sector client to:

* **submit** Special Authority Applications, and
* **enquire** on existing Special Authority Applications and Approvals.

The API is hosted in MuleSoft, which validates each request against the profiles in this guide, translates it to the
RESTful API of the *special-authority-application-service*, and translates the response back into FHIR. The
*special-authority-application-service* neither produces nor consumes FHIR.

<div class="dragon">
<b>Draft.</b> This guide is under active development and is derived from <i>HSAAP Special Authority - Sector Facing APIs
Detailed Design</i> v0.8.1. Several elements of that design could not be represented exactly in FHIR R4; each departure
is listed on the <a href="design-notes.html">Design Notes and Open Issues</a> page.
</div>

### Resource model

A Special Authority Application is, in FHIR's own terms, a request for authorisation of funded goods in advance of their
supply, and is therefore modelled as a `Claim` with `use = preauthorization`. The clinical criteria and their answers are
carried as a `QuestionnaireResponse`, not as an encoded string. The outcome, and any resulting Approval, is a
`ClaimResponse`: `preAuthRef` and `preAuthPeriod` carry the Approval Number and its effective and expiry dates.

Da Vinci Prior Authorization Support is used as a pattern reference only. Its US-specific terminology bindings and X12
assumptions are not adopted.

| Resource | Profile | Derived from | Role |
|---|---|---|---|
| Bundle | [SA Submission Bundle](StructureDefinition-sa-submission-bundle.html) | Bundle | Request body of `Claim/$submit` |
| Claim | [SA Claim](StructureDefinition-sa-claim.html) | Claim | The Application |
| QuestionnaireResponse | [SA QuestionnaireResponse](StructureDefinition-sa-questionnaire-response.html) | QuestionnaireResponse | Clinical criteria and answers |
| Questionnaire | [SA Questionnaire](StructureDefinition-sa-questionnaire.html) | Questionnaire | Constraints on the form canonical (not published in Phase 1) |
| Patient | [SA Patient](StructureDefinition-sa-patient.html) | NZ Base `NzPatient` | The patient (NHI) |
| Practitioner | [SA Practitioner](StructureDefinition-sa-practitioner.html) | NZ Base `NzPractitioner` | Applicant and Referrer |
| Organization | [SA Organization](StructureDefinition-sa-organization.html) | NZ Base `NzOrganization` | Submitting practice or facility |
| Bundle | [SA Response Bundle](StructureDefinition-sa-response-bundle.html) | Bundle | Response from `Claim/$submit` |
| ClaimResponse | [SA Application ClaimResponse](StructureDefinition-sa-application-claimresponse.html) | ClaimResponse | Application status and outcome |
| ClaimResponse | [SA Approval ClaimResponse](StructureDefinition-sa-approval-claimresponse.html) | ClaimResponse | An Approval |
| OperationOutcome | [SA Outcome OperationOutcome](StructureDefinition-sa-outcome-operationoutcome.html) | OperationOutcome | The single business outcome |
{:.grid}

Monetary amounts are never present on a Special Authority Application or Approval. The financial elements of `Claim`
and `ClaimResponse` are constrained out rather than left unused and optional.

### API summary

| Interaction | Request |
|---|---|
| [Submit Application](submit-application.html) | `POST [base]/Claim/$submit` |
| [Retrieve a submitted Application](enquire-application.html#retrieve-a-submitted-application) | `GET [base]/Claim?identifier=...&_include=...` |
| [Retrieve Application Outcome](enquire-application.html#retrieve-application-outcome) | `GET [base]/ClaimResponse?request.identifier=...` |
| [Search Applications](enquire-application.html#search-applications) | `GET [base]/Claim?...` |
| [Retrieve / Search Approvals](enquire-approval.html) | `GET [base]/ClaimResponse?...` |
{:.grid}

The full API is described by the [HSAAP Special Authority FHIR API CapabilityStatement](CapabilityStatement-SpecialAuthorityFHIRAPICapabilityStatement.html).

### Scope

**In scope:** the FHIR profiles, extensions, search parameters and operation used by the sector facing API; the
rules a submitter must follow; and how outcomes are rendered.

**Out of scope:** business rule content and rule evaluation sequence (Application Decisioning design); HL7 v2 to FHIR
translation (SOAP to FHIR Broker); decisioning; the Application Store, Approval/Entitlement Store and Pharmaceutical
Schedule internal APIs; and authentication and authorisation mechanics (Security design), which are summarised on
[Security, Onboarding and Auditing](security.html).

### Dependencies

{% include dependency-table.xhtml %}

### Intellectual property

{% include ip-statements.xhtml %}
