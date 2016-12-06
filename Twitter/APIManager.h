//
//  APIManager.h
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"
#import "Models.h"

@interface APIManager : AFHTTPSessionManager

+ (id)sharedManager;

@end
