//
//  UCTweetCell.m
//  UberCheckout
//
//  Created by Yaxi Ye on 16/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import "UCTweetCell.h"

@implementation UCTweetCell

@synthesize userAvatarImageView;
@synthesize userNameLabel;
@synthesize tweetDetailLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
