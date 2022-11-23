//
//  BatteryBuddy.h
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#import "substrate.h"
#import <UIKit/UIKit.h>
#import "../Preferences/PreferenceKeys.h"

UIImageView* statusBarBatteryIconView;
UIImageView* statusBarBatteryChargerView;
UIImageView* lockscreenBatteryIconView;
UIImageView* lockscreenBatteryChargerView;
BOOL isCharging = NO;

// preferences
NSUserDefaults* preferences;
BOOL pfEnabled;
BOOL pfShowInStatusBar;
BOOL pfShowOnLockScreen;

@interface _UIBatteryView : UIView
- (CGFloat)chargePercent;
- (long long)chargingState;
- (void)refreshIcon;
- (void)updateIconColor;
@end

@interface CSBatteryFillView : UIView
@end
