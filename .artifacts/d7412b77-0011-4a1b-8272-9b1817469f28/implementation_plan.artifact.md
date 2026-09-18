# Refactor Android Package Name for Play Store Release

This plan outlines the steps to properly configure the package name `"ricocapital.id"` across the Android side of your Flutter project, specifically targeting the requirements of Android Gradle Plugin (AGP) 8+ and Kotlin DSL.

## Proposed Changes

### 1. `android/app/build.gradle.kts`
- Fix the malformed `buildTypes` and `signingConfigs` blocks. Currently, `signingConfigs` is mistakenly nested inside `buildTypes -> release`, causing Gradle sync failures.
- Ensure `namespace` and `defaultConfig.applicationId` are explicitly set to `"ricocapital.id"`.

### 2. `android/app/src/main/AndroidManifest.xml`
- Remove the deprecated `package="ricocapital.id"` attribute from the `<manifest>` tag, as AGP 8+ strictly uses the `namespace` defined in `build.gradle.kts`.
- Replace the unresolved `${applicationName}` with `android.app.Application`. (Flutter injects this at build time, but specifying it explicitly resolves the IDE warning).
- Ensure the `<activity android:name=".MainActivity">` correctly resolves by matching the namespace and directory structure.

### 3. `MainActivity.kt` Structure
- Move the `MainActivity.kt` file from its old location (`android/app/src/main/kotlin/com/ricocapital/dev/`) to the new location matching the namespace (`android/app/src/main/kotlin/ricocapital/id/`).
- Update the package declaration at the top of the file to `package ricocapital.id`.
- Delete the old empty `com/ricocapital/dev/` directories to keep the project clean.

## Verification Plan

### Automated Checks
- Ensure the `android` directory successfully passes `gradlew build` or `flutter build apk` without compilation errors related to unresolvable classes or malformed Gradle files.

### Manual Verification
- Check Android Studio's editor to confirm there are no red squiggly lines for `MainActivity` or `android.app.Application` in the `AndroidManifest.xml`.

Please review this plan. Upon approval, I will execute these changes and provide you with the updated code snippets.