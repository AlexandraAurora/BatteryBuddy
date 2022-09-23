BUNDLE_NAME = BatteryBuddyPreferences
BatteryBuddyPreferences_FILES = $(wildcard *.m)
BatteryBuddyPreferences_CFLAGS = -fobjc-arc -DTHEOS_LEAN_AND_MEAN
BatteryBuddyPreferences_INSTALL_PATH = /Library/PreferenceBundles
BatteryBuddyPreferences_FRAMEWORKS = UIKit
BatteryBuddyPreferences_PRIVATE_FRAMEWORKS = Preferences
BatteryBuddyPreferences_EXTRA_FRAMEWORKS = Cephei CepheiPrefs

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/BatteryBuddyPreferences.plist$(ECHO_END)
