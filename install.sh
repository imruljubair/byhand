#!/bin/sh
set -eu

repository="imruljubair/byhand"
asset="byhand-macos-arm64.tar.gz"
download_root=${BYHAND_DOWNLOAD_BASE:-"https://github.com/$repository/releases"}
install_dir=${BYHAND_INSTALL_DIR:-"/usr/local/bin"}

if [ "$(uname -s)" != "Darwin" ]; then
    echo "error: byhand currently supports macOS only" >&2
    exit 1
fi

if [ "$(uname -m)" != "arm64" ]; then
    echo "error: byhand currently supports Apple Silicon Macs only" >&2
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "error: curl is required" >&2
    exit 1
fi

if ! command -v shasum >/dev/null 2>&1; then
    echo "error: shasum is required" >&2
    exit 1
fi

temporary_dir=$(mktemp -d "${TMPDIR:-/tmp}/byhand-install.XXXXXX")
cleanup() {
    rm -rf "$temporary_dir"
}
trap cleanup EXIT HUP INT TERM

if [ -n "${BYHAND_VERSION:-}" ]; then
    release_url="$download_root/download/$BYHAND_VERSION"
else
    release_url="$download_root/latest/download"
fi

echo "Downloading byhand for Apple Silicon..."
curl -fsSL --retry 3 --connect-timeout 10 \
    "$release_url/$asset" \
    -o "$temporary_dir/$asset"
curl -fsSL --retry 3 --connect-timeout 10 \
    "$release_url/SHA256SUMS" \
    -o "$temporary_dir/SHA256SUMS"

expected_checksum=$(
    awk -v asset="$asset" '$2 == asset { print $1 }' \
        "$temporary_dir/SHA256SUMS"
)
if [ -z "$expected_checksum" ]; then
    echo "error: $asset is missing from SHA256SUMS" >&2
    exit 1
fi

actual_checksum=$(
    shasum -a 256 "$temporary_dir/$asset" | awk '{ print $1 }'
)
if [ "$actual_checksum" != "$expected_checksum" ]; then
    echo "error: checksum verification failed" >&2
    exit 1
fi
echo "Checksum verified."

archive_contents=$(tar -tzf "$temporary_dir/$asset")
if [ "$archive_contents" != "byhand" ]; then
    echo "error: release archive has unexpected contents" >&2
    exit 1
fi
tar -xzf "$temporary_dir/$asset" -C "$temporary_dir"
chmod 755 "$temporary_dir/byhand"

if [ -d "$install_dir" ] && [ -w "$install_dir" ]; then
    install -m 755 "$temporary_dir/byhand" "$install_dir/byhand"
else
    if ! command -v sudo >/dev/null 2>&1; then
        echo "error: $install_dir is not writable and sudo is unavailable" >&2
        echo "Set BYHAND_INSTALL_DIR to a writable directory and try again." >&2
        exit 1
    fi
    echo "Installing to $install_dir requires administrator permission."
    sudo mkdir -p "$install_dir"
    sudo install -m 755 "$temporary_dir/byhand" "$install_dir/byhand"
fi

installed_version=$($install_dir/byhand --version)
echo "Installed $installed_version at $install_dir/byhand"

case ":${PATH:-}:" in
    *:"$install_dir":*) ;;
    *)
        echo ""
        echo "Add $install_dir to PATH before running byhand:"
        echo "  export PATH=\"$install_dir:\$PATH\""
        ;;
esac

if [ -t 1 ]; then
    echo ""
    if ! "$install_dir/byhand"; then
        echo "Run: byhand model --ollama llama3.2"
    fi
else
    echo "Run: byhand model --ollama llama3.2"
fi
