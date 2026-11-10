---
name: triage
description:
  "Triage review feedback on a pull request: judge each open thread and propose
  a fix. Use when the user types /triage <PR number> [comment id]."
argument-hint: "<PR number> [comment id]"
disable-model-invocation: true
---

# Triage PR review feedback

Read-only until the user picks fixes. Arguments: a PR number in the current
repo, and optionally a review comment id (the number in `#discussion_r<id>`) to
triage only that thread.

## Procedure

1. **Resolve the repo from git.** Run `gh repo view --json owner,name,url`. Take
   the host from `url` and pass `--hostname <host>` to every `gh api` call,
   since `gh api` otherwise defaults to github.com.
2. **Check out the PR context.** Confirm the local branch matches the PR head
   (`gh pr view <n> --json headRefName,baseRefName,state`). If it doesn't, say
   so and ask before switching branches.
3. **Fetch the threads.** Get review threads, which carry the resolved state the
   REST API lacks:

   ```sh
   gh api graphql --hostname <host> -F owner=<owner> -F repo=<name> -F n=<pr> -f query='
     query($owner: String!, $repo: String!, $n: Int!) {
       repository(owner: $owner, name: $repo) {
         pullRequest(number: $n) {
           reviewThreads(first: 100) {
             nodes {
               isResolved isOutdated path line
               comments(first: 50) { nodes { databaseId author { login } body url } }
             }
           }
         }
       }
     }'
   ```

   Keep unresolved threads only. With a comment id, keep only the thread that
   contains it. Also read top-level review bodies
   (`gh pr view <n> --json reviews`) for feedback outside threads.

4. **Judge each thread.** Read the code it points at, on the current branch.
   Decide whether the comment is valid, partly valid, already fixed, or not
   valid, and why. Check the claim against the code and requirements; don't take
   the reviewer's word or defend the code by default.
5. **Report.** One numbered item per thread: file and line, a one-line summary
   of the comment, the verdict with reasoning, and the proposed fix (or the
   suggested reply when no change is needed). Numbering lets the user reply "fix
   1 & 3".

## Rules

- Make no code changes until the user picks items.
- Never resolve threads; the reviewer resolves them.
- Never post replies or reviews unless the user asks.
