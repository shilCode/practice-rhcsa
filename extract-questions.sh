#!/usr/bin/env bash
#
# extract-questions.sh - Generate questions-only copies of every practice test.
#
# Reads each practice-test-*.md and writes a stripped copy (Task + Aspects only,
# no answers/explanations) into ./questions/ so you can self-test, configure the
# system, then grade yourself with ./rhcsa-validator.sh.
#
# Usage:  ./extract-questions.sh

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUT="$DIR/questions"
mkdir -p "$OUT"

for src in "$DIR"/practice-test-*.md; do
    base="$(basename "$src")"
    name="${base#practice-test-}"; name="${name%.md}"
    {
        printf '# Practice Test %s - Questions Only\n\n' "${name^}"
        printf '> Tasks only. Configure the system, then run ./rhcsa-validator.sh to grade yourself.\n\n'
        # Keep each question from its "**Question N**" header through the
        # "Aspects/Domains Covered" line; drop everything after (the answer).
        # A question runs from its "**Question N**" header (or a bare "**Task:**"
        # when the header is missing) through the "Aspects/Domains Covered" line.
        # Fall back to the answer heading if a question has no Aspects line.
        awk '
            function sep() { print ""; print "---"; print "" }
            /^[[:space:]]*\*\*Question [0-9]+/ { printing=1 }
            /^[[:space:]]*\*\*Task:/           { printing=1 }
            printing && /Aspects\/Domains Covered/ { sub(/(Overall explanation|Correct Answer|Answer:).*$/, ""); print; sep(); printing=0; next }
            printing && /^[[:space:]]*(Overall explanation|Correct Answer|\*\*Correct Answer|Answer:[[:space:]]*$)/ { sep(); printing=0; next }
            printing { print }
        ' "$src"
    } > "$OUT/$base"
    printf 'Wrote %s\n' "$OUT/$base"
done
