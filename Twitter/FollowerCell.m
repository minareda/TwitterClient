//
//  FollowerCell.m
//  Twitter
//
//  Created by Mina Reda on 12/6/16.
//  Copyright © 2016 Eventtus. All rights reserved.
//

#import "FollowerCell.h"

@implementation FollowerCell
@dynamic user;

- (void)setUser:(User *)user {

    _user = user;
    [_profileImageView sd_setImageWithURL:[NSURL URLWithString:_user.profileImageUrl]
                       placeholderImage:[UIImage imageNamed:@"follower_placeholder.jpg"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                           
                           _user.profileimage = image;
                       }];
    
    [_labelName setText:_user.fullName];
    [_labelHandle setText:[NSString stringWithFormat:@"@%@", _user.handle]];
    [_labelBio setText:_user.bio];
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    _profileImageView.layer.cornerRadius = 4;
    _profileImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews  {
    
    [super layoutSubviews];
    [self.contentView layoutIfNeeded];
    _labelBio.preferredMaxLayoutWidth = CGRectGetWidth(_labelBio.frame);
}

@end
