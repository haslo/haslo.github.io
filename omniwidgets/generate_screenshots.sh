#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/../../OmniWidget"

echo "Generating widget screenshots..."
xcodebuild test \
  -scheme OmniWidget \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  -only-testing:OmniWidgetTests/WidgetScreenshotGenerator \
  2>&1 | tail -30

echo ""
echo "Screenshots saved to docs/omniwidgets/images/"
ls -la "$(dirname "$0")/images/"*.png 2>/dev/null | wc -l | xargs -I{} echo "{} PNG files generated"
