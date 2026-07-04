#!/bin/sh

set -eu

APP_NAME="angkrang"
INSTALL_DIR="$HOME/.local/share/$APP_NAME"
BIN_DIR="$HOME/.local/bin"

SCRIPT_BASENAME="$(basename -- "$0")"
SCRIPT_PATH_RESOLVABLE=0
case "$0" in
  */install.sh|install.sh)
    SCRIPT_PATH_RESOLVABLE=1
    ;;
esac

SCRIPT_DIR=""
MANIFEST_FILE=""
LOCAL_BIN_DIR=""
if [ "$SCRIPT_PATH_RESOLVABLE" -eq 1 ]; then
  SCRIPT_PATH="$(readlink -f -- "$0" 2>/dev/null || printf '%s\n' "$0")"
  SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$SCRIPT_PATH")" && pwd)"
  MANIFEST_FILE="$SCRIPT_DIR/MANIFEST.txt"
  LOCAL_BIN_DIR="$SCRIPT_DIR/bin"
fi
MANIFEST_TMP=""
REMOTE_TMPDIR=""

ACTION="install"
DRY_RUN=0

usage() {
  cat <<'EOF'
Usage: install.sh [--check|--install|--uninstall] [--dry-run]

  --check      validate the local package contents
  --install    install the package (default)
  --uninstall  remove the installed package
  --dry-run    show what would change without modifying files
EOF
}

print_cmd() {
  printf '+'
  for arg in "$@"; do
    printf ' %s' "$arg"
  done
  printf '\n'
}

run_cmd() {
  if [ "$DRY_RUN" -eq 1 ]; then
    print_cmd "$@"
  else
    "$@"
  fi
}

error_with_tip() {
  title="$1"
  path="${2:-}"
  tip="${3:-}"

  printf '%s\n' "$title" >&2
  if [ -n "$path" ]; then
    printf '  path: %s\n' "$path" >&2
  fi
  if [ -n "$tip" ]; then
    printf '  tip: %s\n' "$tip" >&2
  fi
}

default_manifest() {
  cat <<'EOF'
bin
bin/angkrang
bin/angkrang-doctor
bin/angkrang-pi
docker
shared
config
scripts
assets
docs
install.sh
README.md
LICENSE
VERSION
MANIFEST.txt
EOF
}

prepare_manifest_file() {
  if [ -s "$MANIFEST_FILE" ]; then
    printf '%s\n' "$MANIFEST_FILE"
    return 0
  fi

  MANIFEST_TMP="$(mktemp)"
  default_manifest > "$MANIFEST_TMP"
  printf '%s\n' "$MANIFEST_TMP"
}

copy_entry() {
  src="$1"
  dst="$2"

  if [ -d "$src" ]; then
    run_cmd mkdir -p "$dst"
    run_cmd cp -R "$src"/. "$dst"
    return 0
  fi

  run_cmd mkdir -p "$(dirname -- "$dst")"
  run_cmd cp "$src" "$dst"
}

manifest_count() {
  manifest_path="$1"
  count=0

  while IFS= read -r entry; do
    case "$entry" in
      ""|\#*) continue ;;
    esac

    count=$((count + 1))
  done < "$manifest_path"

  printf '%s\n' "$count"
}

print_manifest_items() {
  manifest_path="$1"

  while IFS= read -r entry; do
    case "$entry" in
      ""|\#*) continue ;;
    esac

    printf '  - %s\n' "$entry"
  done < "$manifest_path"
}

print_install_preview() {
  manifest_path="$1"
  total_items="$(manifest_count "$manifest_path")"

  echo "Dry run summary"
  echo "  source:   $SCRIPT_DIR"
  echo "  install:  $INSTALL_DIR"
  echo "  bin dir:  $BIN_DIR"
  echo "  items:    $total_items"
  echo
  echo "Would copy:"
  print_manifest_items "$manifest_path"
  echo
  echo "Would create symlinks:"
  echo "  - $BIN_DIR/angkrang -> $INSTALL_DIR/bin/angkrang"
  echo "  - $BIN_DIR/angkrang-doctor -> $INSTALL_DIR/bin/angkrang-doctor"
  echo "  - $BIN_DIR/angkrang-pi -> $INSTALL_DIR/bin/angkrang-pi"
}

print_uninstall_preview() {
  echo "Dry run summary"
  echo "  source:   $SCRIPT_DIR"
  echo "  install:  $INSTALL_DIR"
  echo "  bin dir:  $BIN_DIR"
  echo
  echo "Would remove:"
  echo "  - $BIN_DIR/angkrang"
  echo "  - $BIN_DIR/angkrang-doctor"
  echo "  - $BIN_DIR/angkrang-pi"
  echo "  - $INSTALL_DIR"
}

validate_manifest() {
  manifest_path="$1"

  while IFS= read -r entry; do
    case "$entry" in
      ""|\#*) continue ;;
    esac

    src="$SCRIPT_DIR/$entry"
    if [ ! -e "$src" ]; then
      error_with_tip \
        "angkrang install error: required file not found" \
        "$src" \
        "reinstall from a complete working tree or use the release tarball"
      exit 1
    fi
  done < "$manifest_path"
}

install_local() {
  manifest_path="$(prepare_manifest_file)"
  validate_manifest "$manifest_path"

  if [ "$DRY_RUN" -eq 1 ]; then
    print_install_preview "$manifest_path"
    return 0
  fi

  run_cmd mkdir -p "$INSTALL_DIR" "$BIN_DIR"

  while IFS= read -r entry; do
    case "$entry" in
      ""|\#*) continue ;;
    esac

    src="$SCRIPT_DIR/$entry"
    dst="$INSTALL_DIR/$entry"
    copy_entry "$src" "$dst"
  done < "$manifest_path"

  run_cmd ln -sf "$INSTALL_DIR/bin/angkrang" "$BIN_DIR/angkrang"
  run_cmd ln -sf "$INSTALL_DIR/bin/angkrang-doctor" "$BIN_DIR/angkrang-doctor"
  run_cmd ln -sf "$INSTALL_DIR/bin/angkrang-pi" "$BIN_DIR/angkrang-pi"

  echo "Installing $APP_NAME to $INSTALL_DIR..."
  echo "$APP_NAME installed successfully."
  echo
  echo "Make sure this is in your PATH:"
  echo "  $HOME/.local/bin"
  echo
  echo "Add this to your shell profile if needed:"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
  echo
  echo "Run with:"
  echo "  angkrang doctor"
  echo "  angkrang pi"
  echo "  angkrang uninstall"
}

uninstall_local() {
  if [ "$DRY_RUN" -eq 1 ]; then
    print_uninstall_preview
    return 0
  fi

  if [ ! -e "$INSTALL_DIR" ] && \
     [ ! -L "$BIN_DIR/angkrang" ] && \
     [ ! -L "$BIN_DIR/angkrang-doctor" ] && \
     [ ! -L "$BIN_DIR/angkrang-pi" ]; then
    echo "$APP_NAME is already removed."
    return 0
  fi

  run_cmd rm -f "$BIN_DIR/angkrang" "$BIN_DIR/angkrang-doctor" "$BIN_DIR/angkrang-pi"

  run_cmd rm -rf "$INSTALL_DIR"

  echo "$APP_NAME uninstalled successfully."
}

check_local() {
  manifest_path="$(prepare_manifest_file)"
  validate_manifest "$manifest_path"

  echo "Check OK"
  echo "  source:   $SCRIPT_DIR"
  echo "  manifest:  $manifest_path"
  echo "  install:   $INSTALL_DIR"
  echo "  binaries:  $BIN_DIR"
}

cleanup() {
  if [ -n "$MANIFEST_TMP" ] && [ -e "$MANIFEST_TMP" ]; then
    rm -f "$MANIFEST_TMP"
  fi

  if [ -n "$REMOTE_TMPDIR" ] && [ -d "$REMOTE_TMPDIR" ]; then
    rm -rf "$REMOTE_TMPDIR"
  fi
}

install_from_tarball() {
  tarball_url="${TARBALL_URL:-}"

  if [ -z "$tarball_url" ] && [ -n "${GITHUB_REPOSITORY:-}" ]; then
    if [ -n "${VERSION:-}" ]; then
      tarball_url="https://github.com/${GITHUB_REPOSITORY}/releases/download/v${VERSION}/${APP_NAME}-${VERSION}.tar.gz"
    else
      tarball_url="https://github.com/${GITHUB_REPOSITORY}/releases/latest/download/${APP_NAME}.tar.gz"
    fi
  fi

  if [ -z "$tarball_url" ]; then
    error_with_tip \
      "angkrang install error: no local files found and no remote source configured" \
      "" \
      "set TARBALL_URL or GITHUB_REPOSITORY, then try again"
    exit 1
  fi

  if ! command -v curl >/dev/null 2>&1; then
    error_with_tip \
      "angkrang install error: curl is required for remote install" \
      "" \
      "install curl and try again"
    exit 1
  fi

  tmpdir="$(mktemp -d)"
  REMOTE_TMPDIR="$tmpdir"

  archive="$tmpdir/$APP_NAME.tar.gz"
  curl -fsSL "$tarball_url" -o "$archive"

  pkgdir_name="$(tar -tzf "$archive" | head -n 1 | cut -d/ -f1)"
  if [ -z "$pkgdir_name" ]; then
    error_with_tip \
      "angkrang install error: downloaded archive is empty or invalid" \
      "$archive" \
      "verify the release tarball URL and try again"
    exit 1
  fi

  tar -xzf "$archive" -C "$tmpdir"
  pkgdir="$tmpdir/$pkgdir_name"

  if [ ! -x "$pkgdir/install.sh" ]; then
    error_with_tip \
      "angkrang install error: downloaded archive does not contain install.sh" \
      "$pkgdir/install.sh" \
      "download a full angkrang release tarball"
    exit 1
  fi

  cd "$pkgdir"
  ./install.sh "$@"
}

while [ $# -gt 0 ]; do
  case "$1" in
    --check)
      ACTION=check
      ;;
    --install)
      ACTION=install
      ;;
    --uninstall)
      ACTION=uninstall
      ;;
    --dry-run)
      DRY_RUN=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    --)
      shift
      break
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [ $# -gt 0 ]; then
  echo "Unexpected arguments: $*" >&2
  usage >&2
  exit 1
fi

trap cleanup EXIT INT HUP TERM

case "$SCRIPT_BASENAME" in
  install.sh)
    if [ -n "$LOCAL_BIN_DIR" ] && [ -d "$LOCAL_BIN_DIR" ]; then
      :
    else
      set --
      case "$ACTION" in
        check)
          set -- --check
          ;;
        uninstall)
          set -- --uninstall
          ;;
      esac
      if [ "$DRY_RUN" -eq 1 ]; then
        set -- "$@" --dry-run
      fi
      install_from_tarball "$@"
      exit 0
    fi
    ;;
  *)
    set --
    case "$ACTION" in
      check)
        set -- --check
        ;;
      uninstall)
        set -- --uninstall
        ;;
    esac
    if [ "$DRY_RUN" -eq 1 ]; then
      set -- "$@" --dry-run
    fi
    install_from_tarball "$@"
    exit 0
    ;;
esac

case "$ACTION" in
  install)
    install_local
    ;;
  uninstall)
    uninstall_local
    ;;
  check)
    check_local
    ;;
esac
