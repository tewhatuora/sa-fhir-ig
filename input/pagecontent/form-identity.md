### The form canonical

A Special Authority form is identified by a `Questionnaire` canonical minted by Health NZ under this guide. The
canonical identifies the Health NZ interpretation of a Pharmac form at a point in time: the version is computed by
Health NZ, and the `criterionIdentifier` values are Health NZ derived metadata that Pharmac neither authors nor guarantees.

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
definitions continue to be distributed in their existing XML format. The
[SA Questionnaire](StructureDefinition-sa-questionnaire.html) profile documents the constraints the canonical and items
must meet, and the [SA9999 example](Questionnaire-SA9999.html) is fictional and illustrative only.

If the national Online Questionnaire Standard (revision of HISO 10014-2) fixes a canonical naming convention, this guide
will conform to it.

### Version pinning

`QuestionnaireResponse.questionnaire` **SHALL be version-pinned**. The API rejects an unpinned canonical. Because this
rule is enforced by the API against the authenticated client, the profile expresses it as a **warning** (invariant
`sa-qr-2`).

The service persists the resolved form version on every Application, so every stored Application carries the full
correlation key.

### Criterion identity

The `linkId` of each answered item is the **`criterionIdentifier`**, derived by Health NZ from the identifier of each
criterion in the Special Authority form definition. It is a **five character, zero padded numeric string** (e.g.
`00017`) (invariants `sa-q-4`, `sa-qr-4`).

A `criterionIdentifier` is meaningful only alongside the form it was derived from. The correlation key for a clinical
answer is:

```
form number + form version + criterionIdentifier
```

The first two are carried by the version-pinned `questionnaire` canonical and the third by `item.linkId`.

Group items MAY use any `linkId`; only boolean and string criteria items are constrained. Criteria items are **not**
marked `required` (`sa-q-5`), so a partial QuestionnaireResponse is valid against the profile.
