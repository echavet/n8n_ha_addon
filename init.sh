#!/bin/bash
# init_structure.sh - Script pour initialiser l'arborescence de l'addon n8n

# Créer les dossiers
mkdir -p rootfs/etc/s6-overlay/s6-rc.d/init-n8n/dependencies.d
mkdir -p rootfs/etc/s6-overlay/s6-rc.d/n8n/dependencies.d
mkdir -p rootfs/etc/s6-overlay/s6-rc.d/debug-shell/dependencies.d
mkdir -p rootfs/etc/s6-overlay/s6-rc.d/user/contents.d

# Fichier config.yaml
cat <<EOF > config.yaml
name: "n8n"
version: "1.6.8"
slug: "n8n"
description: "Lance une instance de n8n pour l'automatisation des workflows"
init: false
arch:
  - aarch64
  - amd64
  - armhf
  - armv7
  - i386
ports:
  5678/tcp: 5678
ports_description:
  5678/tcp: "Port pour accéder à l'interface web de n8n"
map:
  - config:rw
  - n8n_data:rw
url: "https://github.com/echavet/n8n"
startup: "application"
boot: "auto"
host_network: true
options:
  webhook_url: "http://localhost:5678"
  log_level: "debug"
schema:
  webhook_url: str
  log_level: list(debug|info|warn|error)?debug
EOF

# Dockerfile
cat <<EOF > Dockerfile
ARG BUILD_FROM
FROM \$BUILD_FROM

RUN apk add --no-cache \\
    nodejs \\
    npm \\
    jq

RUN npm install -g n8n

EXPOSE 5678
WORKDIR /data
COPY rootfs /
EOF

# Scripts s6-overlay
cat <<EOF > rootfs/etc/s6-overlay/s6-rc.d/init-n8n/run
#!/usr/bin/with-contenv bashio
# Home Assistant Community Add-on: n8n
# Initializes n8n environment variables

set +u
chmod +x "\$0"

bashio::log.info "Initializing n8n configuration..."

N8N_DATA_DIR="/home/node/.n8n"
ENV_FILE="\${N8N_DATA_DIR}/.env"
mkdir -p "\${N8N_DATA_DIR}"
chown -R root:root "\${N8N_DATA_DIR}"
chmod -R 700 "\${N8N_DATA_DIR}"

# Initialiser .env avec des valeurs par défaut s'il n'existe pas
if [ ! -f "\${ENV_FILE}" ]; then
  bashio::log.info "Création de \${ENV_FILE} avec des valeurs par défaut..."
  cat <<EOV > "\${ENV_FILE}"
# Fichier de configuration n8n - éditez ces valeurs selon vos besoins
# Voir https://docs.n8n.io/hosting/configuration/environment-variables/
N8N_LOG_LEVEL=info
N8N_COMMUNITY_PACKAGES_ENABLED=false
N8N_PORT=5678
EOV
fi

# Lire les options depuis config.yaml
webhook_url=\$(bashio::config 'webhook_url')
log_level=\$(bashio::config 'log_level')
protocol=\$(echo "\$webhook_url" | grep -Eo '^https?')
host=\$(echo "\$webhook_url" | sed -E 's|^https?://||' | sed -E 's|[:/].*||')

# Exporter les variables pour n8n
export N8N_WEBHOOK_URL="\${webhook_url}"
export N8N_LOG_LEVEL="\${log_level}"
export N8N_PROTOCOL="\${protocol}"
export N8N_HOST="\${host}"
export N8N_PORT=5678
export N8N_LISTEN_ADDRESS="0.0.0.0"
export N8N_USER_FOLDER="\${N8N_DATA_DIR}"

bashio::log.info "Variables d'environnement définies :"
env | grep N8N | while read -r line; do bashio::log.info "\$line"; done

exit 0
EOF

cat <<EOF > rootfs/etc/s6-overlay/s6-rc.d/n8n/run
#!/usr/bin/with-contenv bashio
# Home Assistant Community Add-on: n8n
# Runs the n8n service

set +u
chmod +x "\$0"

bashio::log.info "Starting n8n service..."

# Vérifier les variables essentielles
if [ -z "\$N8N_HOST" ] || [ -z "\$N8N_PORT" ] || [ -z "\$N8N_WEBHOOK_URL" ]; then
  bashio::log.error "Variables essentielles manquantes (N8N_HOST, N8N_PORT, N8N_WEBHOOK_URL) !"
  exit 1
fi

bashio::log.info "Lancement de n8n avec les variables d'environnement..."
exec n8n start
EOF

cat <<EOF > rootfs/etc/s6-overlay/s6-rc.d/debug-shell/run
#!/usr/bin/with-contenv bashio
# Home Assistant Community Add-on: n8n
# Temporary debug shell to keep container alive

chmod +x "\$0"
bashio::log.info "Debug shell started. Container will stay alive."
bashio::log.info "Use 'docker exec -it <container> bash' to access."
exec tail -f /dev/null
EOF

# Dépendances et types
echo "base" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n/dependencies.d/base
echo "init-n8n" > rootfs/etc/s6-overlay/s6-rc.d/n8n/dependencies.d/init-n8n
echo "n8n" > rootfs/etc/s6-overlay/s6-rc.d/debug-shell/dependencies.d/n8n
echo "longrun" > rootfs/etc/s6-overlay/s6-rc.d/init-n8n/type
echo "longrun" > rootfs/etc/s6-overlay/s6-rc.d/n8n/type
echo "longrun" > rootfs/etc/s6-overlay/s6-rc.d/debug-shell/type
echo "init-n8n" > rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/init-n8n
echo "n8n" > rootfs/etc/s6-overlay/s6-rc.d/user/contents.d/n8n

touch rootfs/etc/s6-overlay/s6-rc.d/init-n8n/up
touch rootfs/etc/s6-overlay/s6-rc.d/n8n/up
touch rootfs/etc/s6-overlay/s6-rc.d/debug-shell/up

echo "Structure initialisée avec succès !"