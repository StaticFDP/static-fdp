#!/usr/bin/env bash
set -euo pipefail

# ─── Bootstrap a new Static FDP repository ────────────────────────────────────
#
# Usage:
#   ./setup.sh \
#     --name "my-project" \
#     --title "My Project — FAIR Data Point" \
#     --org "MyOrg" \
#     --publisher "My Working Group" \
#     --publisher-url "https://example.org/" \
#     --domain "fdp.example.org" \
#     --license "https://creativecommons.org/licenses/by/4.0/" \
#     --label "submission" \
#     --output ./my-new-fdp

# ── Defaults ──────────────────────────────────────────────────────────────────
NAME=""
TITLE=""
ORG=""
PUBLISHER=""
PUBLISHER_URL=""
DOMAIN=""
LICENSE="https://creativecommons.org/licenses/by/4.0/"
LABEL="submission"
OUTPUT=""
DATE=$(date +%Y-%m-%d)

usage() {
  cat <<EOF
Usage: $0 [OPTIONS]

Required:
  --name NAME             Short repo name (e.g. "my-project")
  --title TITLE           Human-readable project title
  --org ORG               GitHub organization or user
  --publisher NAME        Publisher organization name
  --publisher-url URL     Publisher website URL
  --domain DOMAIN         Custom domain for GitHub Pages (e.g. fdp.example.org)
  --output DIR            Output directory for the new repository

Optional:
  --license URL           License URL (default: CC-BY-4.0)
  --label LABEL           Primary issue label (default: "submission")
  --date DATE             Issued date (default: today)

Example:
  $0 --name my-fdp --title "My FAIR Data Point" --org MyOrg \\
     --publisher "My Group" --publisher-url https://example.org \\
     --domain fdp.example.org --output ./my-new-fdp
EOF
  exit 1
}

# ── Parse arguments ───────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case "$1" in
    --name)          NAME="$2";          shift 2 ;;
    --title)         TITLE="$2";         shift 2 ;;
    --org)           ORG="$2";           shift 2 ;;
    --publisher)     PUBLISHER="$2";     shift 2 ;;
    --publisher-url) PUBLISHER_URL="$2"; shift 2 ;;
    --domain)        DOMAIN="$2";        shift 2 ;;
    --license)       LICENSE="$2";       shift 2 ;;
    --label)         LABEL="$2";         shift 2 ;;
    --output)        OUTPUT="$2";        shift 2 ;;
    --date)          DATE="$2";          shift 2 ;;
    -h|--help)       usage ;;
    *)               echo "Unknown option: $1"; usage ;;
  esac
done

# ── Validate required arguments ───────────────────────────────────────────────
for var in NAME TITLE ORG PUBLISHER PUBLISHER_URL DOMAIN OUTPUT; do
  if [[ -z "${!var}" ]]; then
    echo "Error: --$(echo $var | tr '[:upper:]' '[:lower:]' | tr '_' '-') is required"
    usage
  fi
done

REPO="${ORG}/${NAME}"
FDP_BASE_URL="https://${DOMAIN}/${NAME}"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE_DIR="${SCRIPT_DIR}/templates"

echo "Bootstrapping Static FDP repository..."
echo "  Name:      ${NAME}"
echo "  Org:       ${ORG}"
echo "  Publisher: ${PUBLISHER}"
echo "  Domain:    ${DOMAIN}"
echo "  Output:    ${OUTPUT}"
echo ""

# ── Create directory structure ────────────────────────────────────────────────
mkdir -p "${OUTPUT}"/{cases,datasets,gaps,metadata/fdp,profiles,scripts,docs/{fdp,datasets},generated/profiles,.github/{workflows,ISSUE_TEMPLATE},worker/src}

# ── Copy ShEx profiles (generic, no customization needed) ─────────────────────
if [[ -d "${SCRIPT_DIR}/../profiles" ]]; then
  cp "${SCRIPT_DIR}/../profiles/"*.shex "${OUTPUT}/profiles/"
  echo "✓ Copied ShEx profiles"
else
  echo "⚠ No profiles/ directory found next to setup.sh — copy manually from the source repo"
fi

# ── Generate catalog.ttl from template ────────────────────────────────────────
sed \
  -e "s|{{FDP_BASE_URL}}|${FDP_BASE_URL}|g" \
  -e "s|{{PROJECT_TITLE}}|${TITLE}|g" \
  -e "s|{{PROJECT_DESCRIPTION}}|FAIR Data Point for ${TITLE}. Contains structured contributions, gap analyses, and community submissions.|g" \
  -e "s|{{CATALOG_TITLE}}|${TITLE} — Catalog|g" \
  -e "s|{{CATALOG_DESCRIPTION}}|Structured contributions and gap analyses collected for ${TITLE}.|g" \
  -e "s|{{DATE}}|${DATE}|g" \
  -e "s|{{LICENSE_URL}}|${LICENSE}|g" \
  -e "s|{{PUBLISHER_NAME}}|${PUBLISHER}|g" \
  -e "s|{{PUBLISHER_URL}}|${PUBLISHER_URL}|g" \
  "${TEMPLATE_DIR}/catalog.ttl" > "${OUTPUT}/metadata/fdp/catalog.ttl"
echo "✓ Generated metadata/fdp/catalog.ttl"

# ── Copy issue templates ──────────────────────────────────────────────────────
sed \
  -e "s|submission|${LABEL}|g" \
  "${TEMPLATE_DIR}/01-contribution.yml" > "${OUTPUT}/.github/ISSUE_TEMPLATE/01-contribution.yml"

sed \
  -e "s|https://example.org/my-project/|${FDP_BASE_URL}/|g" \
  -e "s|https://github.com/MyOrg/my-repo|https://github.com/${REPO}|g" \
  "${TEMPLATE_DIR}/config.yml" > "${OUTPUT}/.github/ISSUE_TEMPLATE/config.yml"
echo "✓ Generated issue templates"

# ── Copy workflow templates ───────────────────────────────────────────────────
for wf in validate.yml publish.yml convert-issues.yml deploy-worker.yml; do
  if [[ "$wf" == "convert-issues.yml" ]]; then
    sed \
      -e "s|'submission'|'${LABEL}'|g" \
      "${TEMPLATE_DIR}/workflows/${wf}" > "${OUTPUT}/.github/workflows/${wf}"
  else
    cp "${TEMPLATE_DIR}/workflows/${wf}" "${OUTPUT}/.github/workflows/${wf}"
  fi
done
echo "✓ Copied GitHub Actions workflows"

# ── Generate wrangler.toml ────────────────────────────────────────────────────
sed \
  -e "s|my-form-receiver|${NAME}-form-receiver|g" \
  -e "s|MyOrg/my-repo|${REPO}|g" \
  -e "s|https://example.org/my-project/|${FDP_BASE_URL}/|g" \
  "${TEMPLATE_DIR}/wrangler.toml" > "${OUTPUT}/worker/wrangler.toml"
echo "✓ Generated worker/wrangler.toml"

# ── Create docs/CNAME for custom domain ───────────────────────────────────────
echo "${DOMAIN}" > "${OUTPUT}/docs/CNAME"
echo "✓ Created docs/CNAME (${DOMAIN})"

# ── Create a minimal .gitignore ───────────────────────────────────────────────
cat > "${OUTPUT}/.gitignore" <<'GITIGNORE'
node_modules/
.env
*.pyc
__pycache__/
GITIGNORE
echo "✓ Created .gitignore"

# ── Create a stub README ─────────────────────────────────────────────────────
cat > "${OUTPUT}/README.md" <<README
# ${TITLE}

A [Static FAIR Data Point](https://staticfdp.github.io/fdp-index/) for **${TITLE}**.

Published at: ${FDP_BASE_URL}/

## Contributing

Submit contributions via [GitHub Issues](https://github.com/${REPO}/issues/new/choose)
or visit the [landing page](${FDP_BASE_URL}/).

## License

Content is licensed under [CC BY 4.0](${LICENSE}).
README
echo "✓ Created README.md"

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "Done! Repository bootstrapped at: ${OUTPUT}"
echo ""
echo "Next steps:"
echo "  1. cd ${OUTPUT}"
echo "  2. git init && git add . && git commit -m 'Initial FDP scaffold'"
echo "  3. gh repo create ${REPO} --public --source . --push"
echo "  4. Copy scripts/issues_to_datasets.py from the source repo and adapt for your domain"
echo "  5. Set repository secrets (see deploy/DEPLOY.md for the full list)"
echo "  6. Push to main — workflows will auto-run"
