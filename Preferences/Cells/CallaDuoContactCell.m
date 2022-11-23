//
//  CallaDuoContactCell.m
//  Calla Utils
//
//  Created by Alexandra (@Traurige)
//

#import "CallaDuoContactCell.h"

@implementation CallaDuoContactCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
	self = [super initWithStyle:style reuseIdentifier:reuseIdentifier specifier:specifier];

    if (self) {
        [self setLeftUserDisplayName:[specifier properties][@"LeftUserDisplayName"]];
        [self setRightUserDisplayName:[specifier properties][@"RightUserDisplayName"]];
        [self setLeftUserUsername:[specifier properties][@"LeftUserUsername"]];
        [self setRightUserUsername:[specifier properties][@"RightUserUsername"]];
        [self setLeftUserUrl:[specifier properties][@"LeftUserUrl"]];
        [self setRightUserUrl:[specifier properties][@"RightUserUrl"]];

        // separator
        [self setSeparatorView:[[UIView alloc ] init]];
        [[self separatorView] setBackgroundColor:[[UIColor labelColor] colorWithAlphaComponent:0.1]];
        [self addSubview:[self separatorView]];

        [[self separatorView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self separatorView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self separatorView] centerXAnchor] constraintEqualToAnchor:[self centerXAnchor]],
            [[[self separatorView] heightAnchor] constraintEqualToConstant:48],
            [[[self separatorView] widthAnchor] constraintEqualToConstant:1]
        ]];


        // left user
        // avatar image view
        [self setLeftUserAvatarImageView:[[UIImageView alloc] init]];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            UIImage* avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.traurige.dev/v1/avatar?username=%@", [self leftUserUsername]]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:[self leftUserAvatarImageView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    [[self leftUserAvatarImageView] setImage:avatar];
                } completion:nil];
            });
        });

        [[self leftUserAvatarImageView] setContentMode:UIViewContentModeScaleAspectFill];
        [[self leftUserAvatarImageView] setClipsToBounds:YES];
        [[[self leftUserAvatarImageView] layer] setCornerRadius:21.5];
        [[[self leftUserAvatarImageView] layer] setBorderWidth:2];
        [[[self leftUserAvatarImageView] layer] setBorderColor:[[[UIColor labelColor] colorWithAlphaComponent:0.1] CGColor]];
        [self addSubview:[self leftUserAvatarImageView]];

        [[self leftUserAvatarImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self leftUserAvatarImageView] centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]],
            [[[self leftUserAvatarImageView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor] constant:16],
            [[[self leftUserAvatarImageView] widthAnchor] constraintEqualToConstant:43],
            [[[self leftUserAvatarImageView] heightAnchor] constraintEqualToConstant:43]
        ]];


        // display name label
        [self setLeftUserDisplayNameLabel:[[UILabel alloc] init]];
        [[self leftUserDisplayNameLabel] setText:[self leftUserDisplayName]];
        [[self leftUserDisplayNameLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
        [[self leftUserDisplayNameLabel] setTextColor:[UIColor labelColor]];
        [self addSubview:[self leftUserDisplayNameLabel]];

        [[self leftUserDisplayNameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self leftUserDisplayNameLabel] topAnchor] constraintEqualToAnchor:[[self leftUserAvatarImageView] topAnchor] constant:4],
            [[[self leftUserDisplayNameLabel] leadingAnchor] constraintEqualToAnchor:[[self leftUserAvatarImageView] trailingAnchor] constant:8],
            [[[self leftUserDisplayNameLabel] trailingAnchor] constraintEqualToAnchor:[[self separatorView] leadingAnchor] constant:16]
        ]];


        // username label
        [self setLeftUserUsernameLabel:[[UILabel alloc] init]];
        [[self leftUserUsernameLabel] setText:[NSString stringWithFormat:@"@%@", [self leftUserUsername]]];
        [[self leftUserUsernameLabel] setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
        [[self leftUserUsernameLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.6]];
        [self addSubview:[self leftUserUsernameLabel]];

        [[self leftUserUsernameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self leftUserUsernameLabel] leadingAnchor] constraintEqualToAnchor:[[self leftUserAvatarImageView] trailingAnchor] constant:8],
            [[[self leftUserUsernameLabel] trailingAnchor] constraintEqualToAnchor:[[self leftUserDisplayNameLabel] trailingAnchor]],
            [[[self leftUserUsernameLabel] bottomAnchor] constraintEqualToAnchor:[[self leftUserAvatarImageView] bottomAnchor] constant:-4]
        ]];


        // tap view
        [self setLeftUserTapRecognizerView:[[UIView alloc] init]];
        [self addSubview:[self leftUserTapRecognizerView]];

        [[self leftUserTapRecognizerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self leftUserTapRecognizerView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self leftUserTapRecognizerView] leadingAnchor] constraintEqualToAnchor:[self leadingAnchor]],
            [[[self leftUserTapRecognizerView] trailingAnchor] constraintEqualToAnchor:[[self separatorView] trailingAnchor]],
            [[[self leftUserTapRecognizerView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // tap
        [self setLeftUserTap:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openLeftUserProfile)]];
        [[self leftUserTapRecognizerView] addGestureRecognizer:[self leftUserTap]];


        // right user
        // avatar image view
        [self setRightUserAvatarImageView:[[UIImageView alloc] init]];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
            UIImage* avatar = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://api.traurige.dev/v1/avatar?username=%@", [self rightUserUsername]]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView transitionWithView:[self rightUserAvatarImageView] duration:0.2 options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                    [[self rightUserAvatarImageView] setImage:avatar];
                } completion:nil];
            });
        });

        [[self rightUserAvatarImageView] setContentMode:UIViewContentModeScaleAspectFill];
        [[self rightUserAvatarImageView] setClipsToBounds:YES];
        [[[self rightUserAvatarImageView] layer] setCornerRadius:21.5];
        [[[self rightUserAvatarImageView] layer] setBorderWidth:2];
        [[[self rightUserAvatarImageView] layer] setBorderColor:[[[UIColor labelColor] colorWithAlphaComponent:0.1] CGColor]];
        [self addSubview:[self rightUserAvatarImageView]];

        [[self rightUserAvatarImageView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self rightUserAvatarImageView] centerYAnchor] constraintEqualToAnchor:[self centerYAnchor]],
            [[[self rightUserAvatarImageView] leadingAnchor] constraintEqualToAnchor:[[self separatorView] leadingAnchor] constant:16],
            [[[self rightUserAvatarImageView] widthAnchor] constraintEqualToConstant:43],
            [[[self rightUserAvatarImageView] heightAnchor] constraintEqualToConstant:43]
        ]];


        // display name label
        [self setRightUserDisplayNameLabel:[[UILabel alloc] init]];
        [[self rightUserDisplayNameLabel] setText:[self rightUserDisplayName]];
        [[self rightUserDisplayNameLabel] setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]];
        [[self rightUserDisplayNameLabel] setTextColor:[UIColor labelColor]];
        [self addSubview:[self rightUserDisplayNameLabel]];

        [[self rightUserDisplayNameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self rightUserDisplayNameLabel] topAnchor] constraintEqualToAnchor:[[self leftUserAvatarImageView] topAnchor] constant:4],
            [[[self rightUserDisplayNameLabel] leadingAnchor] constraintEqualToAnchor:[[self rightUserAvatarImageView] trailingAnchor] constant:8],
            [[[self rightUserDisplayNameLabel] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor] constant:-16]
        ]];


        // username label
        [self setRightUserUsernameLabel:[[UILabel alloc] init]];
        [[self rightUserUsernameLabel] setText:[NSString stringWithFormat:@"@%@", [self rightUserUsername]]];
        [[self rightUserUsernameLabel] setFont:[UIFont systemFontOfSize:11 weight:UIFontWeightRegular]];
        [[self rightUserUsernameLabel] setTextColor:[[UIColor labelColor] colorWithAlphaComponent:0.6]];
        [self addSubview:[self rightUserUsernameLabel]];

        [[self rightUserUsernameLabel] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self rightUserUsernameLabel] leadingAnchor] constraintEqualToAnchor:[[self rightUserAvatarImageView] trailingAnchor] constant:8],
            [[[self rightUserUsernameLabel] trailingAnchor] constraintEqualToAnchor:[[self rightUserDisplayNameLabel] trailingAnchor]],
            [[[self rightUserUsernameLabel] bottomAnchor] constraintEqualToAnchor:[[self rightUserAvatarImageView] bottomAnchor] constant:-4]
        ]];


        // tap view
        [self setRightUserTapRecognizerView:[[UIView alloc] init]];
        [self addSubview:[self rightUserTapRecognizerView]];

        [[self rightUserTapRecognizerView] setTranslatesAutoresizingMaskIntoConstraints:NO];
        [NSLayoutConstraint activateConstraints:@[
            [[[self rightUserTapRecognizerView] topAnchor] constraintEqualToAnchor:[self topAnchor]],
            [[[self rightUserTapRecognizerView] leadingAnchor] constraintEqualToAnchor:[[self separatorView] trailingAnchor]],
            [[[self rightUserTapRecognizerView] trailingAnchor] constraintEqualToAnchor:[self trailingAnchor]],
            [[[self rightUserTapRecognizerView] bottomAnchor] constraintEqualToAnchor:[self bottomAnchor]]
        ]];


        // tap
        [self setRightUserTap:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openRightUserProfile)]];
        [[self rightUserTapRecognizerView] addGestureRecognizer:[self rightUserTap]];
    }

	return self;
}

- (void)openLeftUserProfile {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self leftUserUrl]] options:@{} completionHandler:nil];
}

- (void)openRightUserProfile {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self rightUserUrl]] options:@{} completionHandler:nil];
}
@end
