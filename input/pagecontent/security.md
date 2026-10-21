### Authentication and authorisation

Authentication and authorisation follow the Health NZ Digital Services Hub security model. In summary:

* Every request requires a validated OAuth 2.0 access token and a validated signed **Request-Context** header.
* The authenticated requester identity is taken from the token and Request-Context header, **never** from the FHIR payload.
* Values asserted in the payload - the [submission-context](StructureDefinition-submission-context.html) extension, the
  submitting Organization, and any practitioner CPN - are provenance only. They are checked for consistency with the
  authenticated context and never used for authentication or authorisation.

### Onboarding

The API uses the established Health NZ **Digital Services Hub** (DSH) processes. The API is onboarded through the Digital
Asset Onboarding process. PMS vendors follow the Digital Asset Subscriber Onboarding process, which assesses the
organisation, product and intended use cases against security, information-handling and lawful-disclosure requirements
before UAT credentials are issued. Successful onboarding accredits the subscriber product for an approved business
function. Contact <integration@tewhatuora.govt.nz>.

### Auditing

The API aligns with the Health NZ DSH centralised logging and auditing design. Audit events are captured and processed
asynchronously, transformed into FHIR `AuditEvent` resources and persisted to the centralised auditing solution. See the
[Audit Events Implementation Guide](https://fhir-ig.digital.health.nz/auditevents).
