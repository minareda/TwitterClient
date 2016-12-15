//
//  FollowerInfoViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/7/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "FollowerInfoViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "APIManager.h"
#import "EXPhotoViewer.h"

@interface FollowerInfoViewController ()

- (void)setup;
- (void)imageTapped:(id)sender;

@end

@implementation FollowerInfoViewController

static const int maxTweetsPerRequest = 10;

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
                                                         maxTweetsPerRequest:maxTweetsPerRequest
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
    _headerView.backgroundImage = [UIImage imageNamed:@"profile_background_placeholder.png"];
    
    // Load Profile image
    [_imageViewProfile setImage:(_user.profileimage) ? _user.profileimage : [UIImage imageNamed:@"follower_placeholder.jpg"]];
    _imageViewProfile.layer.cornerRadius = 4;
    _imageViewProfile.clipsToBounds = YES;
    
    // Add profile image tap gestures
    UITapGestureRecognizer *profileImageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [profileImageTapGesture setNumberOfTapsRequired:1];
    [_imageViewProfile setUserInteractionEnabled:YES];
    [_imageViewProfile addGestureRecognizer:profileImageTapGesture];
    
    // Load background image
    [_backgroundImageActivityIndicator startAnimating];
    NSString *backgroundImageUrl = (_user.bannerUrl) ? _user.bannerUrl : _user.backgroundImageUrl;
    [[APIManager sharedManager] downloadImageWithURL:backgroundImageUrl success:^(UIImage *image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            _headerView.backgroundImage = image;
            [_backgroundImageActivityIndicator stopAnimating];
            
            // Add background image tap gestures
            UITapGestureRecognizer *backgroundImageTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
            [backgroundImageTapGesture setNumberOfTapsRequired:1];
            [_headerView.backgroundImageView setUserInteractionEnabled:YES];
            [_headerView.backgroundImageView addGestureRecognizer:backgroundImageTapGesture];
        });
    } failure:^(NSError *error) {
    
        dispatch_async(dispatch_get_main_queue(), ^{

            [_backgroundImageActivityIndicator stopAnimating];
        });
    }];
}

- (void)imageTapped:(id)sender  {
    
    UIImageView *tappedImageView = (UIImageView *)[(UIGestureRecognizer *)sender view];
    [EXPhotoViewer showImageFrom:tappedImageView];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    
    if (scrollView == self.tableView)   {
        
        [self.headerView offsetDidUpdate:scrollView.contentOffset];
    }
}

@end
