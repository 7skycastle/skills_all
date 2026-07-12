# skills_all

This repository tracks the portable, user-managed Codex skill setup from my local machine.

## Contents

- `skills/`: copied skill folders from `C:\Users\7skyc\.codex\skills`
- `manifests/installed-skills.txt`: installed skill names snapshot
- `manifests/codex-config-redacted.toml`: redacted Codex config focused on skill and plugin state
- `manifests/ponytail-plugin-status.txt`: Ponytail plugin install status snapshot

## Notes

- Internal system-managed `.system` skills are excluded.
- Runtime caches, sessions, logs, auth, and SQLite state are excluded.
- This repo is intended as a reconstruction source, not a full backup of `~/.codex`.
