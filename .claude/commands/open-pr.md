---
description: Create a pull request to develop following the project PR template. Use when you want to open a PR for the current branch.
argument-hint: '[additional context or notes for the PR description]'
---

Create a pull request from the current branch following the project template.

## Steps

1. Detect the parent branch by running:
   `git log --oneline --decorate --all --simplify-by-decoration HEAD | grep -v "HEAD" | head -3`
   Pick the closest ancestor branch from the output (e.g. `develop`, `main`, `release/x.y`).
2. Run `git diff <base>...HEAD` and `git log <base>..HEAD --oneline` to understand all changes
3. Read `.github/PULL_REQUEST_TEMPLATE.md` for the exact template structure
4. Determine:
   - PR title using the emoji/type mapping below
   - Which **Type of Change** checkbox to tick (Bugfix / Improvement / New feature / Breaking change)
   - What changed at the component/module level
5. Run `gh pr create --base <base>` filling each section:
   - **Why?** — the problem this solves
   - **Type of Change** — tick the correct checkbox
   - **What Changed?** — layers, classes, entities affected
   - **Screenshots** — remove the table if there are no UI changes
   - **Testing** — tick platforms and verification items based on the diff; describe test scenarios
   - **Reference Links / Dependencies** — include `$ARGUMENTS` if provided; omit if empty
   - **Checklist** — tick Self-review and Tests/Docs items based on the diff
   - **Merge Rules** — keep the table exactly as-is, do not modify it
6. Return the PR URL

## PR title format

`<emoji> <Type> | <short description>`

| Emoji | Type     | When to use                                      |
|-------|----------|--------------------------------------------------|
| ✨    | Feat     | New functionality (including analytics/tracking) |
| 🐛    | Fix      | Bug fixes                                        |
| ♻️    | Refactor | Restructuring without behavior change            |
| 🚀    | Deploy   | Merge to main (branch: `release/*`)              |
| 🚑️    | Hotfix   | Critical production fixes (branch: `hotfix/*`)   |
| 🔒️    | Sec      | Security fixes or improvements                   |
| 📝    | Docs     | Documentation-only changes                       |
| ⬆️    | Deps     | Dependency upgrades or additions                 |
| ✅    | Test     | Adding/updating tests, no production code change |
