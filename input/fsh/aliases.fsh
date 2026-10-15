// ---------------------------------------------------------------------------
// Aliases
// If the IG slug changes (open item O9), update every $SA-* alias below.
// ---------------------------------------------------------------------------

// NZ Base profiles and extensions
Alias: $NzPatient = http://hl7.org.nz/fhir/StructureDefinition/NzPatient
Alias: $NzPractitioner = http://hl7.org.nz/fhir/StructureDefinition/NzPractitioner
Alias: $NzOrganization = http://hl7.org.nz/fhir/StructureDefinition/NzOrganization
Alias: $suburb = http://hl7.org.nz/fhir/StructureDefinition/suburb

// NZ identifier namespaces (defined in NZ Base)
Alias: $NHI = https://standards.digital.health.nz/ns/nhi-id
Alias: $HPI-CPN = https://standards.digital.health.nz/ns/hpi-person-id
Alias: $HPI-ORG = https://standards.digital.health.nz/ns/hpi-organisation-id
Alias: $HPI-FAC = https://standards.digital.health.nz/ns/hpi-facility-id
Alias: $MCNZ = https://standards.digital.health.nz/ns/medical-council-id
Alias: $NCNZ = https://standards.digital.health.nz/ns/nursing-council-id

// Medicines terminology
Alias: $NZMT = http://nzmt.org.nz

// HL7 terminology
Alias: $claim-type = http://terminology.hl7.org/CodeSystem/claim-type
Alias: $processpriority = http://terminology.hl7.org/CodeSystem/processpriority
Alias: $issue-type = http://hl7.org/fhir/issue-type

// HSAAP Special Authority naming systems (placeholders pending confirmation; see design-notes)
Alias: $SA-ApplicationNumber = https://fhir-ig.digital.health.nz/special-authority/ns/application-number
Alias: $SA-ApprovalNumber = https://fhir-ig.digital.health.nz/special-authority/ns/approval-number
Alias: $SA-LegacyPracticeId = https://fhir-ig.digital.health.nz/special-authority/ns/legacy-practice-id
Alias: $SA-ClaimantNumber = https://fhir-ig.digital.health.nz/special-authority/ns/pharmacy-claimant-number
Alias: $SA-Pharmacode = https://fhir-ig.digital.health.nz/special-authority/ns/pharmacode
