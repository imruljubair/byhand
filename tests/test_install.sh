#!/bin/sh
set -eu

repository_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
temporary_dir=$(mktemp -d "${TMPDIR:-/tmp}/byhand-install-test.XXXXXX")
cleanup() {
    rm -rf "$temporary_dir"
}
trap cleanup EXIT HUP INT TERM

download_dir="$temporary_dir/downloads/releases/latest/download"
install_dir="$temporary_dir/install"
mkdir -p "$download_dir" "$install_dir"

printf '%s\n' \
    '#!/bin/sh' \
    'if [ "${1:-}" = "--version" ]; then' \
    '    echo "byhand 0.1.0-test"' \
    '    exit 0' \
    'fi' \
    'exit 0' > "$temporary_dir/byhand"
chmod 755 "$temporary_dir/byhand"
tar -C "$temporary_dir" -czf \
    "$download_dir/byhand-macos-arm64.tar.gz" byhand
(
    cd "$download_dir"
    shasum -a 256 byhand-macos-arm64.tar.gz > SHA256SUMS
)

BYHAND_DOWNLOAD_BASE="file://$temporary_dir/downloads/releases" \
BYHAND_INSTALL_DIR="$install_dir" \
    sh "$repository_dir/install.sh"

installed_version=$($install_dir/byhand --version)
if [ "$installed_version" != "byhand 0.1.0-test" ]; then
    echo "unexpected installed version: $installed_version" >&2
    exit 1
fi

printf 'corruption' >> "$download_dir/byhand-macos-arm64.tar.gz"
if BYHAND_DOWNLOAD_BASE="file://$temporary_dir/downloads/releases" \
    BYHAND_INSTALL_DIR="$install_dir" \
    sh "$repository_dir/install.sh" >/dev/null 2>&1; then
    echo "installer accepted a corrupted archive" >&2
    exit 1
fi

echo "installer tests passed"
