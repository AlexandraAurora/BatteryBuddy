//
//  BatteryBuddy.h
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#import "substrate.h"
#import <UIKit/UIKit.h>
#import "../Preferences/PreferenceKeys.h"

BOOL isCharging = NO;

// preferences
NSUserDefaults* preferences;
BOOL pfEnabled;
BOOL pfShowInStatusBar;
BOOL pfShowOnLockScreen;

@interface _UIBatteryView : UIView
@property(nonatomic, retain)UIImageView* batteryBuddyStatusBarIconImageView;
@property(nonatomic, retain)UIImageView* batteryBuddyStatusBarChargerImageView;
- (CGFloat)chargePercent;
- (long long)chargingState;
- (void)refreshIcon;
- (void)updateIconColor;
@end

@interface CSBatteryFillView : UIView
@property(nonatomic, retain)UIImageView* batteryBuddyLockScreenIconImageView;
@property(nonatomic, retain)UIImageView* batteryBuddyLockScreenChargerImageView;
@end
