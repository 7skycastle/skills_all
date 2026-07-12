---
name: kwansang-auto-wrapup
description: Finalize the local KwanSang project with a last verification pass, intentional git commit, git push, and Vercel production redeploy. Use when the user says to finish up, wrap up, end the session, git push, redeploy, deploy, or wants the current KwanSang work published before the conversation ends.
---

# Kwansang Auto Wrapup

Use this skill when the current KwanSang session should be wrapped cleanly and published.

There is no reliable automatic "conversation ended" event in Codex, so treat wrap-up phrases from the user as the trigger to run this skill.

## Workflow

1. Work in the KwanSang repo at:
   `C:\Users\7skyc\Desktop\Codex\관상\doctor_face_montage_v20_asset_alignment_kit\doctor_face_montage_v20_asset_alignment_kit`
2. Check `git status --short --branch` and review all changed files.
3. Run a final local verification that matches the work:
   - verify `index.html` is still the intended main entry point
   - verify the current male/female flow in a local browser when face work changed
   - verify the result page still opens when the session touched creator flow
4. If there are temporary debugging artifacts that should not ship, remove them before commit.
5. If user-facing work is complete, create one intentional commit that summarizes the shipped change.
6. Push the current branch to `origin`.
7. Run:

```powershell
& C:\Users\7skyc\.codex\skills\kwansang-finish-deploy\scripts\finish_deploy.ps1
```

8. Report:
   - branch
   - commit hash
   - deployment URL
   - whether local verification passed
   - final git status

## Guardrails

- Do not claim wrap-up is complete unless local verification and deploy both succeeded.
- Do not deploy with a dirty tree unless the user explicitly wants that.
- Do not discard untracked files until they have been reviewed as either intended deliverables or temporary artifacts.
- If Vercel output or inspect output is unclear, surface the exact problem and stop before claiming success.
