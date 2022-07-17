#!/bin/sh -l

if [ "$CONFIG" != "" ]; then
    CONFIG="--config=$CONFIG"
fi

if  [ "$LOGLEVEL" != "" ]; then
    LOGLEVEL="--log-level=$LOGLEVEL"
fi

if [ "$GITHUB_EVENT_PATH" == "pull_request" ] && [ "$GITHUB_REF_TYPE" == "branch" ]; then
    CMD="ci"
    BASEBRANCH="$GITHUB_BASE_REF"
    PRBRANCH="$GITHUB_REF_NAME"
    PRNUMBER=$(echo "$GITHUB_REF" | awk -F / '{print $3}')
    echo ">>> BASE BRANCH: $BASEBRANCH"
    echo ">>> PR BRANCH: $PRBRANCH"
    echo ">>> PR NUMBER: $PRNUMBER"

    git fetch --unshallow
    git fetch origin "$BASEBRANCH"
    git checkout "$BASEBRANCH"
    git fetch origin "$PRBRANCH"
    git checkout "$PRBRANCH"

    env GITHUB_PULL_REQUEST_NUMBER="$PRNUMBER" pint $CONFIG $LOGLEVEL ci --base-branch="$BASEBRANCH"
else
    pint $CONFIG $LOGLEVEL lint $WORKDIR
fi
