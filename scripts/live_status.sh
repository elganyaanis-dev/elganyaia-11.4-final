#!/bin/bash
while true; do
    {
    echo "=== LIVE STATUS - $(date) ==="
    echo "PWD: $(pwd)"
    echo "LS: $(ls -la | head -5)"
    echo "KAMINA DIRS: $(find . -name "*kamina*" -type d 2>/dev/null | head -5)"
    } > /sdcard/termux_live_status.txt
    sleep 5
done
