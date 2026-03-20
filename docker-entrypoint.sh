#!/bin/sh
set -e

# Generate default config if not exists or empty
if [ ! -s /app/config.json ]; then
    echo "Generating default configuration..."
    cat > /app/config.json << 'EOF'
{
  "configVersion": 3,
  "protocol": {
    "uin": 0,
    "password": "",
    "os": "Linux",
    "version": "fetched",
    "signApiUrl": "",
    "pcLagrangeSignToken": "",
    "androidUseLegacySign": false
  },
  "milky": {
    "http": {
      "host": "0.0.0.0",
      "port": 3000,
      "accessToken": "",
      "corsOrigins": []
    },
    "webhook": {
      "endpoints": []
    },
    "reportSelfMessage": true,
    "preloadContacts": false
  },
  "logging": {
    "ansiLevel": "ANSI256",
    "coreLogLevel": "DEBUG"
  },
  "security": {
    "skipOnLaunchListenAddressCheck": false
  }
}
EOF
    echo "Default config.json created. Please edit it and restart the container."
    exit 0
fi

# Ensure data directory exists
mkdir -p /app/data

# Execute the command
exec "$@"
