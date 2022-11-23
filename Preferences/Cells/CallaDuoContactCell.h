//
//  CallaDuoContactCell.h
//  Calla Utils
//
//  Created by Alexandra (@Traurige)
//

#import <UIKit/UIKit.h>
#import <Preferences/PSSpecifier.h>

@interface CallaDuoContactCell : PSTableCell
@property(nonatomic, retain)UIView* separatorView;
@property(nonatomic, retain)UIImageView* leftUserAvatarImageView;
@property(nonatomic, retain)UIImageView* rightUserAvatarImageView;
@property(nonatomic, retain)UILabel* leftUserDisplayNameLabel;
@property(nonatomic, retain)UILabel* rightUserDisplayNameLabel;
@property(nonatomic, retain)UILabel* leftUserUsernameLabel;
@property(nonatomic, retain)UILabel* rightUserUsernameLabel;
@property(nonatomic, retain)UIView* leftUserTapRecognizerView;
@property(nonatomic, retain)UIView* rightUserTapRecognizerView;
@property(nonatomic, retain)UITapGestureRecognizer* leftUserTap;
@property(nonatomic, retain)UITapGestureRecognizer* rightUserTap;
@property(nonatomic, retain)NSString* leftUserDisplayName;
@property(nonatomic, retain)NSString* rightUserDisplayName;
@property(nonatomic, retain)NSString* leftUserUsername;
@property(nonatomic, retain)NSString* rightUserUsername;
@property(nonatomic, retain)NSString* leftUserUrl;
@property(nonatomic, retain)NSString* rightUserUrl;
- (void)openLeftUserProfile;
- (void)openRightUserProfile;
@end
