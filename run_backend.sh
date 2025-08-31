#!/bin/bash

# Получаем абсолютный путь к текущей директории и бинарнику
SCRIPT_DIR="$(pwd)"
BINARY_NAME="convex-local-backend"
FULL_PATH="$SCRIPT_DIR/$BINARY_NAME"

# Проверяем существует ли бинарник
if [ ! -f "$FULL_PATH" ]; then
    echo "Ошибка: бинарник $BINARY_NAME не найден в текущей директории"
    echo "Текущая директория: $SCRIPT_DIR"
    exit 1
fi

# Запускаем бинарник через proot-distro
echo "Запуск $BINARY_NAME из $SCRIPT_DIR"
proot-distro login debian -- "$FULL_PATH" "$@"
