#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
CREDENTIALS_FILE="${PROJECT_ROOT}/config/credentials.properties"

if [[ ! -f "${CREDENTIALS_FILE}" ]]; then
  echo "Missing ${CREDENTIALS_FILE}" >&2
  echo "Copy config/credentials.properties.example to config/credentials.properties and configure it." >&2
  exit 1
fi

set -a
source "${CREDENTIALS_FILE}"
set +a

if [[ -z "${NOTION_TOKEN:-}" ]]; then
  echo "NOTION_TOKEN is not configured." >&2
  exit 1
fi

exec npx -y @notionhq/notion-mcp-server