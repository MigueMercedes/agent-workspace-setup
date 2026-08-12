#!/usr/bin/env bash
set -euo pipefail
repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
cd "$repo_root"
bash -n install.sh
bash -n skills/agent-workspace-setup/scripts/inspect-project.sh
bash tests/test-inspect-project.sh
bash tests/test-install.sh
bash tests/test-validate-skill.sh
python3 tests/validate-skill.py
