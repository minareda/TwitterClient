//
//  APIManager.m
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "APIManager.h"
#import "APIConstants.h"

@implementation APIManager

- (id)init {
    
    self = [super init];
    if(!self) return nil;
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    _currentSession = store.session;
    _client = [[TWTRAPIClient alloc] init];
    return self;
}

+ (id)sharedManager {
    
    static APIManager *_apiManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _apiManager = [[self alloc] init];
    });
    
    return _apiManager;
}

- (BOOL)isAuthenticated {
    
    return (_currentSession != nil);
}

- (NSString *)userName    {
    
    return [_currentSession userName];
}

- (void)logoutCurrentUser   {
    
    TWTRSessionStore *store = [[Twitter sharedInstance] sessionStore];
    [store logOutUserID:[store.session userID]];
}

- (void)getUserFollowersFromCursor:(NSString *)cursor
                           success:(void (^)(GetFollowersResponse* response))success
                           failure:(void (^)(NSError *error))failure {
    
    NSError *clientError;
    NSString *url = [NSString stringWithFormat:kGetFollowers, cursor, [_currentSession userName]];
    NSLog(@"URL: %@", url);
    NSURLRequest *request = [_client URLRequestWithMethod:@"GET" URL:url parameters:nil error:&clientError];
    [_client sendTwitterRequest:request completion:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (data) {
            
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            GetFollowersResponse *followersResponse = [MTLJSONAdapter modelOfClass:GetFollowersResponse.class fromJSONDictionary:json error:nil];
            success(followersResponse);
        } else {
            
            failure(connectionError);
        }
    }];
}

@end
