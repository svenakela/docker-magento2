#!/bin/bash

################################################################################
# Ensure our environment variables are set
################################################################################
if [ "$IMAGE" == "" ]; then
  echo "You must define a \$IMAGE environment variable"
  exit 1
fi

bash tests/specific/test-specific-$IMAGE.sh
