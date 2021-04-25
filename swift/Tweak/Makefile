TWEAK_NAME = BatteryBuddy
$(TWEAK_NAME)_FILES = $(shell find Sources/BatteryBuddy -name '*.swift') $(shell find Sources/BatteryBuddyC -name '*.m' -o -name '*.c' -o -name '*.mm' -o -name '*.cpp')
$(TWEAK_NAME)_SWIFTFLAGS = -ISources/BatteryBuddyC/include
$(TWEAK_NAME)_CFLAGS = -fobjc-arc
$(TWEAK_NAME)_FRAMEWORKS = UIKit
ADDITIONAL_CFLAGS += -DTHEOS_LEAN_AND_MEAN

include $(THEOS)/makefiles/common.mk
include $(THEOS_MAKE_PATH)/tweak.mk
