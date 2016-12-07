//
//  FollowerInfoViewController.h
//  Twitter
//
//  Created by Mina Reda on 12/7/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TwitterKit/TwitterKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"

@interface FollowerInfoViewController : TWTRTimelineViewController

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewBackground;
@property (weak, nonatomic) IBOutlet UIImageView *imageViewProfile;

+ (id)initViewController;

@end
