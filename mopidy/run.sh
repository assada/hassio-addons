#!/bin/bash
set -e

local_scan=$(cat /data/options.json | jq -r '.local_scan // empty')
options=$(cat /data/options.json | jq -r 'if .options then [.options[] | "-o "+.name+"="+.value ] | join(" ") else "" end')
config="/var/lib/mopidy/.config/mopidy/mopidy.conf"
enabled=$(cat /data/options.json | jq -r '.mount.enabled')
point=$(cat /data/options.json | jq -r '.mount.point')
disk=$(cat /data/options.json | jq -r '.mount.disk')
filesystem=$(cat /data/options.json | jq -r '.mount.filesystem')

if  [[ "$enabled" != "false" ]]; then
	if [[ "$filesystem" == "auto" ]]; then
		echo "[INFO] Discovering filesystem..."
		filesystem=$(blkid $disk | awk '{print $3}' | sed 's/"//g; s/TYPE=//g')
		echo "[OK] Filesystem auto discovered:"
	fi
	if [[ "$filesystem" == "ntfs" ]]; then
	    filesystem="ntfs-3g"
	fi
	echo "Disk: $disk"
	echo "Filesystem: $filesystem"
	echo "Mountpoint: $filesystem"
	echo ""
	echo "[RUN] mkdir -p -m 777 $point"
	mkdir -p -m 777 ${point}
	echo "[OK] Folder created or exists."
    echo "[RUN] mount -t $filesystem $disk $point"
    mount -t ${filesystem} ${disk} ${point}
    echo "[OK] Disk mounted."
fi

./run-bot.sh > /dev/null &

if  [[ "$local_scan" == "true" ]]; then
    mopidy --config ${config} ${options} local scan
    mkdir /crontabs
    echo "* * * * * mopidy --config $config $options local scan >/dev/null 2>&1" > /crontabs/root
    crond -c /crontabs/
fi

mopidy --config ${config} ${options}
