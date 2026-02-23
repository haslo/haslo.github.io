#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")/../../OmniWidget"

# Domain → test method mapping
resolve_domain() {
  case "$1" in
    weight)
      echo "testWeightTrend"
      ;;
    calories)
      echo "testCalorieBudget testTodayCalories testCalorieTable testWeightCalorieBudget"
      ;;
    energy)
      echo "testEnergyBalance testCaloriesEnergyBalance testEnergyBurnDietary"
      ;;
    activity)
      echo "testSteps testDistance testStairs testWater testActiveBurn testDietaryIntake testWorkouts testWaterStepsStairs testWaterStepsStairsTrio testActivityQuad"
      ;;
    macros)
      echo "testMacroPies testMacroArea testCarbsProteinFat testMacroAreaDetail testDietaryMacros"
      ;;
    sleep)
      echo "testSleepDuration testSleepDuration14 testSleepSchedule testSleepPhases"
      ;;
    *)
      # Not a domain keyword — treat as individual test name
      echo "$1"
      ;;
  esac
}

if [ $# -eq 0 ]; then
  # No arguments — run all screenshot tests
  echo "Generating all widget screenshots..."
  xcodebuild test \
    -scheme OmniWidget \
    -destination 'platform=iOS Simulator,name=iPhone 17' \
    -only-testing:OmniWidgetTests/WidgetScreenshotGenerator \
    2>&1 | tail -30
else
  # Resolve arguments (domains and/or individual test names) into test methods
  tests=""
  for arg in "$@"; do
    resolved=$(resolve_domain "$arg")
    tests="$tests $resolved"
  done

  # Build -only-testing flags
  flags=""
  for test in $tests; do
    flags="$flags -only-testing:OmniWidgetTests/WidgetScreenshotGenerator/$test"
  done

  echo "Generating screenshots for:$tests"
  xcodebuild test \
    -scheme OmniWidget \
    -destination 'platform=iOS Simulator,name=iPhone 17' \
    $flags \
    2>&1 | tail -30
fi

echo ""
echo "Screenshots saved to docs/omniwidgets/images/"
ls -la "$(dirname "$0")/images/"*.png 2>/dev/null | wc -l | xargs -I{} echo "{} PNG files generated"
