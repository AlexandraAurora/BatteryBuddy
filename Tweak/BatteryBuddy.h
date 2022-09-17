//
//  BatteryBuddy.h
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#import "substrate.h"
#import <UIKit/UIKit.h>

UIImageView* statusBarBatteryIconView;
UIImageView* statusBarBatteryChargerView;
UIImageView* lockscreenBatteryIconView;
UIImageView* lockscreenBatteryChargerView;
BOOL isCharging = NO;

@interface _UIBatteryView : UIView
- (CGFloat)chargePercent;
- (long long)chargingState;
- (void)refreshIcon;
- (void)updateIconColor;
@end

@interface CSBatteryFillView : UIView
@end
