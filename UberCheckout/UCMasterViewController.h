//
//  UCMasterViewController.h
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UCMasterViewController : UITableViewController {
    NSMutableArray *tweets;
}


@property (strong, nonatomic) NSString *stringToCarry;
@property (retain, nonatomic) NSMutableArray *tweets;



@end

