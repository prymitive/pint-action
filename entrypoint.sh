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

# Inputs, not GITHUB_*: the runner overwrites default GITHUB_* vars in
# container actions after the step env is applied, so a workflow_run job
# cannot fake a pull_request event.
if [ -n "$PR_NUMBER" ]; then
    export GITHUB_PULL_REQUEST_NUMBER="$PR_NUMBER"
fi
if [ -n "$BASE_BRANCH" ]; then
    GITHUB_BASE_REF="$BASE_BRANCH"
fi
if [ -n "$HEAD_REF" ]; then
    GITHUB_HEAD_REF="$HEAD_REF"
fi

if [ "$GITHUB_EVENT_NAME" != "pull_request" ] && [ -z "$PR_NUMBER" ]; then
    echo ">>> Running: pint $CONFIG $LOGLEVEL lint $MIN_SEVERITY $REQUIRE_OWNER $WORKDIR"
    pint $CONFIG $LOGLEVEL lint $MIN_SEVERITY $REQUIRE_OWNER "$WORKDIR"
else
    if [ -z "$GITHUB_BASE_REF" ] || [ -z "$GITHUB_HEAD_REF" ]; then
        echo ">>> pint ci needs a base branch and a head ref; set base_branch and head_ref"
        exit 1
    fi
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
        # rename so base branch wont conflict with fork branch
        if [ "${GITHUB_HEAD_REF#refs/heads/}" = "${BASEBRANCH}" ]; then
            localbranch="${GITHUB_HEAD_REF#refs/heads/}_fork"
        else
            localbranch="${GITHUB_HEAD_REF#refs/heads/}"
        fi
        # force delete any existing branch we could have
        git branch -D "${localbranch}" || true

        # make new branch, locally
        git checkout -b "${localbranch}"
        # make a new local branch with our upstream data
        git branch --set-upstream-to=origin/"$BASEBRANCH" "${localbranch}"
        git pull

        # populate a local base branch with upstream data
        git checkout remotes/origin/"$BASEBRANCH"
        git branch "$BASEBRANCH"
        git reset --hard remotes/origin/"$BASEBRANCH"
        # helpful debug step
        git remote -v
        git pull origin "$BASEBRANCH"

        # go back to our fork branch
        git checkout "${localbranch}"
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

    echo ">>> Running: pint $CONFIG $LOGLEVEL $CMD --base-branch=$BASEBRANCH $REQUIRE_OWNER"
    pint $CONFIG $LOGLEVEL $CMD --base-branch="$BASEBRANCH" $REQUIRE_OWNER
fi
