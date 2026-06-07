# powerflix

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

# 🌿 Gitflow Strategy

This project follows a structured Gitflow to ensure safe, predictable releases.

## Branch Model

| Branch | Purpose | Created From | Merges Into |
|---|---|---|---|
| `main` | Production code | — | — |
| `develop` | Integration branch | `main` | — |
| `feature/*` | New features | `develop` | `develop` |
| `fix/*` | Bug fixes | `develop` | `develop` |
| `refactor/*` | Code refactoring | `develop` | `develop` |
| `chore/*` | Maintenance tasks | `develop` | `develop` |
| `doc/*` | Documentation | `develop` | `develop` |
| `release/vX.X.X` | Release preparation | `develop` | `main` + `develop` |
| `hotfix/*` | Critical production fixes | `main` | `main` + `develop` |

## Rules

- ✅ PRs to `main` → only from `release/vX.X.X` or `hotfix/*`
- ✅ PRs to `develop` → only from `feature/*`, `fix/*`, `refactor/*`, `chore/*`, `doc/*`
- ✅ `release/vX.X.X` branches → only created from `develop`
- ✅ After merging `release` or `hotfix` into `main` → back-merge into `develop`
- ✅ Every merge into `main` → tagged as `vX.X.X`

## Diagram

```mermaid
gitGraph
   commit id: "init"

   branch develop
   checkout develop
   commit id: "setup"

   branch feature/login
   checkout feature/login
   commit id: "add login"
   commit id: "add tests"
   checkout develop
   merge feature/login id: "PR: feature/login"

   branch fix/auth-bug
   checkout fix/auth-bug
   commit id: "fix token"
   checkout develop
   merge fix/auth-bug id: "PR: fix/auth-bug"

   branch release/v1.0.0
   checkout release/v1.0.0
   commit id: "bump version"
   checkout main
   merge release/v1.0.0 id: "v1.0.0" tag: "v1.0.0"
   checkout develop
   merge release/v1.0.0 id: "back-merge v1.0.0"

   branch hotfix/critical-crash
   checkout hotfix/critical-crash
   commit id: "patch crash"
   checkout main
   merge hotfix/critical-crash id: "v1.0.1" tag: "v1.0.1"
   checkout develop
   merge hotfix/critical-crash id: "back-merge hotfix"
` `` `

## Naming Conventions

Branch names must follow these patterns:

` ``
feature/short-description
fix/short-description
refactor/short-description
chore/short-description
doc/short-description
release/v1.2.3
hotfix/short-description
` ``

> ❌ Invalid: `my-branch`, `Feature-Login`, `fix_auth`
> ✅ Valid: `feature/user-auth`, `fix/token-expiry`, `release/v2.1.0`
```

---

You can drop this directly into your `CONTRIBUTING.md` or `README.md`. The Mermaid diagram renders natively on GitHub — no plugins needed.
