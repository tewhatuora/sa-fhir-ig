// ---------------------------------------------------------------------------
// Code systems and value sets defined by this guide
// ---------------------------------------------------------------------------

RuleSet: SACodeSystem
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #fragment

RuleSet: SAValueSet
* ^status = #draft
* ^experimental = false

// --- Application status ----------------------------------------------------

CodeSystem: SAApplicationStatusCS
Id: sa-application-status
Title: "SA Application Status"
Description: "Lifecycle status of a Special Authority Application held by the special-authority-application-service. Deliberately not mapped to QuestionnaireResponse.status or Claim.status, neither of which can distinguish PENDING_REVIEW from DONE."
* insert SACodeSystem
* #SUBMITTED "Submitted" "The Application has been received and accepted for assessment."
* #PENDING_REVIEW "Pending review" "The Application requires manual review before an outcome can be determined."
* #CANCELLED "Cancelled" "The Application was cancelled before an outcome was determined."
* #DONE "Done" "Assessment is complete and an outcome is available."

ValueSet: SAApplicationStatusVS
Id: sa-application-status
Title: "SA Application Status"
Description: "All SA Application status codes."
* insert SAValueSet
* include codes from system SAApplicationStatusCS

// --- Application outcome ---------------------------------------------------

CodeSystem: SAApplicationOutcomeCS
Id: sa-application-outcome
Title: "SA Application Outcome"
Description: "Outcome of a Special Authority Application. Present only where the Application status is DONE."
* insert SACodeSystem
* #APPROVED "Approved" "The Application was approved and an Approval Number issued."
* #INVALID "Invalid" "The Application could not be assessed because it was invalid."
* #DECLINED "Declined" "The Application was assessed and declined on a substantive ground."

ValueSet: SAApplicationOutcomeVS
Id: sa-application-outcome
Title: "SA Application Outcome"
Description: "All SA Application outcome codes."
* insert SAValueSet
* include codes from system SAApplicationOutcomeCS

// --- Approval status -------------------------------------------------------

CodeSystem: SAApprovalStatusCS
Id: sa-approval-status
Title: "SA Approval Status"
Description: "Status of a Special Authority Approval in the Approval/Entitlement Store. Carried in the approval-detail extension because ClaimResponse.status (financial resource status) cannot express these meanings."
* insert SACodeSystem
* #ACTIVE "Active" "The Approval is in force."
* #CANCELLED "Cancelled" "The Approval has been cancelled."
* #REVOKED "Revoked" "The Approval has been revoked."

ValueSet: SAApprovalStatusVS
Id: sa-approval-status
Title: "SA Approval Status"
Description: "All SA Approval status codes."
* insert SAValueSet
* include codes from system SAApprovalStatusCS

// --- Approval type ---------------------------------------------------------

CodeSystem: SAApprovalTypeCS
Id: sa-approval-type
Title: "SA Approval Type"
Description: "Type of Special Authority Approval (legacy ZST.8). **Draft and incomplete** - the design lists CHEM, HOSP, EXCP, TEMPLETON 'etc.'. The full list must be confirmed against the Approval/Entitlement Store before publication."
* insert SACodeSystem
* ^content = #fragment
* #CHEM "Chemical" "Standard Special Authority Approval derived from a Pharmaceutical Schedule form."
* #RISK "Risk" "Special Authority Approval for a risk-managed pharmaceutical derived from a Pharmaceutical Schedule form."
* #HOSP "Hospital" "Hospital Special Authority Approval."
* #EXCP "Exceptional circumstances" "Exceptional circumstances (NPPA) Approval. No schedule form."
* #TEMPLETON "Templeton" "Panel approval. No schedule form."

ValueSet: SAApprovalTypeVS
Id: sa-approval-type
Title: "SA Approval Type"
Description: "All SA Approval type codes."
* insert SAValueSet
* include codes from system SAApprovalTypeCS

// --- Coverage type ---------------------------------------------------------

CodeSystem: SACoverageTypeCS
Id: sa-coverage-type
Title: "SA Approval Coverage Type"
Description: "Coverage variants returned on the approval-coverage extension. SCHEDULE_HIERARCHY coverage exists in the Approval Store but is not returned over FHIR (D15) and so is not included."
* insert SACodeSystem
* #EXPLICIT_PHARMACEUTICALS "Explicit pharmaceuticals" "Coverage is an explicit list of pharmaceuticals."
* #PRODUCT_CATEGORY "Product category" "Coverage is a product category."
* #ALL_PHARMACEUTICALS "All pharmaceuticals" "Coverage extends to all pharmaceuticals."

ValueSet: SACoverageTypeVS
Id: sa-coverage-type
Title: "SA Approval Coverage Type"
Description: "All SA Approval coverage type codes returned over FHIR."
* insert SAValueSet
* include codes from system SACoverageTypeCS

// --- Provider id type ------------------------------------------------------

CodeSystem: SAProviderIdTypeCS
Id: sa-provider-id-type
Title: "SA Provider Id Type"
Description: "Identifier type for the provider (pharmacy) on an Approval. Fixed to CLAIMANT_NUMBER until pharmacies move to HPI Facility numbers."
* insert SACodeSystem
* #CLAIMANT_NUMBER "Claimant number" "Pharmacy claimant number."

ValueSet: SAProviderIdTypeVS
Id: sa-provider-id-type
Title: "SA Provider Id Type"
Description: "All SA provider id type codes."
* insert SAValueSet
* include codes from system SAProviderIdTypeCS

// --- Approval version state ------------------------------------------------

CodeSystem: SAApprovalVersionStateCS
Id: sa-approval-version-state
Title: "SA Approval Version State"
Description: "Values for the approval-version-state search parameter. **Draft** - code names other than ALL must be confirmed against the Approval Store versionState values."
* insert SACodeSystem
* #LATEST "Latest" "Only the current version of each Approval (default)."
* #PREVIOUS "Previous" "Only superseded versions of each Approval."
* #ALL "All" "Current and superseded versions of each Approval."

ValueSet: SAApprovalVersionStateVS
Id: sa-approval-version-state
Title: "SA Approval Version State"
Description: "All SA Approval version state codes."
* insert SAValueSet
* include codes from system SAApprovalVersionStateCS

// --- Claim supporting info category ----------------------------------------

CodeSystem: SASupportingInfoCategoryCS
Id: sa-supporting-info-category
Title: "SA Claim Supporting Info Category"
Description: "Categories of Claim.supportingInfo used on a Special Authority Application."
* insert SACodeSystem
* #questionnaire-response "Questionnaire response" "The QuestionnaireResponse carrying the clinical criteria and answers for the Application."

// --- Outcome codes (Error Code Catalogue) ----------------------------------

CodeSystem: SAOutcomeCodeCS
Id: sa-outcome-code
Title: "SA Outcome Code"
Description: "Machine readable outcome codes from the single Error Code Catalogue authored and published by the special-authority-application-service (D10). **The catalogue has not yet been published, so this code system is defined with content = not-present.**"
* ^status = #draft
* ^experimental = false
* ^caseSensitive = true
* ^content = #not-present

ValueSet: SAOutcomeCodeVS
Id: sa-outcome-code
Title: "SA Outcome Code"
Description: "All codes in the SA Error Code Catalogue."
* insert SAValueSet
* include codes from system SAOutcomeCodeCS
