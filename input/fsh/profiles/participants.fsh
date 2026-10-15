// ---------------------------------------------------------------------------
// Patient, Practitioner and Organization - derived from NZ Base (D4)
// ---------------------------------------------------------------------------

Profile: SAPatient
Parent: $NzPatient
Id: sa-patient
Title: "SA Patient"
Description: """
The patient who is the subject of a Special Authority Application. Derived from NZ Base `NzPatient` (D4), which supplies
the `NzAddress` datatype and the NZ Base suburb extension.

The NHI is mandatory. Suburb is carried **only** in the NZ Base suburb extension - consumers SHALL NOT fall back to
`Address.district` or parse `Address.line`. NHI addresses are not always validated (no fixed abode, overseas and
unknown addresses), so suburb is not treated as mandatory. `NzAddress` building name, domicile code and geocode have no
home in the Application Data schema and are dropped by the API.
"""
* ^status = #draft
* identifier 1..* MS
* identifier[NHI] 1..1 MS
* identifier[NHI].value 1..1 MS
* name MS
* name.use MS
* name.text MS
* name.family MS
* name.given MS
* name.prefix MS
* name.suffix MS
* birthDate MS
* address MS
* address.line MS
* address.extension[suburb] MS
* address.city MS
* address.postalCode MS
* address.country MS
* address.country ^comment = "ISO 3166 country code."

Profile: SAPractitioner
Parent: $NzPractitioner
Id: sa-practitioner
Title: "SA Practitioner"
Description: """
A practitioner on a Special Authority Application: the **Applicant** (referenced from `QuestionnaireResponse.author`
and `Claim.requestor`) or the **Referrer** (referenced from the `referring-practitioner` extension). Derived from NZ
Base `NzPractitioner` (D4).

The role is carried by which element refers to the Practitioner, not by a role code (D5). `Practitioner` is used rather
than `PractitionerRole` because organisational context is not required.

A registration identifier is mandatory. The **registration authority is carried in `Identifier.system`**, using the
NZ Base responsible-authority naming systems (e.g. `https://standards.digital.health.nz/ns/medical-council-id`), and the
registration number in `Identifier.value`.

The HPI CPN is optional in the payload. For the Applicant, where a CPN is present it SHALL agree with the CPN claim in the
validated access token or the submission is rejected. No CPN is held for the Referrer.
"""
* ^status = #draft
* obeys sa-prac-1
* identifier 1..* MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier ^slicing.description = "Sliced by system. The registration identifier is required by invariant sa-prac-1 because its system varies by responsible authority."
* identifier contains cpn 0..1 MS
* identifier[cpn] ^short = "HPI Common Person Number (CPN)"
* identifier[cpn].system 1..1
* identifier[cpn].system = $HPI-CPN (exactly)
* identifier[cpn].value 1..1
* name 1..* MS
* address MS
* address ^comment = "The first address is treated as the work address of the Applicant."

Profile: SAOrganization
Parent: $NzOrganization
Id: sa-organization
Title: "SA Organization"
Description: """
The submitting practice or facility. Optional in a submission. Derived from NZ Base `NzOrganization` (D4).

The legacy Practice Id (`ZSS.1`) is carried on `identifier` using the SA Legacy Practice Id naming system. Where both the
payload and the authenticated context identify a practice and they disagree, the submission is rejected.
"""
* ^status = #draft
* identifier MS
* identifier ^slicing.discriminator.type = #value
* identifier ^slicing.discriminator.path = "system"
* identifier ^slicing.rules = #open
* identifier contains
    hpiOrganisation 0..1 MS and
    hpiFacility 0..1 MS and
    legacyPracticeId 0..1 MS
* identifier[hpiOrganisation].system = $HPI-ORG (exactly)
* identifier[hpiOrganisation].value 1..1
* identifier[hpiFacility].system = $HPI-FAC (exactly)
* identifier[hpiFacility].value 1..1
* identifier[legacyPracticeId].system = $SA-LegacyPracticeId (exactly)
* identifier[legacyPracticeId].value 1..1
* name MS
