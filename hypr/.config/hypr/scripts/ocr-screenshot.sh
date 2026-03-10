#!/bin/bash

# Захват области экрана и сохранение во временный файл
TEMP_FILE=$(mktemp /tmp/screenshot-XXXXXX.png)
grim -g "$(slurp)" "$TEMP_FILE"

# Распознавание текста и копирование в буфер
tesseract "$TEMP_FILE" stdout | wl-copy

# Удаление временного файла
rm "$TEMP_FILE"

# Уведомление
dunstify "Текст скриншота скопирован в буфер обмена"
