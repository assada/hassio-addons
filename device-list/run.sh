#!/bin/bash
pattern=$(cat /data/options.json | jq -r '.pattern')

ls -lah /devices/$pattern