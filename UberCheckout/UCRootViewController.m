//
//  UCRootViewController.m
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import "UCRootViewController.h"
#import "UCMasterViewController.h"

@interface UCRootViewController () {

BOOL isKM;
BOOL isGetLocationPressed;

}

@end

@implementation UCRootViewController
@synthesize radiusMeasurement;
@synthesize keyWords;
@synthesize area;
@synthesize scrollView;
@synthesize twitterId;
@synthesize currentAddress;
@synthesize avatar;



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
    
    [self getSelfTwitterAccount];

    isKM = TRUE;
    isGetLocationPressed = FALSE;
    currentAddress.delegate = self;
    area.delegate = self;
    keyWords.delegate = self;
    
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


#pragma mark Keyboard management
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
    // Made lots of calculation here, much differece between the one shown on Apple Doc.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    if (aRect.size.height < activeField.frame.origin.y+activeField.frame.size.height) {
        CGPoint scrollPoint = CGPointMake(0.0, activeField.frame.origin.y+activeField.frame.size.height-aRect.size.height);
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

//#pragma mark Method to combine the search term
//- (void)combineSearchTermWith:(CLLocationCoordinate2D)coordinate withKeyword:(NSString *)keyword withRangeOf:(NSString *)radius
//{
//    
//
//}

- (void)getSelfTwitterAccount
{
    
    ACAccountStore *twitterAccount = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [twitterAccount accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    
    
    [twitterAccount requestAccessToAccountsWithType:accountType withCompletionHandler:^(BOOL granted, NSError *error) {
        
        if (granted == YES) {
            
            ACAccount *myTwitterAccount = [[twitterAccount accountsWithAccountType:accountType] objectAtIndex:0];
            NSString *screenName = myTwitterAccount.username;
            twitterId.text = screenName;
            
            //get Avatar
            NSString *baseURL = @"http://search.twitter.com/search.json?q=";
            NSString *searchTerm = [baseURL stringByAppendingFormat:@"%@", screenName];
            TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:searchTerm] parameters:nil requestMethod:TWRequestMethodGET];
            [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                
                
                if ([urlResponse statusCode] == 200) {
                    
                    // deserialize the JSON data
                    NSError *jsonParsingError = nil;
                    
                    
                    NSDictionary *rawData = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
                    
                    NSLog(@"Everything seems fine. HTTP response status: %i", [urlResponse statusCode]);
                    
                    NSArray *raw = [rawData objectForKey:@"results"];
                    
                    NSDictionary *rawAvatar = [raw objectAtIndex:0];
                    NSURL *avatarURL = [NSURL URLWithString:[rawAvatar valueForKey:@"profile_image_url"]];
                    NSData *data = [NSData dataWithContentsOfURL:avatarURL];
                    avatar.image = [UIImage imageWithData:data];
                }

                
            }];
            
        } else {
            //metnion that the app cannot get the twitter user name
        }
    }];
    
//    NSLog(@"My Twitter Name: %@", screenName);
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"performSearch"]) {
        
        //Combine the search term
        
        //Get coordinate
        CLLocationCoordinate2D coordinate;
        if (isGetLocationPressed) {
            
            coordinate = [locationController getCurrentCoordinate];
            
            
        } else {
            
            coordinate = [locationController getCurrentCoordinateFromAddress:currentAddress.text];
            
        }
        
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
        
        NSLog(@"Search Term: %@", SEARCH);
        
        UCMasterViewController *destViewController = segue.destinationViewController;
        
        destViewController.stringToCarry = SEARCH;
    }
}

- (IBAction)getLocation:(id)sender {
    
    isGetLocationPressed = true;
    locationController = [[MyCLController alloc] init];
    [locationController.locationManager startUpdatingLocation];    
    [currentAddress setText: [locationController getCurrentAddress]];
    
}

#pragma mark Record user selection of the distance unit
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

- (IBAction)backgroundTouched:(id)sender {
    [self.view endEditing:YES];
    [self.view resignFirstResponder];
}

- (IBAction)didPressEnd:(id)sender {
    
    [sender resignFirstResponder];
}
@end
