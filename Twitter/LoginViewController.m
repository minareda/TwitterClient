//
//  LoginViewController.m
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "LoginViewController.h"
#import "AppStrings.h"

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

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

@end
