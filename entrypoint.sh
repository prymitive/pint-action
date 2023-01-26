#!/bin/sh -l

if [ "$CONFIG" != "" ]; then
    CONFIG="--config=$CONFIG"
fi

if  [ "$LOGLEVEL" != "" ]; then
    LOGLEVEL="--log-level=$LOGLEVEL"
fi

if  [ "$MIN_SEVERITY" != "" ]; then
    MIN_SEVERITY="--min-severity=$MIN_SEVERITY"
fi

if [ "$GITHUB_EVENT_NAME" != "pull_request" ]; then
    pint $CONFIG $LOGLEVEL lint $MIN_SEVERITY $WORKDIR
else
    CMD="ci"
    BASEBRANCH="$GITHUB_BASE_REF"
    PRBRANCH="$GITHUB_HEAD_REF"
    echo ">>> BASE BRANCH: $BASEBRANCH"
    echo ">>> PR BRANCH: $PRBRANCH"

    git fetch origin "$BASEBRANCH"
    git checkout "$BASEBRANCH"
    git fetch origin "$PRBRANCH"
    git checkout "$PRBRANCH"

    pint $CONFIG $LOGLEVEL ci --base-branch="$BASEBRANCH"
fi
