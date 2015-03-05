#!/bin/bash

ticky_main() {
    local command="${1:?"no command
$(usage)"}"
    ticky_start
}

usage() {
    echo "\
Usage:
    bin/ticky start
"
}

ticky_start() {
    ticky_save_start "$(ticky_now)" "$((25*60))"
}

ticky_save_start() {
    local start="$1"
    local duration="$2"

    mkdir -p ~/.ticky
    echo "$start"    >| ~/.ticky/start
    echo "$duration" >| ~/.ticky/duration
}


uuid() {
    python -c 'import uuid; print(str(uuid.uuid4()))'
}

in_seconds() {
    date -jf %Y-%m-%dT%T%z "$1" +%s
}

ticky_now() {
    date -u +%Y-%m-%dT%T%z
}

___() {
current="$(cat 2>/dev/null <~/.ticks/current)"
current="${current:-"$(uuid)"}"
echo "$current" >| ~/.ticks/current

echo current=$current
date="$(now)"

if [[ --start == "$1" ]]; then
    duration="$((25*60))"
    mkdir -p ~/.ticks
    echo "$current started_at $date" > ~/.ticks/event-"$date"-0
    echo "$current duration $duration" > ~/.ticks/event-"$date"-1
    echo "$date" > ~/.ticks/last_start
    echo "$duration" > ~/.ticks/last_start_duration
elif [[ --completed == "$1" ]]; then
    mkdir -p ~/.ticks
    rm ~/.ticks/last_start
    echo "$current completed_at $date" > ~/.ticks/event-"$date"
elif [[ --remaining == "$1" ]]; then
    last_start="$(cat 2>/dev/null <~/.ticks/last_start)"
    duration="$(cat 2>/dev/null <~/.ticks/last_start_duration)"
    last_start_in_seconds="$(in_seconds "$last_start")"
    now_in_seconds="$(in_seconds "$date")"
    elapsed=$((now_in_seconds - last_start_in_seconds))
    remaining=$((duration - elapsed))
    mins=$((remaining / 60))
    secs=$((remaining % 60))
    echo "$(printf "%02d:%02d" $mins $secs)"
fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ticky_main "$@"
fi

