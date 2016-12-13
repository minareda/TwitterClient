//
//  FollowerInfoViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/7/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "FollowerInfoViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface FollowerInfoViewController ()

- (void)setup;

@property (nonatomic, assign) BOOL statusBarHidden;
@property (strong, nonatomic) ASMediaFocusManager *mediaFocusManager;

@end

@implementation FollowerInfoViewController

static const int maxTweetsPerRequest = 10;
static const int profileImageTag = 0;
static const int backgroundImageTag = 1;

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

- (BOOL)prefersStatusBarHidden  {
    
    return self.statusBarHidden;
}

#pragma mark - Private methods

- (void)setup {

    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self setTitle:[NSString stringWithFormat:@"@%@", _user.handle]];
//    [self.tableView setTableHeaderView:_headerView];
    [self.tableView setParallaxHeaderView:_headerView
                                      mode:VGParallaxHeaderModeFill
                                    height:CGRectGetHeight(_headerView.frame)];
    
    // Media Viewer
    self.mediaFocusManager = [[ASMediaFocusManager alloc] init];
    self.mediaFocusManager.delegate = self;
    self.mediaFocusManager.elasticAnimation = YES;
    self.mediaFocusManager.focusOnPinch = YES;
    
    // Load background image
    NSString *bgImageUrl = [_user.backgroundImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    [_imageViewBackground sd_setImageWithURL:[NSURL URLWithString:bgImageUrl]
                            placeholderImage:[UIImage imageNamed:@"profile_background_placeholder.png"]];
    _imageViewBackground.tag = backgroundImageTag;
    
    // Load Profile image
    [_imageViewProfile setImage:(_user.profileimage) ? _user.profileimage : [UIImage imageNamed:@"follower_placeholder.jpg"]];
    _imageViewProfile.layer.cornerRadius = 4;
    _imageViewProfile.clipsToBounds = YES;
    _imageViewProfile.tag = profileImageTag;
    
    [self.mediaFocusManager installOnView:_imageViewProfile];
    [self.mediaFocusManager installOnView:_imageViewBackground];

    [_headerView setNeedsLayout];
    [_headerView layoutIfNeeded];
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    
    // This must be called in order to work
    [scrollView shouldPositionParallaxHeader];
        
    // This is how you can implement appearing or disappearing of sticky view
    [scrollView.parallaxHeader.stickyView setAlpha:scrollView.parallaxHeader.progress];
}

#pragma mark - ASMediasFocusDelegate methods

- (UIViewController *)parentViewControllerForMediaFocusManager:(ASMediaFocusManager *)mediaFocusManager {
    
    return self;
}

- (NSURL *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager mediaURLForView:(UIView *)view    {
    
    if (view.tag == profileImageTag) {
        
        return [NSURL URLWithString:[_user.profileImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""]];
    } else {
        
        return [NSURL URLWithString:[_user.backgroundImageUrl stringByReplacingOccurrencesOfString:@"_normal" withString:@""]];
    }
}

- (NSString *)mediaFocusManager:(ASMediaFocusManager *)mediaFocusManager titleForView:(UIView *)view   {
    
    return @"";
}

- (void)mediaFocusManagerWillAppear:(ASMediaFocusManager *)mediaFocusManager    {
    
    self.statusBarHidden = YES;
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)mediaFocusManagerWillDisappear:(ASMediaFocusManager *)mediaFocusManager {
    
    self.statusBarHidden = NO;
    if([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])  {
        
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

@end
