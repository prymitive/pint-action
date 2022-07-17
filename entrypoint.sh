#!/bin/sh -l

if [ "$CONFIG" != "" ]; then
    CONFIG="--config=$CONFIG"
fi

if  [ "$LOGLEVEL" != "" ]; then
    LOGLEVEL="--log-level=$LOGLEVEL"
fi

if [ "$GITHUB_EVENT_PATH" == "pull_request" && "$GITHUB_REF_TYPE" == "branch" ];
    CMD="ci"
    BASEBRANCH="$GITHUB_BASE_REF"
    PRBRANCH="$GITHUB_REF_NAME"

    git fetch --unshallow
    git fetch origin "$BASEBRANCH"
    git checkout "$BASEBRANCH"
    git fetch origin "$PRBRANCH"
    git checkout "$PRBRANCH"

    pint $CONFIG $LOGLEVEL ci --base-branch="$BASEBRANCH"
else
    pint $CONFIG $LOGLEVEL lint $WORKDIR
fi
