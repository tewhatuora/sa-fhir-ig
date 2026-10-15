// ---------------------------------------------------------------------------
// Invariants
// ---------------------------------------------------------------------------

Invariant: sa-prac-1
Description: "A Special Authority Practitioner SHALL carry a registration identifier, with a value, issued by a New Zealand responsible authority. The registration authority is carried in Identifier.system."
Severity: #error
Expression: "identifier.where(value.exists() and system in ('https://standards.digital.health.nz/ns/medical-council-id' | 'https://standards.digital.health.nz/ns/nursing-council-id' | 'https://standards.digital.health.nz/ns/midwifery-council-id' | 'https://standards.digital.health.nz/ns/dental-council-id' | 'https://standards.digital.health.nz/ns/pharmacy-council-id' | 'https://standards.digital.health.nz/ns/optometrists-dispensing-opticians-board-id' | 'https://standards.digital.health.nz/ns/dietitians-board-id' | 'https://standards.digital.health.nz/ns/chiropractic-board-id' | 'https://standards.digital.health.nz/ns/medical-radiation-technologists-board-id' | 'https://standards.digital.health.nz/ns/medical-sciences-council-id' | 'https://standards.digital.health.nz/ns/occupational-therapy-board-id' | 'https://standards.digital.health.nz/ns/osteopathic-council-id' | 'https://standards.digital.health.nz/ns/paramedic-council-id' | 'https://standards.digital.health.nz/ns/physiotherapy-board-id' | 'https://standards.digital.health.nz/ns/podiatrists-board-id' | 'https://standards.digital.health.nz/ns/psychologists-board-id' | 'https://standards.digital.health.nz/ns/psychotherapists-board-id')).exists()"

Invariant: sa-q-1
Description: "Questionnaire.url SHALL NOT contain a pipe ('|') or a fragment marker ('#')."
Severity: #error
Expression: "url.contains('|').not() and url.contains('#').not()"

Invariant: sa-q-2
Description: "Questionnaire.url SHOULD sit under the HSAAP Special Authority Questionnaire canonical base."
Severity: #warning
Expression: "url.startsWith('https://fhir-ig.digital.health.nz/special-authority/Questionnaire/')"

Invariant: sa-q-3
Description: "Only group, display, boolean and string items are permitted (Assumption 1)."
Severity: #error
Expression: "repeat(item).all(type = 'group' or type = 'display' or type = 'boolean' or type = 'string')"

Invariant: sa-q-4
Description: "The linkId of every boolean or string item SHALL be a criterionIdentifier: a five character, zero padded numeric string (D18)."
Severity: #error
Expression: "repeat(item).where(type = 'boolean' or type = 'string').all(linkId.matches('^[0-9]{5}$'))"

Invariant: sa-q-5
Description: "Criteria items SHALL NOT be marked required, so that a partial QuestionnaireResponse is valid against the profile (D14)."
Severity: #error
Expression: "repeat(item).where(type = 'boolean' or type = 'string').all(required.exists().not() or required = false)"

Invariant: sa-qr-1
Description: "QuestionnaireResponse.questionnaire SHALL be a canonical with a non-empty form URL, optionally followed by exactly one '|' and a non-empty form version, and SHALL NOT contain a fragment marker."
Severity: #error
Expression: "questionnaire.matches('^[^|#]+([|][^|#]+)?$')"

Invariant: sa-qr-2
Description: "QuestionnaireResponse.questionnaire SHALL be version-pinned (url|version) by FHIR-native clients. It MAY be unpinned only for submissions from the SOAP to FHIR Broker; this rule is enforced by the API against the authenticated client, so the profile only warns."
Severity: #warning
Expression: "questionnaire.contains('|')"

Invariant: sa-qr-3
Description: "Every answer SHALL be valueBoolean or valueString (Assumption 1), and an item SHALL carry at most one answer."
Severity: #error
Expression: "(item | item.repeat(item | answer.item)).all(answer.count() <= 1 and answer.all(value is boolean or value is string))"

Invariant: sa-qr-4
Description: "The linkId of every answered item SHALL be a five character, zero padded criterionIdentifier (D18)."
Severity: #error
Expression: "(item | item.repeat(item | answer.item)).where(answer.exists()).all(linkId.matches('^[0-9]{5}$'))"

Invariant: sa-claim-1
Description: "A requested pharmaceutical SHALL be identified by a CTPP ID or a Pharmacode."
Severity: #error
Expression: "productOrService.coding.where(system = 'http://nzmt.org.nz' or system = 'https://fhir-ig.digital.health.nz/special-authority/ns/pharmacode').exists()"

Invariant: sa-appstatus-1
Description: "An outcome is present if, and only if, status is DONE."
Severity: #error
Expression: "extension('outcome').exists() = extension('status').where(value = 'DONE').exists()"

Invariant: sa-cr-1
Description: "Where both are present, ClaimResponse.identifier (Approval Number) and ClaimResponse.preAuthRef SHALL carry the same value."
Severity: #error
Expression: "(identifier.exists() and preAuthRef.exists()) implies identifier.value contains preAuthRef"

Invariant: sa-cr-2
Description: "An Approval Number is present only where the Application outcome is APPROVED."
Severity: #error
Expression: "(identifier.exists() or preAuthRef.exists()) implies extension('https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/application-status').extension('outcome').where(value = 'APPROVED').exists()"

Invariant: sa-cr-3
Description: "existing-approval is present only where the Application outcome is DECLINED."
Severity: #error
Expression: "extension('https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/existing-approval').exists() implies extension('https://fhir-ig.digital.health.nz/special-authority/StructureDefinition/application-status').extension('outcome').where(value = 'DECLINED').exists()"

Invariant: sa-detail-1
Description: "providerIdType and providerId are either both present or both absent."
Severity: #error
Expression: "extension('providerIdType').exists() = extension('providerId').exists()"

Invariant: sa-cov-1
Description: "pharmaceutical is present if, and only if, type is EXPLICIT_PHARMACEUTICALS."
Severity: #error
Expression: "extension('pharmaceutical').exists() = extension('type').where(value = 'EXPLICIT_PHARMACEUTICALS').exists()"

Invariant: sa-cov-2
Description: "category is present if, and only if, type is PRODUCT_CATEGORY."
Severity: #error
Expression: "extension('category').exists() = extension('type').where(value = 'PRODUCT_CATEGORY').exists()"

Invariant: sa-cov-3
Description: "A pharmaceutical SHALL be identified by a pharmacode or a CTPP ID."
Severity: #error
Expression: "extension.where(url='pharmacode') and extension.where(url='ctppId')"
