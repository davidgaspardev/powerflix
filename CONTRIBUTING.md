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
```

## Naming Conventions

Branch names must follow these patterns:

```bash
feature/short-description
fix/short-description
refactor/short-description
chore/short-description
doc/short-description
release/v1.2.3
hotfix/short-description
```

> ❌ Invalid: `my-branch`, `Feature-Login`, `fix_auth`
> ✅ Valid: `feature/user-auth`, `fix/token-expiry`, `release/v2.1.0`