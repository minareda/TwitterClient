//
//  User.m
//  Twitter
//
//  Created by Mina Reda on 12/6/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "User.h"

@implementation User

#pragma mark - Mantle

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{
             @"userId": @"id",
             @"fullName": @"name",
             @"profileImageUrl": @"profile_image_url_https",
             @"backgroundImageUrl": @"profile_background_image_url_https",
             @"handle": @"screen_name",
             @"bio": @"description",
             @"bannerUrl" : @"profile_banner_url"
             };
}

#pragma mark - JSON Transformers

+ (NSValueTransformer *)profileImageUrlJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *url, BOOL *success, NSError *__autoreleasing *error) {
        
        // removing "_normal" from URL for higher resolution profile image
        return [url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    }];
}

+ (NSValueTransformer *)backgroundImageUrlJSONTransformer {
    
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *url, BOOL *success, NSError *__autoreleasing *error) {
        
        // removing "_normal" from URL for higher resolution background image
        return [url stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    }];
}

@end
