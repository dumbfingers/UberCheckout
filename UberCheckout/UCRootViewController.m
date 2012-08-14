//
//  UCRootViewController.m
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import "UCRootViewController.h"

@interface UCRootViewController ()

@end

@implementation UCRootViewController
@synthesize radiusMeasurement;
@synthesize keyWords;
@synthesize area;
@synthesize scrollView;
@synthesize twitterId;
@synthesize currentAddress;

BOOL isKM = true;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyboard)];
//    tapGesture.cancelsTouchesInView = NO;
//    [scrollView addGestureRecognizer:tapGesture];
    
}

- (void)viewDidUnload
{
    [self setTwitterId:nil];
    [self setCurrentAddress:nil];
    [self setRadiusMeasurement:nil];
    [self setKeyWords:nil];
    [self setArea:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self unregisterForKeyboardNotifications];
}



// Call this method somewhere in the view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];
    
}

// Call this to unregister the notifications
- (void)unregisterForKeyboardNotifications {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, activeField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y-kbSize.height);
        [scrollView setContentOffset:scrollPoint animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    scrollView.contentInset = contentInsets;
    scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)getLocation:(id)sender {
    locationController = [[MyCLController alloc] init];
    [locationController.locationManager startUpdatingLocation];
    
    [currentAddress setText: [locationController getCurrentAddress]];
}

- (IBAction)radiusSelection:(UISegmentedControl *)sender {
    
    switch (self.radiusMeasurement.selectedSegmentIndex) {
        case 0:
            //km selected
            isKM = true;
            NSLog(@"Measurement selected: Km");
            break;
            
        case 1:
            //mi selected
            isKM = false;
            NSLog(@"Measurement selected: Mile");
            break;
            
        default:
            isKM = true;
            break;
    }
}

- (IBAction)searchTweets:(id)sender {
    
    //Get coordinate
    CLLocationCoordinate2D coordinate = [locationController getCurrentCoordinate];
    float latitude = coordinate.latitude;
    float longitude = coordinate.longitude;
    
    //Get Keywords
    NSString *keywords = keyWords.text;
    
    //Get Radius and unit
    NSString *radius = area.text;
    NSString *unit;
    if (isKM) {
        unit = @"km";
    } else {
        unit = @"mi";
    }    
    //Combine to Search term:
    NSString *SEARCH = @"http://search.twitter.com/search.json?q=";
    SEARCH = [SEARCH stringByAppendingFormat:@"%@&geocode=%f,%f,%@%@", keywords, latitude, longitude, radius, unit];
//    [SEARCH stringByAppendingString:@"&geocode="];
//    [SEARCH stringByAppendingString:[[NSString alloc] initWithFormat:@"%f,", latitude]];
//    [SEARCH stringByAppendingString:[[NSString alloc]initWithFormat:@"%f,", longitude]];
//    [SEARCH stringByAppendingString:radius];
    
    NSLog(@"Search Term: %@", SEARCH);
    
    
//    NSString *SEARCH = @"http://search.twitter.com/search.json?q=%E5%90%83&lang=zh&geocode=51.503541694776,-0.11750420041551,20mi";
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:SEARCH] parameters:nil requestMethod:TWRequestMethodGET];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        NSString *output;
        NSArray *latestTweets;
        NSLog(@"in handler block");
        
        if ([urlResponse statusCode] == 200) {
            
            // deserialize the JSON data
            NSError *jsonParsingError = nil;
            
            NSDictionary *publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            
            //            output = [NSString stringWithFormat:@"HTTP response status: %i\nPublic Timeline\n%@", [urlResponse statusCode], publicTimeline];
            NSLog(@"Everything seems fine. HTTP response status: %i", [urlResponse statusCode]);
            
            latestTweets = (NSArray *)[publicTimeline objectForKey:@"results"];
            
            // show how many entries have been retrieved
            NSLog(@"TWEETS: %i", latestTweets.count);
            
            //loop to parse
            int ndx;
            NSMutableDictionary *latestTweet;
            for (ndx = 0; ndx < latestTweets.count; ndx ++) {
                latestTweet = (NSDictionary *) [latestTweets objectAtIndex:ndx];
                NSLog(@"TWEETS: %@", [latestTweet valueForKey:@"text"]);
            }
            
        }
        else {
            
            //            output = [NSString stringWithFormat:@"No feed: HTTP response was: %i\n", [urlResponse statusCode]];
            NSLog(@"Seems something went wrong, HTTP response status: %i", [urlResponse statusCode]);
            
        }
//        [self performSelectorOnMainThread:@selector(displayResults:) withObject:output waitUntilDone:NO];
    }];

    
    
}

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}

- (IBAction)didPressEnd:(id)sender {
    
    [sender resignFirstResponder];
}
@end
