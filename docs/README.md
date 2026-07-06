# Angkrang Documentation

Angkrang is a small CLI that helps a local AI coding assistant understand and
validate its working environment.

## Purpose

Angkrang focuses on three things:

- preparing a consistent local environment
- checking environment health with `angkrang doctor`
- running the Pi sandbox with `angkrang pi`

## Requirements

- `mise`
- `docker` with Compose support
- WSL is supported for the `codex` stub use case

## Install

Install from the repository checkout:

```bash
./install.sh
```

Supported flags:

```bash
./install.sh --check
./install.sh --install
./install.sh --uninstall
./install.sh --dry-run
```

Default install locations:

- binaries: `~/.local/bin`
- data: `~/.local/share/angkrang`

You can also use the repo task runner:

```bash
mise run install
mise run check
```

## Commands

### `angkrang doctor`

Prints an environment report and checks commonly used tools:

- `rg`
- `fd`
- `jq`
- `yq`
- `fzf`
- `bat`
- `tree`
- `shellcheck`
- `shfmt`
- `hyperfine`
- `htop`
- `psql`
- `redis-cli`
- `sqlite3`

It also reports `mise` and Docker status.

### `angkrang pi`

Starts the Pi sandbox in Docker.

Doctor mode is available too:

```bash
angkrang pi doctor
```

Useful environment variables:

- `ANGKRANG_PI_DOCKERFILE`
- `ANGKRANG_PI_BUILD_CONTEXT`
- `ANGKRANG_VERSIONS_FILE`
- `ANGKRANG_MISE_CONFIG_HOST`
- `ANGKRANG_DOCTOR_HOST`
- `ANGKRANG_PI_IMAGE`
- `ANGKRANG_PI_CONTAINER`

Build args used by the sandbox Docker build:

- `NODE_IMAGE_TAG`
- `NODE_IMAGE_DIGEST`

### `angkrang uninstall`

Removes the installed binaries and local data.

## Task Runner

`mise.toml` exposes the same operations as repo tasks:

- `mise run doctor`
- `mise run pi`
- `mise run install`
- `mise run uninstall`
- `mise run check`
- `mise run build`
- `mise run release`
- `mise run clean`

## Packaging

Release archives are built from the current repo contents and include the files
listed in `MANIFEST.txt`.

The package flow is:

1. `make package`
2. copy the release files into `angkrang-<version>/`
3. create `angkrang-<version>.tar.gz`
4. remove the staging directory

`mise run build` and `mise run release` both point at the same packaging flow.

## Repository Layout

Key paths in this repository:

- `bin/` - user-facing command entrypoints
- `docker/` - sandbox Dockerfiles and pinned versions
- `config/` - mise configuration
- `scripts/` - helper scripts
- `assets/` - packaged assets
- `docs/` - documentation
- `install.sh` - installer and uninstaller
- `README.md` - project overview
- `MANIFEST.txt` - release manifest

## Verification

After making changes, use:

```bash
mise run check
angkrang doctor
```

