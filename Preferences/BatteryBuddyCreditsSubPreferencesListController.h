//
//  BatteryBuddyCreditsSubPreferencesListController.h
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#import <Preferences/PSListController.h>
#import <Preferences/PSListItemsController.h>
#import <Preferences/PSSpecifier.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBAppearanceSettings.h>

@interface BatteryBuddyAppearanceSettings : HBAppearanceSettings
@end

@interface BatteryBuddyCreditsSubPreferencesListController : HBListController
@property(nonatomic, retain)BatteryBuddyAppearanceSettings* appearanceSettings;
@property(nonatomic, retain)UILabel* titleLabel;
@property(nonatomic, retain)UIBlurEffect* blur;
@property(nonatomic, retain)UIVisualEffectView* blurView;
@end
