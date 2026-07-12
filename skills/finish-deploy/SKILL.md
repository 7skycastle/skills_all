---
name: finish-deploy
description: Push and redeploy the K_study app at the end of a work session. Use when the user says to finish, wrap up, git push, redeploy, deploy, run final checks, or asks for automatic end-of-conversation deployment for this project.
---

# Finish Deploy

Use this skill for the K_study project when the user wants the session wrapped up with Git push, Vercel production redeploy, and verification.

Important limitation: there is no reliable automatic "conversation ended" event. Treat user phrases such as "마무리", "대화 종료", "깃푸시 리디플로이", "끝내줘", or "배포까지" as the trigger.

## Workflow

1. Work from `C:\Users\7skyc\Desktop\anti\K_study` unless the user gives another path.
2. Check `git status --short --branch`.
3. If there are uncommitted changes, do not silently push. Ask whether to commit them, or commit only when the user already asked for commit/push/deploy as part of the same task.
4. Run final local checks before deployment when code changed:
   - `npm run lint`
   - `npm run build`
   - `npm run test:e2e`
   - `npm run test:impersonation-browser`
5. Push the current branch or `main` as appropriate.
6. Redeploy production:
   - `npx vercel redeploy https://k-study.vercel.app --target production`
7. Inspect the production alias:
   - `npx vercel inspect https://k-study.vercel.app`
8. Run production verification:
   - `npm run check:post-deploy`
9. Report the final deployment id, production URL, checks, and git status.

## Script

Use `scripts/finish_deploy.ps1` for the deterministic push/redeploy/check sequence after the working tree is clean and the desired commits already exist.

Example:

```powershell
& C:\Users\7skyc\.codex\skills\finish-deploy\scripts\finish_deploy.ps1
```

The script refuses to continue when the working tree is dirty unless `-AllowDirty` is passed. Prefer keeping the default refusal.
