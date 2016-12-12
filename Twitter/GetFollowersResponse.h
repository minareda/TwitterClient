//
//  GetFollowersResposne.h
//  Twitter
//
//  Created by Mina Reda on 12/12/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface GetFollowersResponse : MTLModel<MTLJSONSerializing>

@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSString *nextCursor;

@end
