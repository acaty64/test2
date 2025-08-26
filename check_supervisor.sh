#!/bin/bash
# check-supervisor-conf.sh
# Verifica qué archivos de configuración está usando supervisord
# y lista los programas definidos en ellos.

echo "🔎 Verificando configuración de supervisord..."

# 1. Detectar el archivo principal usado por supervisord
MAIN_CONF=$(ps -eo args | grep supervisord | grep -v grep | awk -F "-c " '{print $2}')

if [ -z "$MAIN_CONF" ]; then
    echo "⚠️ No se encontró supervisord corriendo o no fue lanzado con -c <archivo>."
    exit 1
fi

echo "📄 Archivo principal: $MAIN_CONF"

# 2. Preparar lista de archivos de configuración
CONF_FILES=("$MAIN_CONF")

if [ -f "$MAIN_CONF" ]; then
    INCLUDE_PATTERNS=$(grep -A1 "^\[include\]" "$MAIN_CONF" | grep files | awk -F'=' '{print $2}')
    for pattern in $INCLUDE_PATTERNS; do
        for f in $pattern; do
            [ -e "$f" ] && CONF_FILES+=($(ls -1 $f 2>/dev/null))
        done
    done
else
    echo "⚠️ El archivo principal $MAIN_CONF no existe en el sistema."
    exit 1
fi

# 3. Mostrar todos los archivos encontrados
echo "📂 Archivos de configuración detectados:"
for conf in "${CONF_FILES[@]}"; do
    echo "   - $conf"
done

# 4. Extraer programas definidos en cada archivo
echo ""
echo "⚙️ Programas definidos:"
for conf in "${CONF_FILES[@]}"; do
    if [ -f "$conf" ]; then
        progs=$(grep -o "^\[program:[^]]*\]" "$conf" | sed 's/^\[program:\(.*\)\]/\1/')
        if [ -n "$progs" ]; then
            echo "   📌 En $conf:"
            echo "$progs" | sed 's/^/      - /'
        fi
    fi
done
