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
             @"bio": @"description"
             };
}

@end
