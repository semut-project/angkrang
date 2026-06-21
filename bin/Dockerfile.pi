FROM node:24-bookworm-slim

SHELL ["/bin/bash", "-lc"]

ENV MISE_INSTALL_PATH=/usr/local/bin/mise
ENV MISE_DATA_DIR=/root/.local/share/mise
ENV MISE_CONFIG_DIR=/root/.config/mise
ENV MISE_CACHE_DIR=/root/.cache/mise
ENV PATH="/root/.local/share/mise/shims:/root/.local/bin:/usr/local/bin:${PATH}"

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    bash ca-certificates git curl wget ripgrep fd-find jq unzip zip tar \
    build-essential pkg-config python3 python3-venv python3-pip \
    fzf bat tree shellcheck shfmt hyperfine htop \
    postgresql-client redis-tools sqlite3 \
  && ln -sf /usr/bin/fdfind /usr/local/bin/fd \
  && if [ -x /usr/bin/batcat ]; then ln -sf /usr/bin/batcat /usr/local/bin/bat; fi \
  && rm -rf /var/lib/apt/lists/*

RUN curl https://mise.run | sh \
  && mise --version

RUN npm install -g @earendil-works/pi-coding-agent \
  && pi --help >/dev/null

WORKDIR /workspace

ENTRYPOINT ["pi"]