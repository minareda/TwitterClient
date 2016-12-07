//
//  User.h
//  Twitter
//
//  Created by Mina Reda on 12/6/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import <Mantle/Mantle.h>
#import <UIKit/UIKit.h>

@interface User : MTLModel<MTLJSONSerializing>

@property (nonatomic) long userId;
@property (nonatomic, strong) NSString *fullName;
@property (nonatomic, strong) NSString *profileImageUrl;
@property (nonatomic, strong) NSString *backgroundImageUrl;
@property (nonatomic, strong) NSString *handle;
@property (nonatomic, strong) NSString *bio;
@property (nonatomic, strong) UIImage *profileimage;

@end
