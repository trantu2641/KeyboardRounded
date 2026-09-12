ARCHS = arm64e
TARGET = iphone:clang:16.5:16.5

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = KeyboardRoundedPrefs

KeyboardRoundedPrefs_RESOURCE_FILES = \
    Resources/Root.plist \
    Resources/icon.png
KeyboardRoundedPrefs_INSTALL_PATH = /Library/PreferenceBundles
KeyboardRoundedPrefs_FRAMEWORKS = UIKit
KeyboardRoundedPrefs_PRIVATE_FRAMEWORKS = Preferences

KeyboardRoundedPrefs_RESOURCE_FILES = Resources/Root.plist Resources/icon.png

include $(THEOS_MAKE_PATH)/bundle.mk
