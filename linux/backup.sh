#!/bin/bash

if ! command -v zstd &> /dev/null; then
    echo "❌ O utilitário 'zstd' não está instalado. Instale com:"
    echo "  sudo apt install zstd     # Debian/Ubuntu"
fi

# === Preparar nomes e caminhos ===
DATE=$(date '+%Y-%m-%d_%H-%M-%S')
BACKUP_FILE="${HOME#/}"
BACKUP_FILE="[$DATE]_${BACKUP_FILE//\//-}.tar.zst"
LOG_FILE="${BACKUP_FILE%.tar.zst}.log"

LOG_DESTINATION="/media/giovani/Backup/logs"
BACKUP_DESTINATION="/media/giovani/Backup"

TMP_BACKUP="/tmp/$BACKUP_FILE"
TMP_LOG="/tmp/$LOG_FILE"

# === Início do backup ===
echo "[$(date)] 🔄 Iniciando backup de $HOME para $TMP_BACKUP" > "$TMP_LOG"

# === Comprimir e registrar saída no log ===
trap 'echo "Cancelado. Limpando..."; rm -f "$TMP_BACKUP"; exit 1' INT
tar -I 'zstd -T0 -19' -cf "$TMP_BACKUP" "$HOME" >> "$TMP_LOG" 2>&1
if [ $? -eq 0 ]; then
    echo "[$(date)] ✅ Compressão concluída com sucesso." >> "$TMP_LOG"
else
    echo "[$(date)] ❌ Erro durante a compressão." >> "$TMP_LOG"
fi

# === Mover arquivos para destino final ===
{
    mv "$TMP_BACKUP" "$BACKUP_DESTINATION/$BACKUP_FILE" &&
    echo "[$(date)] 📦 Backup movido para $BACKUP_DESTINATION/$BACKUP_FILE"
} >> "$TMP_LOG" 2>&1

{
    mv "$TMP_LOG" "$LOG_DESTINATION/$LOG_FILE" &&
    echo "[$(date)] 🗒️ Log movido para $LOG_DESTINATION/$LOG_FILE"
} >> "$TMP_LOG" 2>&1


# === Limpeza (caso algo fique em /tmp) ===
rm -rf "$TMP_BACKUP"
rm -rf "$TMP_LOG"

echo "[$(date)] ✅ Processo de backup finalizado."