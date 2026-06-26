# Security Policy

## Supported Versions

| Version | Supported |
|---|---|
| latest | ✓ |

## Reporting a Vulnerability

Please **do not** open a public GitHub issue for security vulnerabilities.

Report vulnerabilities privately via GitHub's Security Advisory feature:
https://github.com/LangeVC/envctl/security/advisories/new

We will respond within 72 hours.

## Security Notes

- Cluster files (`~/.config/envctl/*.env`) contain plaintext secrets — protect them:
  ```bash
  chmod 700 ~/.config/envctl
  chmod 600 ~/.config/envctl/*.env
  ```
- Add `~/.config/envctl/` to your global `.gitignore`
- envctl never transmits secrets — all operations are local
- The LaunchAgent runs only at login with user-level permissions
