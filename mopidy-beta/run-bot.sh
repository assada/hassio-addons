#!/bin/bash
set -e

enabled=$(cat /data/options.json | jq -r '.telegram.enabled // empty')
token=$(cat /data/options.json | jq -r '.telegram.token // empty')
admin=$(cat /data/options.json | jq -r '.telegram.admin // empty')
destination=$(cat /data/options.json | jq -r '.telegram.destination // empty')

if [[ "$enabled" != "false" ]]; then
    mkdir -p -m 777 ${destination}

    cd /tg-music-downloader
    echo "[INFO] Bot Starting..."
    make run ${token} ${admin} ${destination}
else
    echo "[INFO] Telegram bot disabled"
fi
