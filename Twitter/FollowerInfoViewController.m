//
//  FollowerInfoViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/7/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "FollowerInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GGFullscreenImageViewController.h"

@interface FollowerInfoViewController ()

- (void)setup;
- (void)imageTapped:(id)sender;

@end

@implementation FollowerInfoViewController

+ (id)initViewController    {
    
    return [[self alloc] initWithNibName:@"FollowerInfoView" bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setup];

    // Load follower timeline
    self.dataSource = [[TWTRUserTimelineDataSource alloc] initWithScreenName:_user.handle
                                                                      userID:[NSString stringWithFormat:@"%ld", _user.userId]
                                                                   APIClient:[[TWTRAPIClient alloc] init]
                                                         maxTweetsPerRequest:10
                                                              includeReplies:YES
                                                             includeRetweets:YES];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Private methods

- (void)setup {

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:[NSString stringWithFormat:@"@%@", _user.handle]];
    [self.tableView setTableHeaderView:_headerView];
    
    // Load background image
    NSString *bgImageUrl = [_user.backgroundImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [_imageViewBackground sd_setImageWithURL:[NSURL URLWithString:bgImageUrl]
                            placeholderImage:[UIImage imageNamed:@"profile_background_placeholder.png"]];
    
    // Load Profile image
    [_imageViewProfile setImage:(_user.profileimage) ? _user.profileimage : [UIImage imageNamed:@"follower_placeholder.jpg"]];
    _imageViewProfile.layer.cornerRadius = 4;
    _imageViewProfile.clipsToBounds = YES;
    
    // Add tap gestures
    UITapGestureRecognizer *profileImageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [profileImageTapGesture setNumberOfTapsRequired:1];
    [_imageViewProfile setUserInteractionEnabled:YES];
    [_imageViewProfile addGestureRecognizer:profileImageTapGesture];
    
    UITapGestureRecognizer *backgroundImageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [backgroundImageTapGesture setNumberOfTapsRequired:1];
    [_imageViewBackground setUserInteractionEnabled:YES];
    [_imageViewBackground addGestureRecognizer:backgroundImageTapGesture];

    [_headerView setNeedsLayout];
    [_headerView layoutIfNeeded];
}

- (void)imageTapped:(id)sender  {
    
    UIImageView *tappedImageView = (UIImageView *)[(UIGestureRecognizer *)sender view];
    GGFullscreenImageViewController *imageViewController = [[GGFullscreenImageViewController alloc] init];
    // Giving the controller a copy to maintain the original image intact
    imageViewController.liftedImageView = [[UIImageView alloc] initWithImage:tappedImageView.image];
    imageViewController.liftedImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self presentViewController:imageViewController animated:YES completion:nil];
}

@end
