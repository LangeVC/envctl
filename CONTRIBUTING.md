# Contributing to envctl

Thank you for your interest in contributing!

## Development

envctl is a single Bash script — no build step required.

```bash
git clone https://github.com/Capacium/envctl
cd envctl
chmod +x bin/envctl
bin/envctl version
```

## Guidelines

- Keep the script POSIX-compatible where possible (bash 3.2+ for macOS compat)
- Run `shellcheck bin/envctl` before submitting — CI enforces this
- Test on both macOS and Linux if you can
- Keep it small — no external dependencies

## Testing

```bash
# Run tests locally
mkdir -p /tmp/envctl-test
ENVCTL_DIR=/tmp/envctl-test bin/envctl set ai TEST=hello
ENVCTL_DIR=/tmp/envctl-test bin/envctl get ai TEST
ENVCTL_DIR=/tmp/envctl-test bin/envctl rm ai TEST
```

## Pull Requests

- One PR per feature or fix
- Describe the problem and solution in the PR description
- Update README if adding new commands or behavior

## Reporting Bugs

Open an issue at https://github.com/Capacium/envctl/issues — include OS, shell version, and the exact command that failed.
