#!/bin/bash
set -e

local_scan=$(cat /data/options.json | jq -r '.local_scan // empty')
options=$(cat /data/options.json | jq -r 'if .options then [.options[] | "-o "+.name+"="+.value ] | join(" ") else "" end')
config="/var/lib/mopidy/.config/mopidy/mopidy.conf"
disk=$(cat /data/options.json | jq -r '.disk')
filesystem=$(cat /data/options.json | jq -r '.filesystem')

if  [ "$disk" != "false" ]; then
	if [ "$filesystem" == "auto" ]; then
		echo "[INFO] Discovering filesystem..."
		filesystem=$(blkid $disk | awk '{print $3}' | sed 's/"//g; s/TYPE=//g')
		echo "[OK] Filesystem auto discovered:"
	fi
	echo "Disk: $disk"
	echo "Filesystem: $filesystem"
	echo ""
	echo "[RUN] mkdir -p -m 777 /share/storage"
	mkdir -p -m 777 /share/storage
	echo "[OK] Folder created or exists."
    echo "[RUN] mount -t $filesystem $disk /share/storage"
    mount -t $filesystem $disk /share/storage
    echo "[OK] Disk mounted."
fi


if  [ "$local_scan" == "true" ]; then
    mopidy --config $config $options local scan
fi
mopidy --config $config $options
