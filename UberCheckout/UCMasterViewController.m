//
//  UCMasterViewController.m
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import "UCMasterViewController.h"
#import "UCTweetCell.h"
#import "UCDetailViewController.h"

@interface UCMasterViewController () {
    int count;
}
@end

@implementation UCMasterViewController

@synthesize stringToCarry;
@synthesize tweets;
@synthesize aTweet;



- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
//    self.navigationItem.leftBarButtonItem = self.editButtonItem;

//    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
//    self.navigationItem.rightBarButtonItem = addButton;
    
    

    [self searchTweets];
//    NSLog(@"Received String: %@", [self.stringToCarry description]);
}

- (void)viewDidUnload
{
   
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tweets count];
}

// The appearance of the TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UCTweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (cell == nil) {
        
        cell = [[UCTweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    //Add Spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [spinner setCenter:CGPointMake(160, 240)];
    [cell.imageView addSubview:spinner];
    [spinner startAnimating];
    
    dispatch_queue_t fetchTweets = dispatch_queue_create("Tweets Fetcher", NULL);
    dispatch_async(fetchTweets, ^{
        
        aTweet = [tweets objectAtIndex:indexPath.row];
        cell.tweetDetailLabel.text = [aTweet valueForKey:@"text"];
        cell.tweetDetailLabel.adjustsFontSizeToFitWidth = YES;
        cell.tweetDetailLabel.font = [UIFont systemFontOfSize:12];
        cell.tweetDetailLabel.numberOfLines = 4;
        cell.tweetDetailLabel.lineBreakMode = UILineBreakModeWordWrap;
        
        cell.userNameLabel.text = [aTweet valueForKey:@"from_user"];
        
        NSURL *url = [NSURL URLWithString:[aTweet valueForKey:@"profile_image_url"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        [spinner stopAnimating];
        
        
        
//        [self searchTweets];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            cell.userAvatarImageView.image = [UIImage imageWithData:data];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            
            
        });
    });
    
    dispatch_release(fetchTweets);
    [spinner removeFromSuperview];

    return cell;
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return NO;
//}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)searchTweets {
    
    NSString *SEARCH = stringToCarry;
    
    
    
    TWRequest *postRequest = [[TWRequest alloc] initWithURL:[NSURL URLWithString:SEARCH] parameters:nil requestMethod:TWRequestMethodGET];
    
    [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
//        NSString *output;
        NSLog(@"in handler block");
        
        if ([urlResponse statusCode] == 200) {
            
            // deserialize the JSON data
            NSError *jsonParsingError = nil;
            
            NSDictionary *publicTimeline = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonParsingError];
            
            //            output = [NSString stringWithFormat:@"HTTP response status: %i\nPublic Timeline\n%@", [urlResponse statusCode], publicTimeline];
            NSLog(@"Everything seems fine. HTTP response status: %i", [urlResponse statusCode]);
            
            tweets = (NSArray *)[publicTimeline objectForKey:@"results"];
            
            
            [self.tableView reloadData];
            
            // record the tweets count
//            count = tweets.count;
            
            // show how many entries have been retrieved
            NSLog(@"TWEETS COUNT: %i", tweets.count);
            
//            //loop to parse for debug purposes.
//            int ndx;
//            NSMutableDictionary *aTweet;
//            for (ndx = 0; ndx < tweets.count; ndx ++) {
//                aTweet = (NSDictionary *) [tweets objectAtIndex:ndx];
//                NSLog(@"TWEETS: %@", [aTweet valueForKey:@"text"]);
//            }
            
        }
        else {
            
            //            output = [NSString stringWithFormat:@"No feed: HTTP response was: %i\n", [urlResponse statusCode]];
            NSLog(@"Seems something went wrong, HTTP response status: %i", [urlResponse statusCode]);
            
        }
        //        [self performSelectorOnMainThread:@selector(displayResults:) withObject:output waitUntilDone:NO];
    }];
    
    
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//        NSMutableArray *object = [_objects objectAtIndex:indexPath.row];
//        [[segue destinationViewController] setDetailItem:object];
        
        UCDetailViewController *detailViewController = [segue destinationViewController];
        aTweet = [tweets objectAtIndex:indexPath.row];
        detailViewController.tweetDetail = [[NSArray alloc] initWithObjects:[self.aTweet valueForKey:@"from_user_name"], [self.aTweet valueForKey:@"from_user"], [self.aTweet valueForKey:@"text"], [self.aTweet valueForKey:@"created_at"], [self.aTweet valueForKey:@"profile_image_url"], nil];
        
    }
}

@end
