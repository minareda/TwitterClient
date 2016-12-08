//
//  FollowerInfoViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/7/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "FollowerInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FollowerInfoViewController () {

    TWTRSession *_currentSession;
}

@end

@implementation FollowerInfoViewController

+ (id)initViewController    {
    
    return [[self alloc] initWithNibName:@"FollowerInfoView" bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:[NSString stringWithFormat:@"@%@", _user.handle]];
    [self.tableView setTableHeaderView:_headerView];
    NSString *bgImageUrl = [_user.backgroundImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [_imageViewBackground sd_setImageWithURL:[NSURL URLWithString:bgImageUrl]
                            placeholderImage:[UIImage imageNamed:@"profile_background_placeholder.png"]];
    _imageViewProfile.layer.cornerRadius = 4;
    _imageViewProfile.clipsToBounds = YES;
    [_headerView setNeedsLayout];
    [_headerView layoutIfNeeded];
    [_imageViewProfile setImage:(_user.profileimage) ? _user.profileimage : [UIImage imageNamed:@"follower_placeholder.jpg"]];
    
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    self.dataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:_user.handle
                                                                      userID:[NSString stringWithFormat:@"%ld", _user.userId]
                                                                   APIClient:client
                                                         maxTweetsPerRequest:10
                                                              includeReplies:YES
                                                             includeRetweets:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
