ARG NODE_IMAGE_TAG=24-bookworm-slim
ARG NODE_IMAGE_DIGEST=sha256:2de8393717595f3920276c49aa42bb7f107ad489beb67900d38926b9ab5d55d9
FROM node:${NODE_IMAGE_TAG}@${NODE_IMAGE_DIGEST}

SHELL ["/bin/bash", "-lc"]

COPY pi/versions.env /tmp/versions.env

ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV MISE_DATA_DIR=/root/.local/share/mise
ENV MISE_CONFIG_DIR=/root/.config/mise
ENV MISE_CACHE_DIR=/root/.cache/mise
ENV PATH="/root/.local/share/mise/shims:/root/.local/bin:/usr/local/bin:${PATH}"

RUN set -a \
  && . /tmp/versions.env \
  && set +a \
  && rm -f /etc/apt/sources.list.d/*.list /etc/apt/sources.list.d/*.sources \
  && printf '%s\n' \
    "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/${DEBIAN_SNAPSHOT}/ bookworm main" \
    "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian/${DEBIAN_SNAPSHOT}/ bookworm-updates main" \
    "deb [check-valid-until=no] http://snapshot.debian.org/archive/debian-security/${DEBIAN_SNAPSHOT}/ bookworm-security main" \
    > /etc/apt/sources.list

RUN set -a \
  && . /tmp/versions.env \
  && set +a \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates=${APT_CA_CERTIFICATES} \
    bash=${APT_BASH} \
    git=${APT_GIT} \
    curl=${APT_CURL} \
    wget=${APT_WGET} \
    ripgrep=${APT_RIPGREP} \
    fd-find=${APT_FD_FIND} \
    jq=${APT_JQ} \
    unzip=${APT_UNZIP} \
    zip=${APT_ZIP} \
    tar=${APT_TAR} \
    build-essential=${APT_BUILD_ESSENTIAL} \
    pkg-config=${APT_PKG_CONFIG} \
    python3=${APT_PYTHON3} \
    python3-venv=${APT_PYTHON3_VENV} \
    python3-pip=${APT_PYTHON3_PIP} \
    fzf=${APT_FZF} \
    bat=${APT_BAT} \
    tree=${APT_TREE} \
    shellcheck=${APT_SHELLCHECK} \
    shfmt=${APT_SHFMT} \
    hyperfine=${APT_HYPERFINE} \
    htop=${APT_HTOP} \
    postgresql-client=${APT_POSTGRESQL_CLIENT} \
    redis-tools=${APT_REDIS_TOOLS} \
    sqlite3=${APT_SQLITE3} \
  && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
  && if [ -x /usr/bin/batcat ]; then ln -sf /usr/bin/batcat /usr/local/bin/bat; fi \
  && rm -rf /var/lib/apt/lists/*

RUN set -a \
  && . /tmp/versions.env \
  && set +a \
  && curl -fsSL https://mise.run | MISE_VERSION="${MISE_VERSION}" sh \
  && mise --version

RUN set -a \
  && . /tmp/versions.env \
  && set +a \
  && npm install -g "@earendil-works/pi-coding-agent@${PI_CODING_AGENT_VERSION}" \
  && npm cache clean --force \
  && pi --help >/dev/null

WORKDIR /workspace

ENTRYPOINT ["pi"]
