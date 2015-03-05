#!/bin/bash

ticky_main() {
    local command="${1:?"no command
$(usage)"}"
    case "$1" in
    start) ticky_start;;
    remaining) ticky_remaining;;
    *) usage ;;
    esac
}

usage() {
    echo "\
Usage:
    bin/ticky start
    bin/ticky remaining
"
}

ticky_remaining() {
    local end="$(cat 2>/dev/null <~/.ticky/end)"
    local now="$(ticky_now)"
    local now_in_seconds="$(ticky_date_to_seconds "$now")"
    local end_in_seconds="$(ticky_date_to_seconds "$end")"

    local remaining=$((end_in_seconds - now_in_seconds))
    local mins=$((remaining / 60))
    local secs=$((remaining % 60))
    echo "$(printf "%02d:%02d" $mins $secs)"
}

ticky_start() {
    local start="$(ticky_now)"
    local duration="$((25*60))" 
    local end="$(ticky_date_add_duration "$start" "$duration")"
    ticky_save_start "$start" "$duration" "$end"
}

ticky_date_add_duration() {
    local start="$1"
    local duration="$2"

    local start_in_seconds="$(ticky_date_to_seconds "$start")"
    local end_in_seconds="$((start_in_seconds+duration))"

    ticky_date_from_seconds "$end_in_seconds"
}

ticky_save_start() {
    local start="$1"
    local duration="$2"
    local end="$3"

    mkdir -p ~/.ticky
    echo "$start"    >| ~/.ticky/start
    echo "$duration" >| ~/.ticky/duration
    echo "$end"      >| ~/.ticky/end
}

ticky_date_from_seconds() {
    date -r "$1" +%Y-%m-%dT%T%z
}

ticky_date_to_seconds() {
    date -jf %Y-%m-%dT%T%z "$1" +%s
}

ticky_now() {
    date -u +%Y-%m-%dT%T%z
}

___() {
    echo "$current completed_at $date" > ~/.ticks/event-"$date"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    ticky_main "$@"
fi

