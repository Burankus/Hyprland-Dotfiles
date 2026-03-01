#!/usr/bin/env bash

# Get current default sink ID
current=$(wpctl status | awk '
/Sinks:/,/Sources:/ {
    if ($0 ~ /\*/) {
        match($0, /[0-9]+\./)
        id = substr($0, RSTART, RLENGTH)
        gsub(/\./, "", id)
        print id
    }
}')

# Get headset sink ID
headset=$(wpctl status | awk '
/Sinks:/,/Sources:/ {
    if ($0 ~ /G733 Gaming Headset Analog Stereo/) {
        match($0, /[0-9]+\./)
        id = substr($0, RSTART, RLENGTH)
        gsub(/\./, "", id)
        print id
    }
}')

# Get bluetooth sink ID (only if connected)
bluetooth=$(wpctl status | awk '
/Sinks:/,/Sources:/ {
    if ($0 ~ /哈曼卡顿音乐琥珀/) {
        match($0, /[0-9]+\./)
        id = substr($0, RSTART, RLENGTH)
        gsub(/\./, "", id)
        print id
    }
}')

# If bluetooth not connected, do nothing
[ -z "$bluetooth" ] && exit 0

# Safety check
[ -z "$current" ] && exit 0
[ -z "$headset" ] && exit 0

# Toggle
if [ "$current" = "$headset" ]; then
    target="$bluetooth"
else
    target="$headset"
fi

wpctl set-default "$target"