ARCHS = arm64e
TARGET = iphone:clang:16.5:16.5
THEOS_PACKAGE_SCHEME = roothide
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardRounded

KeyboardRounded_BUNDLE = Settings.bundle
KeyboardRounded_FILES = Hooks/KeyboardRounded.x
KeyboardRounded_CFLAGS = -fobjc-arc
KeyboardRounded_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
