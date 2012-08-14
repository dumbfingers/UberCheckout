//
//  UCRootViewController.h
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyCLController.h"

@interface UCRootViewController : UIViewController {
    MyCLController *locationController;
    IBOutlet UITextField *activeField;
    
}

- (IBAction)getLocation:(id)sender;
- (IBAction)radiusSelection:(UISegmentedControl *)sender;
- (IBAction)searchTweets:(id)sender;
//- (IBAction)backgroundTouched:(id)sender;
- (IBAction)didPressEnd:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *twitterId;
@property (weak, nonatomic) IBOutlet UITextField *currentAddress;
@property (weak, nonatomic) IBOutlet UISegmentedControl *radiusMeasurement;
@property (weak, nonatomic) IBOutlet UITextField *keyWords;
@property (weak, nonatomic) IBOutlet UITextField *area;


@end
