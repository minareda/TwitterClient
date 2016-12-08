//
//  AppStyle.m
//  Twitter
//
//  Created by Mina Reda on 12/7/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//
#import "AppStyle.h"

@implementation AppStyle


+ (void)applyTheme  {
    
    [self applyThemeToNavigationBar];
    [self applyThemeToStatusBar];
}

+ (void)applyThemeToStatusBar   {
    
    // Apply theme to UIStatusBar
}

+ (void)applyThemeToNavigationBar   {
    
    [UINavigationBar appearance].translucent = NO;
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [self appColor];
    [UINavigationBar appearance].barStyle = UIBarStyleBlackTranslucent;
}

+ (UIColor *)appColor {
    
    return [UIColor colorWithRed:29.0f/255.0f green:202.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}


@end
