# angkrang

## What
Angkrang is CLI to help Local AI coding assistant understand the environment.

Purpose:

- Preparing environment
- Help AI understand the environment
- manage environment health `angkrang doctor`

Building block:

- mise
- docker

AI Agent Support:
- codex
- pi. Provide docker sandbox pi via command `angkrang pi`


## Why
My journey in the AI coding assistant world started with preparing a working environment that is comfortable and easy to manage. I realized that I am not a consistent person. I need tools that help me stay consistent.

This project is intended to help me keep myself consistent.

I decided that `mise` is the best tool for managing the consistency of my working environment. However, I also need a tool for initializing and checking the health of standard tools.

In the future, if I want to revise or add features, this project will also help me manage that process.

### Roadmap
- [ ] Installation including dependencies: mise, docker
- [ ] codebase indexing dengan semantic watch daemon + skill. Apakah saya perlu AST parser? --> ya
- [ ]



## Commands

- `angkrang doctor` — checks common CLI tools and shows environment info
- `angkrang pi` — runs the Pi sandbox in Docker
- `angkrang uninstall` — removes angkrang from this machine

## Scaffold

```text
angkrang/
├── bin/
│   ├── angkrang
│   ├── angkrang-doctor
│   └── angkrang-pi
├── docker/
│   ├── common/
│   └── pi/
│       └── Dockerfile
├── shared/
├── config/
├── scripts/
├── assets/
├── docs/
├── MANIFEST.txt
├── VERSION
├── install.sh
├── Makefile
└── README.md
```

## Requirements

- `mise`
- `docker` with Compose support
- WSL is supported for the `codex` stub use case

## Install locally

```bash
./install.sh
```

Flags:

```bash
./install.sh --check
./install.sh --install
./install.sh --uninstall
./install.sh --dry-run
```

Installs to:

- binaries: `~/.local/bin`
- data: `~/.local/share/angkrang`

## Install from GitHub

The install script can download a release tarball directly from GitHub.
For `--dry-run`, the release asset still must be complete and contain the files
listed in `MANIFEST.txt`.

Install the latest release:

```bash
curl -fsSL https://raw.githubusercontent.com/semut-project/angkrang/main/install.sh | \
  GITHUB_REPOSITORY=semut-project/angkrang bash
```

Dry run against a GitHub release:

```bash
curl -fsSL https://raw.githubusercontent.com/semut-project/angkrang/main/install.sh | \
  GITHUB_REPOSITORY=semut-project/angkrang bash -s -- --dry-run
```

Install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/semut-project/angkrang/main/install.sh | \
  GITHUB_REPOSITORY=semut-project/angkrang VERSION=1.0.2 bash
```

Or point directly to a tarball URL:

```bash
curl -fsSL https://raw.githubusercontent.com/semut-project/angkrang/main/install.sh | \
  TARBALL_URL=https://github.com/semut-project/angkrang/releases/download/v1.0.2/angkrang-1.0.2.tar.gz \
  bash
```

## Uninstall

```bash
./install.sh --uninstall
```

Or after install:

```bash
angkrang uninstall
```

## Verify

```bash
angkrang doctor
```

## angkrang pi

```bash
angkrang pi
```

Doctor mode:

```bash
angkrang pi doctor
```

By default, `angkrang pi` uses the packaged Dockerfile, build context, and versions file:

- Dockerfile: `.../docker/pi/Dockerfile`
- build context: `.../docker`
- versions: `.../docker/pi/versions.env`
- optional mise config: `~/.config/mise`

You can override these with environment variables:

- `ANGKRANG_PI_DOCKERFILE`
- `ANGKRANG_PI_BUILD_CONTEXT`
- `ANGKRANG_VERSIONS_FILE`
- `ANGKRANG_MISE_CONFIG_HOST`
- `ANGKRANG_DOCTOR_HOST`
- `ANGKRANG_PI_IMAGE`
- `ANGKRANG_PI_CONTAINER`

Edit `docker/pi/versions.env` to upgrade pinned versions.

Docker build args:

- `NODE_IMAGE_TAG`
- `NODE_IMAGE_DIGEST`
