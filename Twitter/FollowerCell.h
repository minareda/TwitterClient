//
//  FollowerCell.h
//  Twitter
//
//  Created by Mina Reda on 12/6/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "User.h"

@interface FollowerCell : UITableViewCell {
    
    User *_user;
}

@property (nonatomic, strong) User *user;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *labelName;
@property (weak, nonatomic) IBOutlet UILabel *labelHandle;
@property (weak, nonatomic) IBOutlet UILabel *labelBio;


@end
