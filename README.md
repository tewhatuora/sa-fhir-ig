# HSAAP Special Authority FHIR Implementation Guide

FHIR R4 Implementation Guide for the HSAAP Special Authority sector facing API (Submit Application,
Enquire Application, Enquire Approval). Derived from *HSAAP Special Authority - Sector Facing APIs
Detailed Design* v0.8.1. Built with SUSHI and the HL7 IG Publisher using the Health NZ template.

## Build

Prerequisites: Java 17+, Node.js, Jekyll (Ruby), and SUSHI (`npm install -g fsh-sushi`).

```bash
./_updatePublisher.sh     # first time only: downloads publisher.jar into input-cache/
./_genonce.sh             # runs SUSHI (via the IG Publisher) and builds the IG into output/
```

On Windows use the `.bat` equivalents. `_gencontinuous.sh` rebuilds on change.
`sushi build .` on its own compiles the FSH without running the IG Publisher.

The scripts are the standard ones from https://github.com/HL7/ig-publisher-scripts.
`input-cache/publisher.jar` is git-ignored.

## Layout

```
sushi-config.yaml          IG metadata, dependencies, pages, menu, artifact groups
ig.ini                     IG Publisher config (tewhatuora.fhir.template)
input/fsh/aliases.fsh      All URIs (NZ Base, NZMT, SA naming systems)
input/fsh/invariants.fsh   All sa-* invariants
input/fsh/profiles/        Patient, Practitioner, Organization, Questionnaire(Response), Claim(Response), Bundles
input/fsh/extensions/      referring-practitioner, request-for-waiver, submission-context, application-status,
                           existing-approval, approval-detail, approval-coverage
input/fsh/searchparameters Custom SearchParameters
input/fsh/conformance/     CapabilityStatement, $submit OperationDefinition
input/fsh/terminology/     CodeSystems, ValueSets, NamingSystems
input/fsh/examples/        Example instances and Bundles
input/pagecontent/         Narrative pages
```
