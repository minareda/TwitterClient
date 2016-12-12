//
//  APIManager.h
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>
#import "Models.h"

@interface APIManager : NSObject {
    
    TWTRSession *_currentSession;
    TWTRAPIClient *_client;
}

+ (id)sharedManager;
- (void)updateCurrentSession;
- (BOOL)isOffline;
- (BOOL)isAuthenticated;
- (NSString *)userName;
- (void)logoutCurrentUser;
- (void)getUserFollowersFromCursor:(NSString *)cursor
                           success:(void (^)(GetFollowersResponse* response))success
                           failure:(void (^)(NSError *error))failure;

@end
