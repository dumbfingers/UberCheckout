//
//  MyCLController.m
//  UberCheckout
//
//  Created by Yaxi Ye on 13/08/2012.
//  Copyright (c) 2012 Yaxi Ye. All rights reserved.
//

#import "MyCLController.h"
#import <MapKit/MapKit.h>


@implementation MyCLController
@synthesize locationManager;

NSString *addressText;
float currentLongitude;
float currentLatitude;

-(id) init {
    
    self = [super init];
    
    if (self != nil) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return  self;
}

-(void) locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    currentLatitude = locationManager.location.coordinate.latitude;
    currentLongitude = locationManager.location.coordinate.longitude;
    [locationManager stopUpdatingLocation];
        
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    
    [geoCoder reverseGeocodeLocation:self.locationManager.location completionHandler:^(NSArray *placemarks, NSError *error) {
        
        //do something
        CLPlacemark *topResult = [placemarks objectAtIndex:0];
        addressText = [NSString stringWithFormat:@"%@, %@", [topResult locality], [topResult country]];
        
//        NSLog(@"%@", addressText);

        
    }];
    

}


-(void) locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
}

-(NSString *) getCurrentAddress {
    return  addressText;
}

    
-(CLLocationCoordinate2D) getCurrentCoordinateFromAddress:(NSString *)address
{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:address completionHandler:^(NSArray *placemarks, NSError *error) {
        
        CLPlacemark *topResult = [placemarks objectAtIndex:0];
        currentLatitude = topResult.location.coordinate.latitude;
        currentLongitude = topResult.location.coordinate.longitude;
    }];
    
    CLLocationCoordinate2D coordinateFromAddress = CLLocationCoordinate2DMake(currentLatitude, currentLongitude);
    return coordinateFromAddress;
}

-(CLLocationCoordinate2D) getCurrentCoordinate {
    
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(currentLatitude, currentLongitude);
    return coordinate;
}

@end
