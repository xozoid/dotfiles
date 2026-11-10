---
name: github-gh-cli
description:
  "Prefer the `gh` CLI for GitHub interaction and use the PR template when
  creating a pull request. Use for any GitHub task: PRs, issues, reviews,
  checks, releases, API calls."
---

## Prefer `gh`

Use the `gh` CLI for GitHub interaction (PRs, issues, reviews, checks, releases,
API calls) instead of GitHub MCP tools, unless `gh` cannot do the job.

## Pull request template

Before creating a PR, look for a template and use it as the PR body:

1. Check the repo: `.github/pull_request_template.md`,
   `.github/PULL_REQUEST_TEMPLATE.md`, `docs/pull_request_template.md`,
   `pull_request_template.md`, or files in `.github/PULL_REQUEST_TEMPLATE/`.
2. If the repo has none, fall back to the org template:
   `gh api repos/<org>/.github/contents/.github/pull_request_template.md -q .content | base64 -d`
3. Fill in every section. Leave checklists unticked.
4. Create with `gh pr create --draft --body-file <file>`.

## Editing a PR

On some GitHub Enterprise hosts `gh pr edit` fails with a Projects classic
GraphQL error. Use `gh api -X PATCH repos/<org>/<repo>/pulls/<n> -F body=@file`
instead.
