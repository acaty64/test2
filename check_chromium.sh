#!/bin/bash
set -e

CHROMIUM_BIN=$(command -v chromium || command -v chromium-browser)

if [ -z "$CHROMIUM_BIN" ]; then
  echo "❌ Chromium no está instalado."
  exit 1
fi

echo "➡️ Detectando versión de Chromium..."
CHROMIUM_VERSION=$($CHROMIUM_BIN --version | awk '{print $2}')
CHROMIUM_MAJOR=$(echo "$CHROMIUM_VERSION" | cut -d. -f1)

echo "Chromium: $CHROMIUM_VERSION"

if ! command -v chromedriver > /dev/null; then
  echo "❌ ChromeDriver no está instalado."
  exit 1
fi

echo "➡️ Detectando versión de ChromeDriver..."
CHROMEDRIVER_VERSION=$(chromedriver --version | awk '{print $2}')
CHROMEDRIVER_MAJOR=$(echo "$CHROMEDRIVER_VERSION" | cut -d. -f1)

echo "ChromeDriver: $CHROMEDRIVER_VERSION"

if [ "$CHROMIUM_MAJOR" -ne "$CHROMEDRIVER_MAJOR" ]; then
  echo "❌ Incompatibilidad detectada: Chromium $CHROMIUM_MAJOR vs ChromeDriver $CHROMEDRIVER_MAJOR"
  exit 1
else
  echo "✅ OK: Chromium y ChromeDriver son compatibles."
fi
