//
//  AppDelegate.m
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "AppDelegate.h"
#import "FollowersViewController.h"
#import "LoginViewController.h"
#import "SKSplashView.h"
#import "SKSplashIcon.h"
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

@interface AppDelegate ()

- (void)twitterSplash;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [Fabric with:@[[Twitter class]]];
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    TWTRSession *lastSession = store.session;
    // FOR DEBUG ONLY
//    [store logOutUserID:[store.session userID]];
    
    if (!lastSession) {
        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[LoginViewController initViewController]];
    } else {
        
        FollowersViewController *followersController = [[FollowersViewController alloc] initWithStyle:UITableViewStylePlain];
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:followersController];
    }
    
    [self.window makeKeyAndVisible];
    [self twitterSplash];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options    {
    
    if ([[Twitter sharedInstance] application:app openURL:url options:options]) {
        return YES;
    }
    
    // If you handle other (non Twitter Kit) URLs elsewhere in your app, return YES. Otherwise
    return NO;
}

#pragma mark - Private methods

- (void)twitterSplash   {
    
    UIImage *iconImage = [UIImage imageNamed:@"Twitter_Logo_Blue.png"];
    SKSplashIcon *twitterSplashIcon = [[SKSplashIcon alloc] initWithImage:iconImage animationType:SKIconAnimationTypeBounce];
    twitterSplashIcon.iconSize = iconImage.size;
    SKSplashView *splashView = [[SKSplashView alloc] initWithSplashIcon:twitterSplashIcon animationType:SKSplashAnimationTypeBounce];
    splashView.backgroundColor = [UIColor whiteColor];
    splashView.animationDuration = 2;
    [self.window addSubview:splashView];
    [splashView startAnimation];
}

@end
