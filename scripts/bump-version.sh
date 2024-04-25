#!/bin/bash

# script that bumps version for all projects regardless of whether they were
# changed since last release. needed because `lerna version` only bumps versions for projects
# listed by `lerna changed` by default.
#
# see: https://github.com/lerna/lerna/issues/2369

(npx -p lerna@6.4.1 -y lerna version \
    --no-git-tag-version \
    --no-push \
    --force-publish \
    -y \
    "$1" \
) || exit 1

if [[ "$PWD" == *packages/jupyter-ai ]]; then
    # bump dependency in jupyter-ai to rely on current version of jupyter-ai-magics
    # -E : use extended regex to allow usage of `+` symbol
    # -i '' : modify file in-place
    sed -E -i '' "s/jupyter_ai_magics.=[0-9]+\.[0-9]+\.[0-9]+/jupyter_ai_magics==$1/" pyproject.toml
fi
