//
//  LoginViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "LoginViewController.h"
#import "AppStrings.h"
#import <KVNProgress.h>
#import "FollowersViewController.h"
#import <TwitterKit/TwitterKit.h>
#import "APIManager.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

+ (id)initViewController    {
    
    return [[self alloc] initWithNibName:@"LoginView" bundle:[NSBundle mainBundle]];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setTitle:kLoginTitle];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    TWTRLogInButton *logInButton = [TWTRLogInButton buttonWithLogInCompletion:^(TWTRSession *session, NSError *error) {
        if (session) {
            
            [[[Twitter sharedInstance] sessionStore] saveSession:session
                                                      completion:^(id<TWTRAuthSession>  _Nullable session, NSError * _Nullable error) {
                                                          NSLog(@"%@", error.localizedDescription);
                                                      }];
            [[APIManager sharedManager] updateCurrentSession];
            FollowersViewController *followersController = [[FollowersViewController alloc] initWithStyle:UITableViewStylePlain];
            UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:followersController];
            [self.navigationController presentViewController:navigationController animated:YES completion:nil];
        } else {
            
            [KVNProgress showErrorWithStatus:[error localizedDescription]];
        }
    }];
    [self.view addSubview:logInButton];
    logInButton.center = self.view.center;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
