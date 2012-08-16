//
//  UCTweetCell.h
//  UberCheckout
//
//  Created by Yaxi Ye on 16/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCTweetCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *tweetDetailLabel;

@end
