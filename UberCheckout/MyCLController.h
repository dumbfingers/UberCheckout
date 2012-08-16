//
//  MyCLController.h
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyCLController : NSObject <CLLocationManagerDelegate> {
    CLLocationManager *locationManager;
}

@property (retain, nonatomic) CLLocationManager *locationManager;

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation;

-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error;

-(NSString *) getCurrentAddress;

-(CLLocationCoordinate2D) getCurrentCoordinateFromAddress:(NSString *)address;
-(CLLocationCoordinate2D) getCurrentCoordinate;

@end
