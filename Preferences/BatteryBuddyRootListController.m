//
//  BatteryBuddyRootListController.m
//  BatteryBuddy
//
//  Created by Alexandra (@Traurige)
//

#include "BatteryBuddyRootListController.h"

@implementation BatteryBuddyRootListController
- (void)viewDidLoad {
    [super viewDidLoad];

    self.appearanceSettings = [[BatteryBuddyAppearanceSettings alloc] init];
    self.hb_appearanceSettings = [self appearanceSettings];
    self.preferences = [[HBPreferences alloc] initWithIdentifier:@"dev.traurige.batterybuddypreferences"];


    // enable switch
    self.enableSwitch = [[UISwitch alloc] init];
    [[self enableSwitch] setOnTintColor:[UIColor colorWithRed:0.31 green:0.78 blue:0.55 alpha:1]];
    [[self enableSwitch] addTarget:self action:@selector(setEnabled) forControlEvents:UIControlEventTouchUpInside];


    // item that holds the enable switch
    self.item = [[UIBarButtonItem alloc] initWithCustomView:[self enableSwitch]];
    [[self navigationItem] setRightBarButtonItem:[self item]];


    // version label
    self.navigationItem.titleView = [[UIView alloc] init];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [[self titleLabel] setFont:[UIFont boldSystemFontOfSize:17]];
    [[self titleLabel] setText:@"1.1"];
    [[self titleLabel] setTextColor:[UIColor whiteColor]];
    [[self titleLabel] setTextAlignment:NSTextAlignmentCenter];
    [[[self navigationItem] titleView] addSubview:[self titleLabel]];

    [[self titleLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self titleLabel] topAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] topAnchor]],
        [[[self titleLabel] leadingAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] leadingAnchor]],
        [[[self titleLabel] trailingAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] trailingAnchor]],
        [[[self titleLabel] bottomAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] bottomAnchor]],
    ]];


    // icon
    self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    [[self iconView] setContentMode:UIViewContentModeScaleAspectFit];
    [[self iconView] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/BatteryBuddyPreferences.bundle/Icon.png"]];
    [[self iconView] setAlpha:0];
    [[[self navigationItem] titleView] addSubview:[self iconView]];

    [[self iconView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self iconView] topAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] topAnchor]],
        [[[self iconView] leadingAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] leadingAnchor]],
        [[[self iconView] trailingAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] trailingAnchor]],
        [[[self iconView] bottomAnchor] constraintEqualToAnchor:[[[self navigationItem] titleView] bottomAnchor]],
    ]];


    // blur
    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleRegular];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:[self blur]];


    // header
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    self.headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [[self headerImageView] setContentMode:UIViewContentModeScaleAspectFill];
    [[self headerImageView] setImage:[UIImage imageWithContentsOfFile:@"/Library/PreferenceBundles/BatteryBuddyPreferences.bundle/Banner.png"]];
    [[self headerImageView] setClipsToBounds:YES];
    [[self headerView] addSubview:[self headerImageView]];

    [[self headerImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
    [NSLayoutConstraint activateConstraints:@[
        [[[self headerImageView] topAnchor] constraintEqualToAnchor:[[self headerView] topAnchor]],
        [[[self headerImageView] leadingAnchor] constraintEqualToAnchor:[[self headerView] leadingAnchor]],
        [[[self headerImageView] trailingAnchor] constraintEqualToAnchor:[[self headerView] trailingAnchor]],
        [[[self headerImageView] bottomAnchor] constraintEqualToAnchor:[[self headerView] bottomAnchor]],
    ]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    CGRect frame = self.table.bounds;
    frame.origin.y = -frame.size.height;

    [[[[self navigationController] navigationController] navigationBar] setBarTintColor:[UIColor whiteColor]];
    [[[[self navigationController] navigationController] navigationBar] setTintColor:[UIColor whiteColor]];
    [[[[self navigationController] navigationController] navigationBar] setShadowImage:[UIImage new]];
    [[[[self navigationController] navigationController] navigationBar] setTranslucent:YES];

    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:1];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:0];
    } completion:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self setEnabledState];
}

- (NSArray *)specifiers {
	if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }

	return _specifiers;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.tableHeaderView = [self headerView];
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = scrollView.contentOffset.y;

    if (offsetY > 200) {
        [UIView animateWithDuration:0.2 animations:^{
            [[self iconView] setAlpha:1];
            [[self titleLabel] setAlpha:0];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            [[self iconView] setAlpha:0];
            [[self titleLabel] setAlpha:1];
        }];
    }
}

- (void)setEnabled {
    if ([[[self preferences] objectForKey:@"enabled"] isEqual:@(YES)] || ![[self preferences] objectForKey:@"enabled"]) {
        [[self preferences] setBool:NO forKey:@"enabled"];
    } else {
        [[self preferences] setBool:YES forKey:@"enabled"];
    }

    [self respring];
}

- (void)setEnabledState {
    if ([[[self preferences] objectForKey:@"enabled"] isEqual:@(YES)] || ![[self preferences] objectForKey:@"enabled"]) {
        [[self enableSwitch] setOn:YES animated:YES];
    } else {
        [[self enableSwitch] setOn:NO animated:YES];
    }
}

- (void)resetPrompt {
    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"BatteryBuddy" message:@"Do you really want to reset your preferences?" preferredStyle:UIAlertControllerStyleActionSheet];

    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        [self resetPreferences];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];
}

- (void)resetPreferences {
    [[self preferences] removeAllObjects];
    [[self enableSwitch] setOn:NO animated:YES];
    [self respring];
}

- (void)respring {
    [[self blurView] setFrame:[[self view] bounds]];
    [[self blurView] setAlpha:0];
    [[self view] addSubview:[self blurView]];

    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [[self blurView] setAlpha:1];
    } completion:^(BOOL finished) {
        if (![[NSFileManager defaultManager] fileExistsAtPath:@"/Library/MobileSubstrate/DynamicLibraries/shuffle.dylib"]) {
            [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=BatteryBuddy"]];
        } else {
            [HBRespringController respringAndReturnTo:[NSURL URLWithString:@"prefs:root=Tweaks&path=BatteryBuddy"]];
        }
    }];
}
@end
