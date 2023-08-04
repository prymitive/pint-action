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

if  [ "$REQUIRE_OWNER" != "" ]; then
    REQUIRE_OWNER="--require-owner"
fi

if [ "$GITHUB_EVENT_NAME" != "pull_request" ]; then
    pint "$CONFIG" "$LOGLEVEL" lint "$MIN_SEVERITY" "$REQUIRE_OWNER" "$WORKDIR"
else
    CMD="ci"
    echo ">>> GITHUB_WORKSPACE: $GITHUB_WORKSPACE"
    git config --global --add safe.directory "${GITHUB_WORKSPACE}"

    # we must have both target/source repo values populated, and they should differ to indicate the PR is from a fork
    if [ "${PULL_REQUEST_TARGET_REPO}" != "" ] && [ "${PULL_REQUEST_SOURCE_REPO}" != "" ] && [ "${PULL_REQUEST_TARGET_REPO}" != "${PULL_REQUEST_SOURCE_REPO}" ]; then
    # pull request is from fork
        echo ">>> Running steps for PR from fork"
        BASEBRANCH="${GITHUB_BASE_REF#refs/heads/}"
        echo ">>> BASE BRANCH: $BASEBRANCH"
        echo ">>> GITHUB HEAD REF: ${GITHUB_HEAD_REF}"

        # must set these values for the git pull
        git config --global user.email "pint@fakemail.com"
        git config --global user.name "pint"
        git config pull.rebase false

        # makes output cleaner
        git config --global advice.detachedHead false

        # # https://github.com/reg-viz/reg-suit#workaround-for-detached-head
        # # https://github.com/reg-viz/reg-suit/issues/590#issuecomment-1219155722
        # workaround for detached head
        # force delete any existing branch we could have
        git branch -D "${GITHUB_HEAD_REF#refs/heads/}" || true
        # TODO - I think if the PR from a fork has the same branch name as BASEBRANCH this could go awry
        git checkout -b "${GITHUB_HEAD_REF#refs/heads/}"
        # make a new local branch with our upstream data
        git branch --set-upstream-to=origin/"$BASEBRANCH" "${GITHUB_HEAD_REF}"
        git pull

        # populate a local base branch with upstream data
        git checkout remotes/origin/"$BASEBRANCH"
        git branch "$BASEBRANCH"
        git reset --hard remotes/origin/"$BASEBRANCH"
        # helpful debug step
        git remote -v
        git pull origin "$BASEBRANCH"

        # go back to our fork branch
        git checkout "${GITHUB_HEAD_REF#refs/heads/}"
    else
        # pull request is not from fork
        echo ">>> Running steps for PR from trunk (not fork)"
        BASEBRANCH="$GITHUB_BASE_REF"
        PRBRANCH="$GITHUB_HEAD_REF"
        echo ">>> BASE BRANCH: $BASEBRANCH"
        echo ">>> PR BRANCH: $PRBRANCH"
        git fetch origin "$BASEBRANCH"
        git checkout "$BASEBRANCH"
        git fetch origin "$PRBRANCH"
        git checkout "$PRBRANCH"

    fi
        pint "$CONFIG" "$LOGLEVEL" $CMD --base-branch="$BASEBRANCH" "$REQUIRE_OWNER"

fi
