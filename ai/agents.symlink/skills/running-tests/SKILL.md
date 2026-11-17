---
name: running-tests
description:
  "Default to targeted tests and coverage on the changed source paths, not the
  full suite. Use when running tests, coverage, or verification after a code
  change."
---

## Run targeted tests by default

Run only the tests for the code that changed. A full suite run for an unrelated
change is not worth the wall time.

- If the repo has `tools/run_coverage.py`, pass it the changed source paths, not
  the test paths, all in one call: `./tools/run_coverage.py src/a.py src/b/`. It
  runs the matching tests and enforces the coverage gate on those paths.
- Without that script, run `pytest` on the test files that mirror the changed
  sources.
- If a repo-wide convention test could be affected (for example `test_src.py`),
  add just that test file.
- Touching a central module is not a reason for a full run. List every changed
  path instead.

Run the full suite or a bare `coverage run` only when the user asks for a full
gate.

Formatters and linters (`tools/formatters.sh`, `tools/linters.sh`) are cheap and
repo-wide anyway. Run them normally.
