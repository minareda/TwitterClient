//
//  GetFollowersResposne.m
//  Twitter
//
//  Created by Mina Reda on 12/12/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "GetFollowersResponse.h"
#import "User.h"

@implementation GetFollowersResponse

#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"users": @"users",
             @"nextCursor": @"next_cursor_str"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)usersJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSArray *usersResponse, BOOL *success, NSError *__autoreleasing *error) {
        
        NSMutableArray *usersArray = [[NSMutableArray alloc] init];
        for(NSDictionary *userDictionary in usersResponse) {
            
            User *user = [MTLJSONAdapter modelOfClass:User.class fromJSONDictionary:userDictionary error:nil];
            [usersArray addObject:user];
            // We could have used TWTRUser model that is inside TwitterKit framework but i prefered to create my user class
        }
        return usersArray;
    }];
    
    // It should have been like this but its not working (seems to be an issue with Mantle)
    //return [MTLJSONAdapter arrayTransformerWithModelClass:User.class];
}

@end
