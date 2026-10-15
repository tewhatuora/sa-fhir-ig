### The form canonical

A Special Authority form is identified by a `Questionnaire` canonical minted by Health NZ under this guide (D3). The
canonical identifies the HNZ interpretation of a Pharmac form at a point in time: the version is computed by the HNZ
ingest, and the `criterionIdentifier` values are HNZ-derived metadata that Pharmac neither authors nor guarantees.

`QuestionnaireResponse.questionnaire` carries both parts of the form identity in one element:

```
https://fhir-ig.digital.health.nz/special-authority/Questionnaire/SA2139|a3f2b8c91d4e7062
└──────────────────── form canonical ───────────────────────────┘ └─ form version ─┘
```

The final path segment of the canonical is the **form number**; the segment after the pipe is the **form version**. The
API splits on the pipe. No separate form number or form version parameter appears on the submission.

Rules:

1. `Questionnaire.url` SHALL NOT contain a pipe (`|`) or a fragment marker (`#`). The pipe exists only in the reference.
   (Invariant `sa-q-1`.)
2. `Questionnaire.version` and the form version SHALL be the same string, **character for character** - no case folding,
   trimming or normalisation. The value is a hash truncation and any tolerance destroys its meaning.

### The canonical is an identifier, not an address (Phase 1)

**No `Questionnaire` resource is published at the form canonical in Phase 1.** The canonical is an identifier only. Form
definitions remain base64 encoded XML and MathML retrieved from the *pharmac-direct-query-service*. The
[SA Questionnaire](StructureDefinition-sa-questionnaire.html) profile documents the constraints the canonical and items
must meet, and the [SA9999 example](Questionnaire-SA9999.html) is fictional and illustrative only.

If the national Online Questionnaire Standard (revision of HISO 10014-2) fixes a canonical naming convention, this guide
will conform to it.

### Version pinning and the SOAP to FHIR Broker

`QuestionnaireResponse.questionnaire` **SHALL be version-pinned** by FHIR-native clients. The API rejects an unpinned
canonical from any client other than the SOAP to FHIR Broker.

The Broker cannot supply a form version: the legacy HL7 message carries only `ZCR-1` (form number), and the PMS to
HealthLink contract cannot change. Broker submissions therefore carry an **unpinned** canonical. Because pinning depends on
the authenticated channel, the profile expresses it as a **warning** (invariant `sa-qr-2`); enforcement is by the API.

This is safe today because a form number resolves to exactly one definition. The service resolves it, validates against
it, and persists the resolved form version on the Application regardless of channel, so every stored Application carries
the full correlation key. It will **not** remain safe once Pharmac introduce form versioning.

One consequence is accepted: the two channels produce structurally different QuestionnaireResponses for the same clinical
event - one pinned, one not.

### Criterion identity

The `linkId` of each answered item is the **`criterionIdentifier`**, derived by the *pharmac-direct-query-service* from
the `id` of each `ci` element in the Special Authority criteria XML. It is a **five character, zero padded numeric
string** (e.g. `00017`), matching the legacy `ZCU-3` format (D18; invariants `sa-q-4`, `sa-qr-4`).

A `criterionIdentifier` is meaningful only alongside the form it was derived from. The correlation key for a clinical
answer is:

```
form number + form version + criterionIdentifier
```

The first two are carried by the version-pinned `questionnaire` canonical and the third by `item.linkId`.

Group items MAY use any `linkId`; only boolean and string criteria items are constrained. Criteria items are **not**
marked `required` (`sa-q-5`), so a partial QuestionnaireResponse is valid against the profile.
