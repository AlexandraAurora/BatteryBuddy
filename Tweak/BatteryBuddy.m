//
//  BatteryBuddy.m
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#import "BatteryBuddy.h"

#pragma mark - Status Bar class properties

static UIImageView* batteryBuddyStatusBarIconImageView(_UIBatteryView* self, SEL _cmd) {
    return (UIImageView *)objc_getAssociatedObject(self, (void *)batteryBuddyStatusBarIconImageView);
};
static void setBatteryBuddyStatusBarIconImageView(_UIBatteryView* self, SEL _cmd, UIImageView* rawValue) {
    objc_setAssociatedObject(self, (void *)batteryBuddyStatusBarIconImageView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UIImageView* batteryBuddyStatusBarChargerImageView(_UIBatteryView* self, SEL _cmd) {
    return (UIImageView *)objc_getAssociatedObject(self, (void *)batteryBuddyStatusBarChargerImageView);
};
static void setBatteryBuddyStatusBarChargerImageView(_UIBatteryView* self, SEL _cmd, UIImageView* rawValue) {
    objc_setAssociatedObject(self, (void *)batteryBuddyStatusBarChargerImageView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Status Bar class hooks

BOOL (* orig__UIBatteryView__shouldShowBolt)(_UIBatteryView* self, SEL _cmd);
BOOL override__UIBatteryView__shouldShowBolt(_UIBatteryView* self, SEL _cmd) {
	return NO;
}

UIColor* (* orig__UIBatteryView_fillColor)(_UIBatteryView* self, SEL _cmd);
UIColor* override__UIBatteryView_fillColor(_UIBatteryView* self, SEL _cmd) {
	return [orig__UIBatteryView_fillColor(self, _cmd) colorWithAlphaComponent:0.25];
}

CGFloat (* orig__UIBatteryView_chargePercent)(_UIBatteryView* self, SEL _cmd);
CGFloat override__UIBatteryView_chargePercent(_UIBatteryView* self, SEL _cmd) {
	CGFloat orig = orig__UIBatteryView_chargePercent(self, _cmd);
	int actualPercentage = orig * 100;

	if (actualPercentage <= 20 && !isCharging) {
		[[self batteryBuddyStatusBarIconImageView] setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Documents/BatteryBuddy/StatusBarSad.png"]];
	} else if (actualPercentage <= 49 && !isCharging) {
		[[self batteryBuddyStatusBarIconImageView] setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Documents/BatteryBuddy/StatusBarNeutral.png"]];
	} else if (actualPercentage > 49 && !isCharging) {
		[[self batteryBuddyStatusBarIconImageView] setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Documents/BatteryBuddy/StatusBarHappy.png"]];
	} else if (isCharging) {
		[[self batteryBuddyStatusBarIconImageView] setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Documents/BatteryBuddy/StatusBarHappy.png"]];
	}

	[self updateIconColor];

	return orig;
}

long long (* orig__UIBatteryView_chargingState)(_UIBatteryView* self, SEL _cmd);
long long override__UIBatteryView_chargingState(_UIBatteryView* self, SEL _cmd) {
	long long orig = orig__UIBatteryView_chargingState(self, _cmd);

	if (orig == 1) {
		isCharging = YES;
	} else {
		isCharging = NO;
	}

	[self refreshIcon];

	return orig;
}

void (* orig__UIBatteryView__updateFillLayer)(_UIBatteryView* self, SEL _cmd);
void override__UIBatteryView__updateFillLayer(_UIBatteryView* self, SEL _cmd) {
	orig__UIBatteryView__updateFillLayer(self, _cmd);
	[self chargingState];
}

void _UIBatteryView_refreshIcon(_UIBatteryView* self, SEL _cmd) {
	// remove existing images
	[self setBatteryBuddyStatusBarIconImageView:nil];
	[self setBatteryBuddyStatusBarChargerImageView:nil];
	for (UIImageView* imageView in [self subviews]) {
		[imageView removeFromSuperview];
	}

	if (![self batteryBuddyStatusBarIconImageView]) {
		[self setBatteryBuddyStatusBarIconImageView:[[UIImageView alloc] initWithFrame:[self bounds]]];
		[[self batteryBuddyStatusBarIconImageView] setContentMode:UIViewContentModeScaleAspectFill];
		[[self batteryBuddyStatusBarIconImageView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		if (![[self batteryBuddyStatusBarIconImageView] isDescendantOfView:self]) {
			[self addSubview:[self batteryBuddyStatusBarIconImageView]];
		}
	}

	if (![self batteryBuddyStatusBarChargerImageView] && isCharging) {
		[self setBatteryBuddyStatusBarChargerImageView:[[UIImageView alloc] initWithFrame:[self bounds]]];
		[[self batteryBuddyStatusBarChargerImageView] setContentMode:UIViewContentModeScaleAspectFill];
		[[self batteryBuddyStatusBarChargerImageView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[[self batteryBuddyStatusBarChargerImageView] setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Documents/BatteryBuddy/StatusBarCharger.png"]];
		if (![[self batteryBuddyStatusBarChargerImageView] isDescendantOfView:self]) {
			[self addSubview:[self batteryBuddyStatusBarChargerImageView]];
		}
	}

	[self chargePercent];
}

void _UIBatteryView_updateIconColor(_UIBatteryView* self, SEL _cmd) {
	[[self batteryBuddyStatusBarIconImageView] setImage:[[[self batteryBuddyStatusBarIconImageView] image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[[self batteryBuddyStatusBarChargerImageView] setImage:[[[self batteryBuddyStatusBarChargerImageView] image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];

	if (![[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
		[[self batteryBuddyStatusBarIconImageView] setTintColor:[UIColor labelColor]];
		[[self batteryBuddyStatusBarChargerImageView] setTintColor:[UIColor labelColor]];
	} else {
		[[self batteryBuddyStatusBarIconImageView] setTintColor:[UIColor blackColor]];
		[[self batteryBuddyStatusBarChargerImageView] setTintColor:[UIColor blackColor]];
	}
}

#pragma mark - Lock screen class properties

static UIImageView* batteryBuddyLockScreenIconImageView(_UIBatteryView* self, SEL _cmd) {
    return (UIImageView *)objc_getAssociatedObject(self, (void *)batteryBuddyLockScreenIconImageView);
};
static void setBatteryBuddyLockScreenIconImageView(_UIBatteryView* self, SEL _cmd, UIImageView* rawValue) {
    objc_setAssociatedObject(self, (void *)batteryBuddyLockScreenIconImageView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

static UIImageView* batteryBuddyLockScreenChargerImageView(_UIBatteryView* self, SEL _cmd) {
    return (UIImageView *)objc_getAssociatedObject(self, (void *)batteryBuddyLockScreenChargerImageView);
};
static void setBatteryBuddyLockScreenChargerImageView(_UIBatteryView* self, SEL _cmd, UIImageView* rawValue) {
    objc_setAssociatedObject(self, (void *)batteryBuddyLockScreenChargerImageView, rawValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Lock screen class hooks

void (* orig_CSBatteryFillView_didMoveToWindow)(CSBatteryFillView* self, SEL _cmd);
void override_CSBatteryFillView_didMoveToWindow(CSBatteryFillView* self, SEL _cmd) {
	orig_CSBatteryFillView_didMoveToWindow(self, _cmd);

	[[self superview] setClipsToBounds:NO];

	// face
	if (![self batteryBuddyLockScreenIconImageView]) {
		[self setBatteryBuddyLockScreenIconImageView:[[UIImageView alloc] initWithFrame:[self bounds]]];
		[[self batteryBuddyLockScreenIconImageView] setContentMode:UIViewContentModeScaleAspectFill];
		[[self batteryBuddyLockScreenIconImageView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[[self batteryBuddyLockScreenIconImageView] setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Documents/BatteryBuddy/LockscreenHappy.png"]];
	}
	[[self batteryBuddyLockScreenIconImageView] setImage:[[[self batteryBuddyLockScreenIconImageView] image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[[self batteryBuddyLockScreenIconImageView] setTintColor:[UIColor whiteColor]];
	if (![[self batteryBuddyLockScreenIconImageView] isDescendantOfView:[self superview]]) {
		[[self superview] addSubview:[self batteryBuddyLockScreenIconImageView]];
	}


	// charger
	if (![self batteryBuddyLockScreenChargerImageView]) {
		[self setBatteryBuddyLockScreenChargerImageView:[[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x - 25, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)]];
		[[self batteryBuddyLockScreenChargerImageView] setContentMode:UIViewContentModeScaleAspectFill];
		[[self batteryBuddyLockScreenChargerImageView] setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[[self batteryBuddyLockScreenChargerImageView] setImage:[UIImage imageWithContentsOfFile:@"/var/mobile/Documents/BatteryBuddy/LockscreenCharger.png"]];
	}
	[[self batteryBuddyLockScreenChargerImageView] setImage:[[[self batteryBuddyLockScreenChargerImageView] image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[[self batteryBuddyLockScreenChargerImageView] setTintColor:[UIColor whiteColor]];
	if (![[self batteryBuddyLockScreenChargerImageView] isDescendantOfView:[self superview]]) {
		[[self superview] addSubview:[self batteryBuddyLockScreenChargerImageView]];
	}
}

#pragma mark - Preferences

static void load_preferences() {
    preferences = [[NSUserDefaults alloc] initWithSuiteName:@"dev.traurige.batterybuddy.preferences"];

	[preferences registerDefaults:@{
		kPreferenceKeyEnabled: @(kPreferenceKeyEnabledDefaultValue),
		kPreferenceKeyShowInStatusBar: @(kPreferenceKeyShowInStatusBarDefaultValue),
		kPreferenceKeyShowOnLockScreen: @(kPreferenceKeyShowOnLockScreenDefaultValue)
	}];

	pfEnabled = [[preferences objectForKey:kPreferenceKeyEnabled] boolValue];
	pfShowInStatusBar = [[preferences objectForKey:kPreferenceKeyShowInStatusBar] boolValue];
	pfShowOnLockScreen = [[preferences objectForKey:kPreferenceKeyShowOnLockScreen] boolValue];
}

#pragma mark - Constructor

__attribute((constructor)) static void initialize() {
    load_preferences();

    if (!pfEnabled) {
        return;
    }

	if (pfShowInStatusBar) {
		class_addProperty(NSClassFromString(@"_UIBatteryView"), "batteryBuddyStatusBarIconImageView", (objc_property_attribute_t[]){{"T", "@\"UIImageView\""}, {"N", ""}, {"V", "_batteryBuddyStatusBarIconImageView"}}, 3);
		class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(setBatteryBuddyStatusBarIconImageView:), (IMP)&setBatteryBuddyStatusBarIconImageView, "v@:@");
		class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(batteryBuddyStatusBarIconImageView), (IMP)&batteryBuddyStatusBarIconImageView, "@@:");
		class_addProperty(NSClassFromString(@"_UIBatteryView"), "batteryBuddyStatusBarChargerImageView", (objc_property_attribute_t[]){{"T", "@\"UIImageView\""}, {"N", ""}, {"V", "_batteryBuddyStatusBarChargerImageView"}}, 3);
		class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(setBatteryBuddyStatusBarChargerImageView:), (IMP)&setBatteryBuddyStatusBarChargerImageView, "v@:@");
		class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(batteryBuddyStatusBarChargerImageView), (IMP)&batteryBuddyStatusBarChargerImageView, "@@:");

		class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(refreshIcon), (IMP)&_UIBatteryView_refreshIcon, "v@:");
		class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(updateIconColor), (IMP)&_UIBatteryView_updateIconColor, "v@:");

		MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(_shouldShowBolt), (IMP)&override__UIBatteryView__shouldShowBolt, (IMP *)&orig__UIBatteryView__shouldShowBolt);
		MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(fillColor), (IMP)&override__UIBatteryView_fillColor, (IMP *)&orig__UIBatteryView_fillColor);
		MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(chargePercent), (IMP)&override__UIBatteryView_chargePercent, (IMP *)&orig__UIBatteryView_chargePercent);
		MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(chargingState), (IMP)&override__UIBatteryView_chargingState, (IMP *)&orig__UIBatteryView_chargingState);
		MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(_updateFillLayer), (IMP)&override__UIBatteryView__updateFillLayer, (IMP *)&orig__UIBatteryView__updateFillLayer);
	}

	if (pfShowOnLockScreen) {
		class_addProperty(NSClassFromString(@"CSBatteryFillView"), "batteryBuddyLockScreenIconImageView", (objc_property_attribute_t[]){{"T", "@\"UIImageView\""}, {"N", ""}, {"V", "_batteryBuddyLockScreenIconImageView"}}, 3);
		class_addMethod(NSClassFromString(@"CSBatteryFillView"), @selector(setBatteryBuddyLockScreenIconImageView:), (IMP)&setBatteryBuddyLockScreenIconImageView, "v@:@");
		class_addMethod(NSClassFromString(@"CSBatteryFillView"), @selector(batteryBuddyLockScreenIconImageView), (IMP)&batteryBuddyLockScreenIconImageView, "@@:");

		class_addProperty(NSClassFromString(@"CSBatteryFillView"), "batteryBuddyLockScreenChargerImageView", (objc_property_attribute_t[]){{"T", "@\"UIImageView\""}, {"N", ""}, {"V", "_batteryBuddyLockScreenChargerImageView"}}, 3);
		class_addMethod(NSClassFromString(@"CSBatteryFillView"), @selector(setBatteryBuddyLockScreenChargerImageView:), (IMP)&setBatteryBuddyLockScreenChargerImageView, "v@:@");
		class_addMethod(NSClassFromString(@"CSBatteryFillView"), @selector(batteryBuddyLockScreenChargerImageView), (IMP)&batteryBuddyLockScreenChargerImageView, "@@:");

		MSHookMessageEx(NSClassFromString(@"CSBatteryFillView"), @selector(didMoveToWindow), (IMP)&override_CSBatteryFillView_didMoveToWindow, (IMP *)&orig_CSBatteryFillView_didMoveToWindow);
	}
}
