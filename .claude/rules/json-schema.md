---
paths:
  - "**/*.json"
  - "schemas/**"
  - "**/*schema*.json"
---

# JSON and schemas

- Store UTF-8 JSON with two-space indentation and a final newline.
- Reject duplicate logical identifiers, unknown properties, invalid enum values, and inconsistent ranges.
- Prefer immutable source commits and explicit schema versions.
- Keep provisional and validated data distinguishable with status fields.
- Do not use comments in JSON.
- Add positive and negative fixtures for new schemas.
- Combine JSON Schema with semantic validation when fields depend on each other.
- Ensure every new JSON file is discovered by repository-wide validation.
- Never weaken a schema merely to accept one malformed package; fix the package or version the contract.
