//
//  APIManager.m
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "APIManager.h"
#import "APIConstants.h"
#import <NSHash/NSString+NSHash.h>

@interface APIManager ()

@end

@implementation APIManager

- (id)init {
    
    self = [super initWithBaseURL:[NSURL URLWithString:kBaseURL]];
    if(!self) return nil;
    
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    self.requestSerializer = [AFJSONRequestSerializer serializer];
    
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

#pragma mark - Private methods

@end
