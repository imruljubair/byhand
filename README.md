# byhand

Visual, by-hand explanations of AI systems.

The current release visualizes Llama-family GGUF models from Ollama, local
files, or public remote URLs. Terminal visualization is the default, and the
same interactive model view can be exported as a self-contained HTML file.

```bash
byhand model --ollama llama3.2
byhand model --ollama tinyllama
byhand model /path/to/model.gguf
byhand model --url https://example.com/model.gguf
byhand model --ollama llama3.2 --output html
```

Model availability is determined from GGUF metadata, not the filename,
Ollama repository name, or input source. Llama 3.2, TinyLlama, Llama 2, and
other compatible Llama GGUF models therefore share the same release policy.

## Requirements

- macOS
- Apple Silicon (`arm64`)
- A Llama-family model installed through Ollama, a local GGUF file, or a
  public GGUF URL whose server supports HTTP range requests

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
# Llama-family models installed through Ollama
byhand model --ollama llama3.2
byhand model --ollama tinyllama

# Local GGUF file
byhand model /path/to/model.gguf

# Public remote GGUF file
byhand model --url https://example.com/model.gguf

# Self-contained interactive HTML export
byhand model --ollama llama3.2 --output html

# Help and version
byhand model --help
byhand --version
```

The HTML export contains every model step and Operation Explainer, supports
keyboard and button navigation, and automatically scrolls to keep the active
operation or selected explainer cell visible. It opens directly in a browser
without a web server or external dependencies.

## Update

Run the installer again. It downloads and verifies the latest release before
replacing the existing executable:

```bash
curl -fsSL https://raw.githubusercontent.com/imruljubair/byhand/main/install.sh | sh
```

To install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/imruljubair/byhand/main/install.sh \
  | BYHAND_VERSION=v0.2.0 sh
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

Version 0.2.0 enables terminal and HTML output for the Llama visualization
family across Ollama, local, and remote sources. Other engine-supported model
families will be enabled gradually in later tested releases.
