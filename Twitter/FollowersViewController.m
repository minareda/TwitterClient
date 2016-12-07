//
//  FollowersViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "FollowersViewController.h"
#import "AppStrings.h"
#import <KVNProgress/KVNProgress.h>
#import "FollowerCell.h"
#import "User.h"
#import <TwitterKit/TwitterKit.h>
#import "APIConstants.h"
#import "UIScrollView+EmptyDataSet.h"
#import "FollowerInfoViewController.h"

@interface FollowersViewController () <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    NSArray *_followers;
    TWTRSession *_currentSession;
    BOOL _loading;
}

- (void)loadFollowers;
- (void)didChangePreferredContentSize:(NSNotification *)notification;

@end

@implementation FollowersViewController

static NSString *const CellIDentifier = @"CELLID";

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"FollowerCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:CellIDentifier];
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [UIView new];

    self.tableView.estimatedRowHeight = 90.0f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didChangePreferredContentSize:)
                                                 name:UIContentSizeCategoryDidChangeNotification object:nil];

    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    _currentSession = store.session;
    [self setTitle:[NSString stringWithFormat:kFollowers, [_currentSession userName]]];
    [self loadFollowers];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIContentSizeCategoryDidChangeNotification
                                                  object:nil];
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
    [self.navigationController pushViewController:followerInfoController animated:YES];
}

#pragma mark - Private methods

- (void)loadFollowers {
    
    _loading = YES;
    [KVNProgress showWithStatus:kLoadingFollowers onView:self.view];
    TWTRAPIClient *client = [[TWTRAPIClient alloc] init];
    NSError *clientError;
    NSString *url = [NSString stringWithFormat:kGetFollowers, [_currentSession userName]];
    NSURLRequest *request = [client URLRequestWithMethod:@"GET" URL:url parameters:nil error:&clientError];
    
    if (request) {
        
        [client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (data) {
                
                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSArray *users = [json objectForKey:@"users"];
                NSMutableArray *followersList = [[NSMutableArray alloc] init];
                for (NSDictionary *userDictionary in users) {
                    
                    User *user = [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:userDictionary error:nil];
                    if (user) {
                        
                        [followersList addObject:user];
                    }
                }
                _followers = followersList;
                _loading = NO;
                [self.tableView reloadData];
            } else {
                
                NSLog(@"Error: %@", connectionError);
                _loading = NO;
            }
            [KVNProgress dismiss];
        }];
    }
    else {
        
        NSLog(@"Error: %@", clientError);
        _loading = NO;
    }
}

- (void)didChangePreferredContentSize:(NSNotification *)notification    {
    
    [self.tableView reloadData];
}

#pragma mark - DZNEmptyDataSetSource Methods

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    return nil;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView   {
    
    if (_loading) {
        
        return nil;
    }
    
    NSString *text = [NSString stringWithFormat:kNoFollowers, [_currentSession userName]];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0],
                                 NSForegroundColorAttributeName: [UIColor colorWithRed:170/255.0 green:171/255.0 blue:179/255.0 alpha:1.0],
                                 NSParagraphStyleAttributeName: paragraphStyle};
    
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:text attributes:attributes];
    [attributedTitle addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:[text rangeOfString:[_currentSession userName]]];
    return attributedTitle;
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView    {
    
    if (_loading) {
        
        return nil;
    }
    
    return [UIImage imageNamed:@"no_followers.png"];
}

@end
