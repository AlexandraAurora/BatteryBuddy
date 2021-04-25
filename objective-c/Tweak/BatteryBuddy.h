#import <UIKit/UIKit.h>

UIImageView* batteryIconView;
UIImageView* batteryChargerView;
UIImageView* LSBatteryIconView;
UIImageView* LSBatteryChargerView;
BOOL isCharging = NO;
BOOL isLowPowerModeActive = NO;

@interface _UIBatteryView : UIView
- (CGFloat)chargePercent;
- (long long)chargingState;
- (void)refreshIcon;
- (void)updateIconColor;
@end

@interface CSBatteryFillView : UIView
@end