include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = KeyboardRoundedPrefs

KeyboardRoundedPrefs_FILES = \
    KeyboardRoundedPrefs/KRRootListController.m

KeyboardRoundedPrefs_FRAMEWORKS = UIKit
KeyboardRoundedPrefs_PRIVATE_FRAMEWORKS = Preferences

KeyboardRoundedPrefs_INSTALL_PATH = /Library/PreferenceBundles

KeyboardRoundedPrefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

after-install::
	install.exec "killall -9 Preferences"
