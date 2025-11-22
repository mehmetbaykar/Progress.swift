# Swift 6.2 Test Failure Fix

## Problem

When upgrading from Swift tools version 6.0 to 6.2, the test `testProgressBarCountZero` was failing with:

```
✘ Test "testProgressBarCountZero" recorded an issue at ProgressTests.swift:85:5:
Expectation failed: (bar.value → "100%") == "0 of 0 [------------------------------] ETA: 00:00:00 (at 0.00) it/s)"
```

The test expected the full progress bar format but was receiving just "100%".

## Root Cause

The issue was caused by **test isolation problems with shared mutable static state**:

1. `ProgressBar.defaultConfiguration` is a static mutable variable marked as `nonisolated(unsafe)`
2. Multiple tests (`testProgressDefaultConfiguration`, `testProgressDefaultConfigurationUpdate`, and `testProgressBarCountZero`) rely on or modify this global state
3. In Swift 6.2, the Swift Testing framework changed its test execution behavior - tests now run more concurrently by default
4. Tests that modified `defaultConfiguration` were interfering with other tests that relied on the default value

Specifically:
- `testProgressDefaultConfigurationUpdate()` sets `defaultConfiguration = [ProgressPercent()]`
- `testProgressBarCountZero()` expects the default configuration to be `[ProgressIndex(), ProgressBarLine(), ProgressTimeEstimates()]`
- When these tests ran concurrently or in certain orders, the global state mutation caused failures

## Solution

The fix involved two changes:

### 1. Added `.serialized` trait to the test suite

```swift
@Suite("ProgressTests", .serialized)
struct ProgressTests {
```

This ensures all tests in the `ProgressTests` suite run serially rather than concurrently, preventing race conditions on the shared mutable state.

### 2. Save and restore default configuration in each test

For tests that modify the global configuration, we now:
- Save the current configuration before modification
- Restore it after the test completes

Example:
```swift
@Test("testProgressBarCountZero")
func testProgressBarCountZero() {
  // Save the current default configuration
  let savedConfig = ProgressBar.defaultConfiguration

  // Ensure we're using the expected default configuration
  ProgressBar.defaultConfiguration = [
    ProgressIndex(), ProgressBarLine(), ProgressTimeEstimates(),
  ]

  let bar = ProgressBar(count: 0)
  #expect(bar.value == "0 of 0 [------------------------------] ETA: 00:00:00 (at 0.00) it/s)")

  // Restore the original configuration
  ProgressBar.defaultConfiguration = savedConfig
}
```

## Why This Worked in Swift 6.0 but Not 6.2

Swift 6.2 introduced changes to the Swift Testing framework's default behavior:
- Tests are now more likely to run concurrently by default
- The test execution order may have changed
- Better parallelization means shared mutable state issues are more likely to surface

In Swift 6.0, tests likely ran in a more sequential manner, masking the race condition.

## Best Practices

When dealing with shared mutable state in tests:
1. Use the `.serialized` trait for test suites that modify global state
2. Always save and restore global state in tests
3. Consider refactoring to avoid global mutable state where possible
4. Use dependency injection instead of global configuration when feasible

## Verification

All 22 tests now pass consistently:
```
✔ Test run with 22 tests in 3 suites passed after 0.023 seconds.
```
