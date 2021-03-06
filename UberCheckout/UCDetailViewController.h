//
//  UCDetailViewController.h
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) NSArray *tweetDetail;

@property (weak, nonatomic) IBOutlet UILabel *detailTweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *profileNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *userNameLabel;
@property (strong, nonatomic) IBOutlet UIImageView *userAvatarImageView;
@property (strong, nonatomic) IBOutlet UILabel *timeStampLabel;
@end
