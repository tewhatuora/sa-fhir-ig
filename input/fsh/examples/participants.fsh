// ---------------------------------------------------------------------------
// Example participants. All identifiers are fictional / test values.
// ---------------------------------------------------------------------------

Instance: sa-example-patient
InstanceOf: SAPatient
Usage: #example
Title: "Example SA Patient"
Description: "Example patient using the NHI test range."
* identifier[NHI].use = #official
* identifier[NHI].system = $NHI
* identifier[NHI].value = "ZZZ0016"
* name[0].use = #official
* name[0].family = "Parata"
* name[0].given[0] = "Aroha"
* name[0].prefix[0] = "Ms"
* birthDate = "1968-03-14"
* address[0].use = #home
* address[0].line[0] = "12 Kowhai Street"
* address[0].extension[suburb].valueString = "Waikanae Beach"
* address[0].city = "Waikanae"
* address[0].postalCode = "5036"
* address[0].country = "NZ"

Instance: sa-example-applicant
InstanceOf: SAPractitioner
Usage: #example
Title: "Example Applicant"
Description: "Example applicant practitioner with an HPI CPN and a Medical Council registration."
* identifier[0].use = #official
* identifier[0].system = $HPI-CPN
* identifier[0].value = "99ZZZZ"
* identifier[1].use = #secondary
* identifier[1].system = $MCNZ
* identifier[1].value = "12345"
* name[0].use = #official
* name[0].family = "Smith"
* name[0].given[0] = "Jane"
* name[0].prefix[0] = "Dr"
* address[0].use = #work
* address[0].line[0] = "1 Main Highway"
* address[0].city = "Otaki"
* address[0].postalCode = "5512"
* address[0].country = "NZ"

Instance: sa-example-referrer
InstanceOf: SAPractitioner
Usage: #example
Title: "Example Referrer"
Description: "Example referring practitioner. Registration details only - no CPN is held for a referrer."
* identifier[0].use = #secondary
* identifier[0].system = $MCNZ
* identifier[0].value = "54321"
* name[0].use = #official
* name[0].family = "Ngata"
* name[0].given[0] = "Rawiri"
* name[0].prefix[0] = "Dr"

Instance: sa-example-practice
InstanceOf: SAOrganization
Usage: #example
Title: "Example Submitting Practice"
Description: "Example submitting practice with an HPI Facility identifier and a Practice Id."
* identifier[hpiFacility].system = $HPI-FAC
* identifier[hpiFacility].value = "FZZ999-B"
* identifier[legacyPracticeId].system = $SA-LegacyPracticeId
* identifier[legacyPracticeId].value = "PRAC01"
* name = "Example Medical Centre"
