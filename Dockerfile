# =========================
# 📦 Base Image: Debian Bookworm Slim
# =========================
FROM debian:bookworm-slim

# =========================
# 📥 Fix Debian Sources (Stable - Bookworm)
# =========================
RUN echo "deb http://deb.debian.org/debian bookworm main" > /etc/apt/sources.list && \
    echo "deb http://deb.debian.org/debian bookworm-updates main" >> /etc/apt/sources.list && \
    echo "deb http://security.debian.org/debian-security bookworm-security main" >> /etc/apt/sources.list

# =========================
# 🛠 Install Dependencies
# =========================
RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        python3 python3-venv python3-pip \
        valkey-server \
        firefox-esr \
        graphviz \
        imagemagick \
        librsvg2-bin \
        fonts-dejavu \
        shellcheck \
        uwsgi uwsgi-plugin-python3 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# =========================
# 📂 Copy App Files
# =========================
WORKDIR /app
COPY . /app

# =========================
# 🌍 Environment Variables
# =========================
ENV SEARXNG_SECRET="${SEARXNG_SECRET}" \
    SEARXNG_BASE_URL="${SEARXNG_BASE_URL}" \
    SEARXNG_PORT="${PORT}" \
    SEARXNG_SETTINGS_PATH="/app/searx/settings.yml"

# =========================
# 📡 Expose Port
# =========================
EXPOSE 8888

# =========================
# 🚀 Start SearXNG
# =========================
CMD ["uwsgi", "--ini", "/app/utils/templates/etc/uwsgi/apps-available/searxng.ini"]

