//
//  BatteryBuddy.m
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#import "BatteryBuddy.h"

BOOL (* orig__UIBatteryView__shouldShowBolt)(_UIBatteryView* self, SEL _cmd);
UIColor* (* orig__UIBatteryView_fillColor)(_UIBatteryView* self, SEL _cmd);
CGFloat (* orig__UIBatteryView_chargePercent)(_UIBatteryView* self, SEL _cmd);
long long (* orig__UIBatteryView_chargingState)(_UIBatteryView* self, SEL _cmd);
void (* orig__UIBatteryView__updateFillLayer)(_UIBatteryView* self, SEL _cmd);
void (* orig_CSBatteryFillView_didMoveToWindow)(CSBatteryFillView* self, SEL _cmd);

BOOL override__UIBatteryView__shouldShowBolt(_UIBatteryView* self, SEL _cmd) {
	return NO;
}

UIColor* override__UIBatteryView_fillColor(_UIBatteryView* self, SEL _cmd) {
	return [orig__UIBatteryView_fillColor(self, _cmd) colorWithAlphaComponent:0.25];
}

CGFloat override__UIBatteryView_chargePercent(_UIBatteryView* self, SEL _cmd) {
	CGFloat orig = orig__UIBatteryView_chargePercent(self, _cmd);
	int actualPercentage = orig * 100;

	if (actualPercentage <= 20 && !isCharging) {
		[statusBarBatteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/StatusBarSad.png"]];
	} else if (actualPercentage <= 49 && !isCharging) {
		[statusBarBatteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/StatusBarNeutral.png"]];
	} else if (actualPercentage > 49 && !isCharging) {
		[statusBarBatteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/StatusBarHappy.png"]];
	} else if (isCharging) {
		[statusBarBatteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/StatusBarHappy.png"]];
	}

	[self updateIconColor];

	return orig;
}

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

void override__UIBatteryView__updateFillLayer(_UIBatteryView* self, SEL _cmd) {
	orig__UIBatteryView__updateFillLayer(self, _cmd);
	[self chargingState];
}

void _UIBatteryView_refreshIcon(_UIBatteryView* self, SEL _cmd) {
	// remove existing images
	statusBarBatteryIconView = nil;
	statusBarBatteryChargerView = nil;
	for (UIImageView* imageView in [self subviews]) {
		[imageView removeFromSuperview];
	}

	if (!statusBarBatteryIconView) {
		statusBarBatteryIconView = [[UIImageView alloc] initWithFrame:[self bounds]];
		[statusBarBatteryIconView setContentMode:UIViewContentModeScaleAspectFill];
		[statusBarBatteryIconView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		if (![statusBarBatteryIconView isDescendantOfView:self]) {
			[self addSubview:statusBarBatteryIconView];
		}
	}

	if (!statusBarBatteryChargerView && isCharging) {
		statusBarBatteryChargerView = [[UIImageView alloc] initWithFrame:[self bounds]];
		[statusBarBatteryChargerView setContentMode:UIViewContentModeScaleAspectFill];
		[statusBarBatteryChargerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[statusBarBatteryChargerView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/StatusBarCharger.png"]];
		if (![statusBarBatteryChargerView isDescendantOfView:self]) {
			[self addSubview:statusBarBatteryChargerView];
		}
	}

	[self chargePercent];
}

void _UIBatteryView_updateIconColor(_UIBatteryView* self, SEL _cmd) {
	[statusBarBatteryIconView setImage:[[statusBarBatteryIconView image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[statusBarBatteryChargerView setImage:[[statusBarBatteryChargerView image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	
	if (![[NSProcessInfo processInfo] isLowPowerModeEnabled]) {
		[statusBarBatteryIconView setTintColor:[UIColor labelColor]];
		[statusBarBatteryChargerView setTintColor:[UIColor labelColor]];
	} else {
		[statusBarBatteryIconView setTintColor:[UIColor blackColor]];
		[statusBarBatteryChargerView setTintColor:[UIColor blackColor]];
	}
}

void override_CSBatteryFillView_didMoveToWindow(CSBatteryFillView* self, SEL _cmd) {
	orig_CSBatteryFillView_didMoveToWindow(self, _cmd);

	[[self superview] setClipsToBounds:NO];

	if (!lockscreenBatteryIconView) {
		lockscreenBatteryIconView = [[UIImageView alloc] initWithFrame:[self bounds]];
		[lockscreenBatteryIconView setContentMode:UIViewContentModeScaleAspectFill];
		[lockscreenBatteryIconView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lockscreenBatteryIconView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/LockscreenHappy.png"]];
	}
	[lockscreenBatteryIconView setImage:[[lockscreenBatteryIconView image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[lockscreenBatteryIconView setTintColor:[UIColor whiteColor]];
	if (![lockscreenBatteryIconView isDescendantOfView:[self superview]]) {
		[[self superview] addSubview:lockscreenBatteryIconView];
	}

	if (!lockscreenBatteryChargerView) {
		lockscreenBatteryChargerView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.origin.x - 25, self.bounds.origin.y, self.bounds.size.width, self.bounds.size.height)];
		[lockscreenBatteryChargerView setContentMode:UIViewContentModeScaleAspectFill];
		[lockscreenBatteryChargerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
		[lockscreenBatteryChargerView setImage:[UIImage imageWithContentsOfFile:@"/Library/BatteryBuddy/LockscreenCharger.png"]];
	}
	[lockscreenBatteryChargerView setImage:[[lockscreenBatteryChargerView image] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]];
	[lockscreenBatteryChargerView setTintColor:[UIColor whiteColor]];
	if (![lockscreenBatteryChargerView isDescendantOfView:[self superview]]) {
		[[self superview] addSubview:lockscreenBatteryChargerView];
	}
}

__attribute__((constructor)) static void initialize() {
	MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(_shouldShowBolt), (IMP)&override__UIBatteryView__shouldShowBolt, (IMP *)&orig__UIBatteryView__shouldShowBolt);
	MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(fillColor), (IMP)&override__UIBatteryView_fillColor, (IMP *)&orig__UIBatteryView_fillColor);
	MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(chargePercent), (IMP)&override__UIBatteryView_chargePercent, (IMP *)&orig__UIBatteryView_chargePercent);
	MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(chargingState), (IMP)&override__UIBatteryView_chargingState, (IMP *)&orig__UIBatteryView_chargingState);
	MSHookMessageEx(NSClassFromString(@"_UIBatteryView"), @selector(_updateFillLayer), (IMP)&override__UIBatteryView__updateFillLayer, (IMP *)&orig__UIBatteryView__updateFillLayer);
	class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(refreshIcon), (IMP)&_UIBatteryView_refreshIcon, "v@:");
	class_addMethod(NSClassFromString(@"_UIBatteryView"), @selector(updateIconColor), (IMP)&_UIBatteryView_updateIconColor, "v@:");
	MSHookMessageEx(NSClassFromString(@"CSBatteryFillView"), @selector(didMoveToWindow), (IMP)&override_CSBatteryFillView_didMoveToWindow, (IMP *)&orig_CSBatteryFillView_didMoveToWindow);
}
