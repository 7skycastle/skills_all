---
name: kwansang-finish-deploy
description: Push and redeploy the KwanSang project when wrapping up work in the linked local repo. Use when the user asks to finish, wrap up, git push, redeploy, deploy, or wants an end-of-conversation deployment trigger for this project.
---

# KwanSang Finish Deploy

Use this skill for the KwanSang project when the user wants the current work finalized with Git push and Vercel production deploy.

Important limitation: there is no reliable automatic "conversation ended" event in Codex. Treat wrap-up phrases such as `finish`, `wrap up`, `end chat`, `deploy too`, `git push redeploy`, or similar requests as the trigger to run this skill.

## Workflow

1. Work from the linked KwanSang repository for the current session.
2. Check `git status --short --branch`.
3. If the tree is dirty, review the changes and commit them when the user has already requested finish/push/deploy in the same task. Do not silently discard or skip user work.
4. Run a quick local verification that matches the project shape:
   - confirm `index.html` is the intended main entry point
   - if a local server is available, verify the page renders
5. Push the current branch to `origin`.
6. Run `scripts\finish_deploy.ps1` to perform the deterministic push/deploy/inspect sequence after the tree is clean.
7. Report the branch, commit, deployment URL, inspect summary, and final git status.

## Script

Use `scripts\finish_deploy.ps1` after the desired commit already exists.

Example:

```powershell
& C:\Users\7skyc\.codex\skills\kwansang-finish-deploy\scripts\finish_deploy.ps1
```

By default the script refuses to continue when the working tree is dirty. Pass `-AllowDirty` only when the user explicitly wants deployment without committing.
