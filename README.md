# Keyboard Rounded — RootHide

Minimal tweak for iOS 16.0+ that changes the corner radius used by Apple's `UIKBRenderer` when rendering keyboard key backgrounds.

Default key radius: **12 pt**.

It does not use Laetus, does not replace keyboard artwork, and does not alter the key layout or input behavior.

## Build

The repository includes a GitHub Actions workflow. It builds with Theos + iPhoneOS 16.5 SDK and `THEOS_PACKAGE_SCHEME=roothide` for arm64e.
