//
//  BatteryBuddyAppearanceSettings.m
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#import "BatteryBuddyRootListController.h"

@implementation BatteryBuddyAppearanceSettings
- (UIColor *)tintColor {
    return [UIColor colorWithRed:0.31 green:0.92 blue:0.51 alpha:1];
}

- (UIStatusBarStyle)statusBarStyle {
    return UIStatusBarStyleDarkContent;
}

- (UIColor *)navigationBarTitleColor {
    return [UIColor whiteColor];
}

- (UIColor *)navigationBarTintColor {
    return [UIColor whiteColor];
}

- (UIColor *)tableViewCellSeparatorColor {
    return [[UIColor whiteColor] colorWithAlphaComponent:0];
}

- (UIColor *)navigationBarBackgroundColor {
    return [UIColor colorWithRed:0.31 green:0.92 blue:0.51 alpha:1];
}

- (BOOL)translucentNavigationBar {
    return YES;
}
@end
