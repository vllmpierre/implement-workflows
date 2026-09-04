#!/usr/bin/env bash
# Converts clang-tidy warning/error output (via stdin) into GitHub Actions
# annotations and fails (exit 1) if any findings were reported.
set -uo pipefail

count=0

while IFS= read -r line; do
    if [[ "$line" =~ ^([^:]+):([0-9]+):([0-9]+):\ (warning|error):\ (.*)\ \[(.*)\]$ ]]; then
        file="${BASH_REMATCH[1]}"
        line_no="${BASH_REMATCH[2]}"
        col="${BASH_REMATCH[3]}"
        level="${BASH_REMATCH[4]}"
        message="${BASH_REMATCH[5]}"
        check="${BASH_REMATCH[6]}"

        gh_level="warning"
        if [[ "$level" == "error" ]]; then
            gh_level="error"
        fi

        # Escape characters that would otherwise break the workflow command syntax.
        escaped_message=$(printf '%s' "$message" | sed -e 's/%/%25/g' -e 's/\r/%0D/g' -e 's/\n/%0A/g')

        echo "::${gh_level} file=${file},line=${line_no},col=${col}::${escaped_message} [${check}]"
        count=$((count + 1))
    fi
done

if [[ "$count" -gt 0 ]]; then
    echo "clang-tidy reported ${count} finding(s)" >&2
    exit 1
fi

exit 0
