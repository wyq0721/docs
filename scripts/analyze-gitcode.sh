#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'EOF'
Usage: analyze-gitcode.sh <owner/repo> [branch] [target_dir]

Clone a GitCode repository into the sandbox and print a quick analysis index
that helps the agent continue reading the codebase with local tools.

Environment variables for private repositories:
  GITCODE_USER   GitCode username
  GITCODE_TOKEN  GitCode personal access token with read_repository
EOF
}

if [ "${1:-}" = "-h" ] || [ "${1:-}" = "--help" ]; then
  usage
  exit 0
fi

REPO="${1:-}"
BRANCH="${2:-main}"
TARGET_DIR="${3:-}"

if [ -z "$REPO" ]; then
  usage >&2
  exit 1
fi

case "$REPO" in
  */*) ;;
  *)
    echo "Invalid repo path: $REPO (expected owner/repo)" >&2
    exit 1
    ;;
esac

if [ -z "$TARGET_DIR" ]; then
  TARGET_DIR="/tmp/gitcode-analysis/${REPO##*/}"
fi

case "$TARGET_DIR" in
  /tmp/*) ;;
  *)
    echo "target_dir must stay under /tmp in the sandbox: $TARGET_DIR" >&2
    exit 1
    ;;
esac

if [ -n "${GITCODE_USER:-}" ] && [ -z "${GITCODE_TOKEN:-}" ]; then
  echo "GITCODE_TOKEN is required when GITCODE_USER is set." >&2
  exit 1
fi

if [ -n "${GITCODE_TOKEN:-}" ] && [ -z "${GITCODE_USER:-}" ]; then
  echo "GITCODE_USER is required when GITCODE_TOKEN is set." >&2
  exit 1
fi

CLONE_URL="https://gitcode.com/${REPO}.git"
if [ -n "${GITCODE_USER:-}" ] && [ -n "${GITCODE_TOKEN:-}" ]; then
  CLONE_URL="https://${GITCODE_USER}:${GITCODE_TOKEN}@gitcode.com/${REPO}.git"
fi

rm -rf "$TARGET_DIR"
mkdir -p "$(dirname "$TARGET_DIR")"

if ! git clone --depth 1 --branch "$BRANCH" "$CLONE_URL" "$TARGET_DIR"; then
  cat <<EOF >&2
Failed to clone gitcode.com/${REPO}@${BRANCH}

Common causes:
  - the sandbox cannot resolve or reach gitcode.com
  - the repository is private and GITCODE_USER/GITCODE_TOKEN are missing
  - the branch name is incorrect

See /home/runner/work/docs/docs/gitcode-pull-guide.md for troubleshooting.
EOF
  exit 1
fi

echo "Cloned to: $TARGET_DIR"
echo "Repository: $REPO"
echo "Branch: $BRANCH"
echo

echo "Top-level entries:"
find "$TARGET_DIR" -mindepth 1 -maxdepth 1 -printf '  - %f\n' | sort
echo

README_FILES="$(find "$TARGET_DIR" -maxdepth 2 -type f \( -iname 'README' -o -iname 'README.*' \) | sort || true)"
if [ -n "$README_FILES" ]; then
  echo "README files:"
  while IFS= read -r file; do
    [ -n "$file" ] && echo "  - $file"
  done <<EOF
$README_FILES
EOF
  echo
fi

MANIFESTS=(
  package.json
  pnpm-lock.yaml
  pnpm-workspace.yaml
  yarn.lock
  package-lock.json
  requirements.txt
  pyproject.toml
  Pipfile
  go.mod
  Cargo.toml
  pom.xml
  build.gradle
  build.gradle.kts
  composer.json
  Gemfile
  Makefile
  Dockerfile
)

echo "Common manifests:"
found_manifest=0
for manifest in "${MANIFESTS[@]}"; do
  if [ -f "$TARGET_DIR/$manifest" ]; then
    echo "  - $TARGET_DIR/$manifest"
    found_manifest=1
  fi
done
if [ "$found_manifest" -eq 0 ]; then
  echo "  - none detected at repository root"
fi
echo

echo "Common source directories:"
found_source_dir=0
for dir in src app cmd pkg lib packages modules backend frontend server client test tests docs; do
  if [ -d "$TARGET_DIR/$dir" ]; then
    echo "  - $TARGET_DIR/$dir"
    found_source_dir=1
  fi
done
if [ "$found_source_dir" -eq 0 ]; then
  echo "  - none detected from the default directory set"
fi
echo

echo "File extension summary (top 15):"
find "$TARGET_DIR" -type f \
  | awk '
      {
        n = split($0, parts, "/");
        name = parts[n];
        if (name ~ /^\.[^.]+$/) {
          ext = "[no extension]";
        } else if (name ~ /\./) {
          sub(/^.*\./, "", name);
          ext = name;
        } else {
          ext = "[no extension]";
        }
        count[ext]++;
      }
      END {
        for (ext in count) {
          printf "%7d %s\n", count[ext], ext;
        }
      }
    ' \
  | sort -nr \
  | head -n 15 \
  | sed 's/^/  - /'
echo

cat <<EOF
Next steps for the agent:
  1. Read the README from the cloned path above.
  2. Inspect root manifests to infer the tech stack.
  3. Use rg/view inside $TARGET_DIR for architecture, entrypoints, and build/test commands.
EOF
