#!/usr/bin/env bash
# Troubleshooting fault: turn the SELinux boolean off persistently.
setsebool -P "$SBOOL" off >/dev/null 2>&1
echo "SYMPTOM: SELinux boolean '$SBOOL' is off, so the service it controls is being denied by SELinux"
