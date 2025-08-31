#!/bin/bash

echo "Останавливаем все screen-сессии..."

# Убиваем конкретные сессии по имени
screen -S cback -X quit 2>/dev/null
screen -S embd -X quit 2>/dev/null
screen -S llm -X quit 2>/dev/null
screen -S aitown -X quit 2>/dev/null

echo "Screen-сессии остановлены."

# Опционально: показать оставшиеся активные сессии
echo "Текущие screen-сессии:"
screen -list 2>/dev/null || echo "Нет активных сессий"

pkill node
