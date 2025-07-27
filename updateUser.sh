#!/bin/bash

# Validar argumentos
if [ $# -ne 2 ]; then
  echo "Uso: $0 <días_hasta_expiración> <usuario>"
  exit 1
fi

DIAS=$1
USUARIO=$2

# Calcular la fecha de expiración a partir de hoy
EXPIRA=$(date -d "+$DIAS days" +"%Y-%m-%d")

# Establecer la fecha de expiración al usuario
sudo chage -E "$EXPIRA" "$USUARIO"

echo "El usuario $USUARIO expirará el $EXPIRA"
