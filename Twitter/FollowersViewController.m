//
//  FollowersViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "FollowersViewController.h"
#import <KVNProgress/KVNProgress.h>
#import "UIScrollView+EmptyDataSet.h"
#import "FollowerCell.h"
#import "Models.h"
#import "AppStrings.h"
#import "AppStyle.h"
#import "APIManager.h"
#import "APIConstants.h"
#import "FollowerInfoViewController.h"
#import "LoginViewController.h"

@interface FollowersViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    NSMutableArray *_followers;
    BOOL _loading;
    NSString *_cursor;
    NSError *_loadingError;
    UILabel *_labelFooter;
}

- (void)setup;
- (void)loadFollowers:(id)sender;
- (void)updateUI;
- (void)signout;

@end

@implementation FollowersViewController

static NSString *const CellIDentifier = @"CELLID";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setup];
    [self loadFollowers:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - UITableViewDataSource methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView   {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _followers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FollowerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIDentifier];
    User *user = [_followers objectAtIndex:indexPath.row];
    [cell setUser:user];
    
    if (!_loading && indexPath.row == [_followers count] - 1 && ![_cursor isEqual: @"0"]) {
        
        [self loadFollowers:nil];
    }
    
    return cell;
}

#pragma mark - UITableViewDelegate methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  {
    
    return UITableViewAutomaticDimension;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    User *user = [_followers objectAtIndex:indexPath.row];
    FollowerInfoViewController *followerInfoController = [FollowerInfoViewController initViewController];
    [followerInfoController setUser:user];
    [self setTitle:@" "];
    [self.navigationController pushViewController:followerInfoController animated:YES];
}

#pragma mark - Private methods

- (void)setup {
    
    self.navigationController.delegate = self;
    _followers = [[NSMutableArray alloc] init];
    
    // Add sign out button
    UIBarButtonItem *buttonSignout = [[UIBarButtonItem alloc] initWithTitle:kSignout
                                                                      style:UIBarButtonItemStylePlain
                                                                     target:self
                                                                     action:@selector(signout)];
    [self.navigationItem setRightBarButtonItem:buttonSignout];
    
    // Setup TableView
    [self.tableView registerNib:[UINib nibWithNibName:@"FollowerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIDentifier];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    UIView *tableFooter = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.view.frame), 50.0f)];
    [tableFooter setBackgroundColor:[UIColor whiteColor]];
    _labelFooter = [[UILabel alloc] initWithFrame:tableFooter.frame];
    [_labelFooter setTextAlignment:NSTextAlignmentCenter];
    [_labelFooter setTextColor:[UIColor lightGrayColor]];
    [_labelFooter setFont:[UIFont italicSystemFontOfSize:13.0f]];
    [tableFooter addSubview:_labelFooter];
    [self.tableView setTableFooterView:tableFooter];
    _cursor = @"-1";
    
    // Pull to refresh
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [AppStyle appColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(loadFollowers:) forControlEvents:UIControlEventValueChanged];

//    // For removing the cell separators
//    self.tableView.tableFooterView = [UIView new];
    
    // Dynamic Height
    self.tableView.estimatedRowHeight = 80.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    // Title
    [self setTitle:[NSString stringWithFormat:kFollowers, [[APIManager sharedManager] userName]]];
}

- (void)loadFollowers:(id)sender {
    
    // Check if refresh is initiated
    if (sender) {
        
        _cursor = @"-1";
    } else {
        
        // Check if you have loaded all followers
        if ([_cursor isEqualToString:@"0"] || _loading == YES)
            return;
    }
    
    _loading = YES;
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    if([_followers count] == 0) {
        
        [KVNProgress showWithStatus:kLoadingFollowers onView:self.view];
    }
    
    [[APIManager sharedManager] getUserFollowersFromCursor:_cursor success:^(GetFollowersResponse *response) {
        
        if (response) {
            
            if ([_cursor isEqualToString:@"-1"]) {
             
                [_followers removeAllObjects];
            }
            
            if ([response.users count] > 0) {
                
                [_followers addObjectsFromArray:response.users];
            }
            _cursor = response.nextCursor;
            NSLog(@"Cursor: %@", _cursor);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self updateUI];
            });
        }
    } failure:^(NSError *error) {
    
        _loadingError = error;
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self updateUI];
        });
    }];
}

- (void)updateUI {
    
    _loading = NO;
    [KVNProgress dismiss];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.refreshControl endRefreshing];
    [self.tableView reloadData];
    if ([_followers count] > 0) {
        
        [_labelFooter setText:[NSString stringWithFormat:kFollowersCount, (unsigned long)_followers.count]];
    }
}

- (void)signout {

    [[APIManager sharedManager] logoutCurrentUser];
    [self.navigationController pushViewController:[LoginViewController initViewController] animated:YES];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView   {
    
    if (_loading) {
        
        return nil;
    }
    
    NSString *text;
    if (_loadingError) {
        
        text = [_loadingError localizedFailureReason];
        _loadingError = nil;
    } else {
        
        text = [NSString stringWithFormat:kNoFollowers, [[APIManager sharedManager] userName]];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    [attributedTitle addAttribute:NSFontAttributeName
                            value:[UIFont boldSystemFontOfSize:17.0]
                            range:[text rangeOfString:[[APIManager sharedManager] userName]]];
    return attributedTitle;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView    {
    
    if (_loading) {
        
        return nil;
    }
    
    return [UIImage imageNamed:@"no_followers.png"];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state    {
    
    if (_loading) {
        
        return nil;
    }
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:15.0f], NSForegroundColorAttributeName: [AppStyle appColor]};
    return [[NSAttributedString alloc] initWithString:kTryAgain attributes:attributes];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    [self loadFollowers:button];
}

#pragma mark - UINavigationControllerDelegate methods

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if (viewController == self) {

        [self setTitle:[NSString stringWithFormat:kFollowers, [[APIManager sharedManager] userName]]];
    }
}

@end
