//
//  APIConstants.h
//  Twitter
//
//  Created by Mina Reda on 12/5/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

// Methods URLs
static NSString *const kGetFollowers = @"https://api.twitter.com/1.1/followers/list.json?cursor=%@&screen_name=%@&skip_status=true&include_user_entities=false";

// Response Parameters
static NSString *const kResponseParameterUsers = @"users";
static NSString *const kResponseParameterNextCursor = @"next_cursor_str";
