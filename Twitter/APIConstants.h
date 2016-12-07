//
//  APIConstants.h
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

// Methods URLs
static NSString *const kBaseURL = @"api.twitter.com";
static NSString *const kAuthenticateUser = @"/oauth/authorize";
static NSString *const kGetFollowers = @"https://api.twitter.com/1.1/followers/list.json?cursor=-1&screen_name=%@&skip_status=false&include_user_entities=false";
