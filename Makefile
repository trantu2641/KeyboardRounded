ARCHS = arm64e
TARGET = iphone:clang:16.5:16.5
THEOS_PACKAGE_SCHEME = roothide
FINALPACKAGE = 1

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = KeyboardRounded

KeyboardRounded_FILES = Hooks/KeyboardRounded.x
KeyboardRounded_CFLAGS = -fobjc-arc
KeyboardRounded_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

after-package::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceBundles/KeyboardRounded.bundle$(ECHO_END)
	$(ECHO_NOTHING)cp -R Settings.bundle/* $(THEOS_STAGING_DIR)/Library/PreferenceBundles/KeyboardRounded.bundle/$(ECHO_END)
