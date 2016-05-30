#!/bin/bash

################################################################################
# Ensure our environment variables are set
################################################################################
if [ "$IMAGE" == "" ]; then
  echo "You must define a \$IMAGE environment variable"
  exit 1
fi

################################################################################
# Kick off with some debug
################################################################################
echo ""
echo "Test Runner Configuration:"
echo ""
echo "Image: $IMAGE"
echo "Test: Bash Scripts"

################################################################################
# Running shellcheck
################################################################################
echo ""
echo "Checking shell scripts"
echo ""

shellcheck --exclude=SC2086,SC2006 $IMAGE/bin/* || exit 1
