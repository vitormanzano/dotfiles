#!/usr/bin/env bash
# Inibe o hypridle enquanto qualquer player MPRIS estiver em Playing ou Paused (vídeo pausado)
# Usa systemd-inhibit para bloquear o idle do sistema enquanto mídia estiver ativa

INHIBIT_PID=""

inhibit() {
    if [[ -z "$INHIBIT_PID" ]]; then
        systemd-inhibit --what=idle --who="media-idle-inhibit" --why="Media is playing" --mode=block sleep infinity &
        INHIBIT_PID=$!
    fi
}

release() {
    if [[ -n "$INHIBIT_PID" ]]; then
        kill "$INHIBIT_PID" 2>/dev/null
        INHIBIT_PID=""
    fi
}

trap 'release; exit 0' SIGTERM SIGINT

while true; do
    STATUS=$(playerctl --all-players status 2>/dev/null | grep -m1 "Playing")
    if [[ -n "$STATUS" ]]; then
        inhibit
    else
        release
    fi
    sleep 5
done
