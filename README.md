# angkrang

## What
Local AI coding assistant environment tools for this machine.

## Why
Petualangan saya di dunia AI coding assistant di mulai dengan mempersiapkan lingkungan kerja yang nyaman dan mudah di kelola. Saya sadar bahwa saya orang yang tidak konsistent. Saya membutuhkan tools untuk menjaga agar saya konsistent.
Project ini dimaksudkan agar saya bisa mejaga diri saya tetap konsisten.

Saya memutuskan `mise` adalah yang terbaik untuk mengelola konsistensi lingkungan kerja. Akan tetapi juga saya membutuhkan tool untuk inisiasi dan memeriksa kesehatan standard tool.

Kedepan jika saya ingin revisi, menambahkan feature, project ini juga membantu saya mengelola hal tersebut.

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

Publish a release tarball, then use the latest release:

```bash
curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | \
  GITHUB_REPOSITORY=<owner>/<repo> bash
```

Or install a specific version:

```bash
curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | \
  GITHUB_REPOSITORY=<owner>/<repo> VERSION=1.0.0 bash
```

Or point directly to the tarball:

```bash
curl -fsSL https://raw.githubusercontent.com/<owner>/<repo>/main/install.sh | \
  TARBALL_URL=https://github.com/<owner>/<repo>/releases/download/v1.0.0/angkrang-1.0.0.tar.gz \
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

By default, `angkrang pi` expects:

- Dockerfile: `~/agent-images/Dockerfile.pi`
- build context: `~/agent-images`
- optional mise config: `~/.config/mise`

You can override these with environment variables:

- `ANGKRANG_PI_DOCKERFILE`
- `ANGKRANG_PI_BUILD_CONTEXT`
- `ANGKRANG_MISE_CONFIG_HOST`
- `ANGKRANG_DOCTOR_HOST`
- `ANGKRANG_PI_IMAGE`
- `ANGKRANG_PI_CONTAINER`
