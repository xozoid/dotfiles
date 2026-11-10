---
name: pytest-conventions
description: >
  pytest file layout and naming conventions. Use when creating, organizing, or
  reviewing test files for any Python project.
---

## Test file layout

Mirror the source tree under `tests/`. Each source file gets at least one test
file with the same name prefixed by `test_`.

```
nummus/controllers/common.py  →  tests/controllers/test_common.py
nummus/models/item.py         →  tests/models/test_item.py
```

Complex source files may be split into multiple topic-focused test files inside
a sub-directory named after the source module:

```
nummus/controllers/auth/base.py   →  tests/controllers/auth/test_base.py
nummus/controllers/auth/debug.py  →  tests/controllers/auth/test_debug.py
nummus/controllers/auth/msal.py   →  tests/controllers/auth/test_msal.py
nummus/controllers/auth/top.py    →  tests/controllers/auth/test_top.py
```

Every test directory must contain an `__init__.py`.

## Web controller test files

Each Flask/HTMX controller module gets **at least three** test files:

| File                | Covers                                                       |
| ------------------- | ------------------------------------------------------------ |
| `test_contexts.py`  | Request context setup, before-request hooks, auth guards     |
| `test_endpoints.py` | HTTP route responses (status codes, HTML content, redirects) |
| `test_json.py`      | JSON / API responses and data shape                          |

Add more files for large feature areas (e.g., `test_filters.py`,
`test_exports.py`).

## Naming

- Test files: `test_<topic>.py`
- Test functions: `test_<what>_<condition>` — describe the scenario, not the
  implementation
- Fixtures: noun phrases (`web_client`, `flask_app`, `valid_html`)

## AAA structure

Every test function follows **Arrange → Act → Assert** order with exactly one
Act per function.

Do not add `# Arrange`, `# Act`, or `# Assert` phase-label comments. Use blank
lines to separate the phases when separation improves readability.

```python
def test_deposit_increases_balance(account: Account) -> None:
    account.balance = Decimal("100.00")

    account.deposit(Decimal("50.00"))

    assert account.balance == Decimal("150.00")
```

- **Arrange**: set up fixtures, state, and inputs
- **Act**: call the single thing under test — one call only
- **Assert**: verify the outcome; multiple assertions are fine if they all check
  the same logical result

Never put two Act calls in one test. If you need to verify two behaviors, write
two tests.

### One assert per value

Don't pack separate values into a tuple just to compare them in one assert. A
failure then reports only a position, not which field broke.

```python
# Bad
assert (handler.mailhost, handler.mailport) == ("relay.example.com", 25)

# Good
assert handler.mailhost == "relay.example.com"
assert handler.mailport == 25
```

If the value has named fields (NamedTuple, dataclass, model, result object),
assert each field with dot notation. Never compare it to a tuple literal, even
when it is a tuple at runtime. Comparing to a tuple is fine only for a plain
unnamed tuple return. To check that many fields are unchanged, compare dicts
keyed by field name so the diff names the field.

When many tests repeat the same few attribute asserts, add a one-line helper
that returns the attribute list (e.g. `rules(result)`) and assert on that.

### Split tests that share Arrange but not Assert

If one test loops over cases or checks several unrelated outcomes after the same
setup, move the setup to a fixture and write one test per outcome. Use
parametrize when the outcomes differ only by data.

### Deduplicating Arrange with fixtures

When multiple tests share the same setup, extract it into a fixture instead of
repeating it inline. Prefer fixtures over local helper functions or setup in the
test body.

```python
@pytest.fixture
def funded_account() -> Account:
    account = Account()
    account.balance = Decimal("100.00")
    return account


def test_deposit_increases_balance(funded_account: Account) -> None:
    funded_account.deposit(Decimal("50.00"))

    assert funded_account.balance == Decimal("150.00")


def test_withdraw_decreases_balance(funded_account: Account) -> None:
    funded_account.withdraw(Decimal("30.00"))

    assert funded_account.balance == Decimal("70.00")
```

### Deduplicating Act & Assert with parametrize

When the same Act + Assert logic applies to multiple input/output pairs, use
`@pytest.mark.parametrize`. Each parameter set is its own Arrange — the
decorated test runs once per row.

```python
@pytest.mark.parametrize(
    ("amount", "expected"),
    [
        (Decimal("10.00"), Decimal("110.00")),
        (Decimal("0.01"), Decimal("100.01")),
        (Decimal("100.00"), Decimal("200.00")),
    ],
)
def test_deposit_increases_balance(
    funded_account: Account,
    amount: Decimal,
    expected: Decimal,
) -> None:
    funded_account.deposit(amount)

    assert funded_account.balance == expected
```

Prefer parametrize over copying nearly-identical test functions.

### Reuse existing fixtures first

Before writing a fixture or building objects in a test body, read every
`conftest.py` from the test's directory up to `tests/`. Use the project's
fixtures (app, client, session, project, sample data) instead of rebuilding the
same thing locally.

Request a fixture as a test parameter. Use `@pytest.mark.usefixtures` only for
fixtures needed for a side effect whose value the test never reads.

### Test data in files

Put multiline input data (TOML, CSV, JSON, HTML, config files) in files under
`tests/data/<topic>/`, one file per case, named after the case
(`bad_format.toml`, `missing_config.toml`). Load them in the test or a fixture.
Don't embed multiline strings in test modules or build the data in code when a
file would do.

## Import rules

- All imports at module top level — no imports inside test functions (PLC0415)
- Use `TYPE_CHECKING` for imports only needed in annotations
- Runtime imports (used in function bodies) stay at the top level
