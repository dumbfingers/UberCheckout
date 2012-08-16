//
//  UCDetailViewController.m
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import "UCDetailViewController.h"

@interface UCDetailViewController ()
- (void)configureView;
@end

@implementation UCDetailViewController

#pragma mark - Managing the detail item
@synthesize tweetDetail;
@synthesize profileNameLabel;
@synthesize userNameLabel;
@synthesize userAvatarImageView;
@synthesize timeStampLabel;

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailTweetLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
    self.profileNameLabel.text = [self.tweetDetail objectAtIndex:0];
    self.userNameLabel.text = [NSString stringWithFormat:@"@%@",[self.tweetDetail objectAtIndex:1]];
    self.detailTweetLabel.text = [self.tweetDetail objectAtIndex:2];
    self.timeStampLabel.text = [self.tweetDetail objectAtIndex:3];
    NSURL *url = [NSURL URLWithString: [self.tweetDetail objectAtIndex:4]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    self.userAvatarImageView.image = [UIImage imageWithData:data];
}

- (void)viewDidUnload
{
    [self setProfileNameLabel:nil];
    [self setUserNameLabel:nil];
    [self setUserAvatarImageView:nil];
    [self setTimeStampLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
