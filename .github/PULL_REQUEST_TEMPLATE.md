## 🎯 Why?

> Describe the problem being solved and why this change is necessary.

## 🏷️ Type of Change

- [ ] 🐞 Bugfix (non-breaking change that fixes an issue)
- [ ] 💚 Improvement (non-breaking change that adds/modifies features to existing functionality)
- [ ] ⚡️ New feature (non-breaking change that adds functionality)
- [ ] ⚠️ Breaking change (change that is not backwards compatible and/or changes current functionality)

## 📦 What Changed?

> Describe the layers, classes, entities, etc. that the PR modifies.
> If possible, add details about how it was implemented, attaching screenshots or designs for better understanding.

---

## 📷 Screenshots *(required for UI changes)*

| Before   | After   |
|----------|---------|
| Image    | Image   |

## 🧪 Testing *(required for code changes)*

### 📱 Platforms Tested

- [ ] 🤖 Android
- [ ] 🍎 iOS
- [ ] 🌐 Web
- [ ] 🖥️ Desktop

### ✔️ Verification

- [ ] Unit tests pass
- [ ] Widget tests pass
- [ ] Integration tests pass
- [ ] Manual testing completed

### 📝 Test Scenarios

> Describe what you manually verified.

## 🔗 Reference Links *(optional)*

> Documentation links, Figma, Jira tasks, etc.

## 🔄 Dependencies *(optional)*

> List related PRs, backend changes, feature flags, migrations, or deployment requirements.

---

## ✅ Checklist

- [ ] Self-review completed
- [ ] Tests added/updated
- [ ] Documentation updated (if needed)
- [ ] Labels added
- [ ] Reviewers assigned

## 🔀 Merge Rules

|            Pull Request            |  Merge Type  |
|:----------------------------------:|:------------:|
|    *feature/fix/etc* → develop     | SQUASH MERGE |
| *feature/hotfix/fix/etc* → release | SQUASH MERGE |
|          *hotfix* → main           | SQUASH MERGE |
|          *release* → main          | MERGE COMMIT |
|        *backport* → develop        | MERGE COMMIT |