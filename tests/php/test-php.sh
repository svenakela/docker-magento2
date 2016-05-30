#!/bin/bash

################################################################################
# Output the PHP version running in the image
################################################################################
echo ""
echo "Image PHP Version:"
echo ""

docker run -h test.host testimage php --version || exit 1

################################################################################
# Run PHP requirements test
################################################################################
echo ""
echo "Running PHP requirements test:"
echo ""

docker run -h test.host --volume $(pwd)/tests/php:/test testimage php /test/test-requirements.php  | tee /tmp/test.log
grep "TEST OK" /tmp/test.log > /dev/null || exit 1
rm -f /tmp/test.log
