# Environment variables (names only)

This repo stores real secrets outside Git:

- Put real values into the local file `.env` (repo root). This file is ignored by git.
- Do not put secrets into any committed file.

## Variables

### `GITHUB_TOKEN` (optional)

Used by repository scripts to automate GitHub actions (for example creating or merging PRs) when GitHub CLI (`gh`) is not available.

