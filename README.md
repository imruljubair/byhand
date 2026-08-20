# byhand

Visual, by-hand explanations of AI systems.

The first release visualizes local GGUF files and Llama 3.2 installed through
Ollama:

```bash
byhand model --ollama llama3.2
byhand model /path/to/model.gguf
```

## Requirements

- macOS
- Apple Silicon (`arm64`)
- A local GGUF file, or the `llama3.2` Ollama model

The current build is unsigned. It is distributed outside the Mac App Store
and has not been notarized by Apple.

## Install

Review the installer before running it:

```bash
curl -fsSL https://raw.githubusercontent.com/imruljubair/byhand/main/install.sh
```

Install the latest release:

```bash
curl -fsSL https://raw.githubusercontent.com/imruljubair/byhand/main/install.sh | sh
```

The default installation location is `/usr/local/bin/byhand`. The installer
asks for administrator permission only when that directory is not writable.

To install without administrator permission:

```bash
mkdir -p "$HOME/.local/bin"
curl -fsSL https://raw.githubusercontent.com/imruljubair/byhand/main/install.sh \
  | BYHAND_INSTALL_DIR="$HOME/.local/bin" sh
```

Add the user installation directory to your shell path if needed:

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zprofile"
source "$HOME/.zprofile"
```

## Use

```bash
# Llama 3.2 installed through Ollama
byhand model --ollama llama3.2

# Local GGUF file
byhand model /path/to/model.gguf

# Help and version
byhand model --help
byhand --version
```

## Update

Run the installer again. It downloads and verifies the latest release before
replacing the existing executable:

```bash
curl -fsSL https://raw.githubusercontent.com/imruljubair/byhand/main/install.sh | sh
```

To install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/imruljubair/byhand/main/install.sh \
  | BYHAND_VERSION=v0.1.0 sh
```

## Uninstall

For the default installation:

```bash
sudo rm /usr/local/bin/byhand
```

For a user installation:

```bash
rm "$HOME/.local/bin/byhand"
```

## Source and releases

This repository contains the public installer and binary releases. The
application source code is maintained separately in a private repository.

Release downloads include `SHA256SUMS`; the installer verifies the archive
before extracting or installing it.

Remote GGUF URLs, additional Ollama model families, and output formats will be
enabled gradually in later tested releases.
