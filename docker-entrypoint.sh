#!/bin/sh
set -e

# If config.json doesn't exist, generate default one
if [ ! -f /app/config.json ]; then
    echo "No config.json found, generating default configuration..."
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
    echo "Default config.json created. Please edit it before running yogurt."
    echo "Fill in 'signApiUrl' with your signing API endpoint."
    echo "Set 'uin' to your QQ number and 'password' if using Android protocol."
fi

# Ensure data directory exists
mkdir -p /app/data

# Execute the command
exec "$@"
