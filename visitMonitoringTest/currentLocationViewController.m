//
//  currentLocationViewController.m
//  TestApp
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import "currentLocationViewController.h"

@interface currentLocationViewController ()

//@property (nonatomic, strong) CLLocationManager *locationManager;
//@property (nonatomic, strong) CLLocation *oldLocation;
//@property (nonatomic, strong) CLLocation *lastLocation;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property double latitude;
@property double longitude;
@property double altitude;
@property double horizontalAccuracy;
@property double verticalAccuracy;

@end

@implementation currentLocationViewController

#define METERS_PER_MILE 1609.344

- (void)viewDidLoad {
    [super viewDidLoad];
    //_locationManager = [LocationServices sharedLocationInstance].locationManager;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    
    _latitude = userLocation.coordinate.latitude;
    _longitude = userLocation.coordinate.longitude;
    
    CLLocation *location = [[CLLocation alloc] initWithLatitude:_latitude longitude:_longitude];
    
    //[self locationStatus:location];
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSInteger objCount = [locations count];
    if (objCount > 1) _oldLocation = [locations objectAtIndex:objCount - 1];
    _lastLocation = [locations lastObject];
    
    // Age description
    RelativeDateDescriptor *timeDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    // Example Prior Date Description Formats:  @"%@ ago", @"occured %@ ago", @"happend %@ in the past"
    // Example Post Date Description Formats:   @"in %@", @"occuring in %@", @"happening in %@"
    
    [timeDescriptor setExpressedUnits:RDDTimeUnitHours|RDDTimeUnitMinutes|RDDTimeUnitSeconds];
    NSString *description = [timeDescriptor describeDate:_lastLocation.timestamp relativeTo:[NSDate date]];
    
    // See how recent the event is
    NSDate* eventDate = _lastLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    NSUInteger maxAgeInSeconds = 15;
    BOOL recent;
    
    if (abs(howRecent) < maxAgeInSeconds) {
        
        recent = YES;
        //[self write:[NSString stringWithFormat:@"%@", @"Recency: PASS"]];
        
    } else {
        
        recent = NO;
        //[self write:[NSString stringWithFormat:@"%@", @"Recency: FAIL"]];
        //[self write:[NSString stringWithFormat:@"%@ %lu %@", @"Required: < ", (unsigned long)maxAgeInSeconds, @" seconds"]];
        //[self write:[NSString stringWithFormat:@"%@ %@", @"Actual: ", description]];
    }
    
    // Horizontal Accuracy in meters
    NSUInteger horizontalAccuracyRequiredInMeters = 35;
    BOOL horzontallyAccurate;
    
    if(_lastLocation.horizontalAccuracy < horizontalAccuracyRequiredInMeters) {
        
        horzontallyAccurate = YES;
        //[self write:[NSString stringWithFormat:@"%@", @"Horizontal Accuracy: PASS"]];
        
    } else {
        
        horzontallyAccurate = NO;
        //[self write:[NSString stringWithFormat:@"%@", @"Horizontal Accuracy: FAIL"]];
        //[self write:[NSString stringWithFormat:@"%@ %lu %@", @"Required: < ", (unsigned long)horizontalAccuracyRequiredInMeters, @" meters"]];
        //[self write:[NSString stringWithFormat:@"%@ %lu %@", @"Actual: ", (unsigned long)newLocation.horizontalAccuracy, @" meters"]];
    }
    
    // Vertically Accuracy in meters
    NSUInteger verticalAccuracyRequiredInMeters = 35;
    BOOL verticallyAccurate;
    
    if(_lastLocation.verticalAccuracy < verticalAccuracyRequiredInMeters) {
        
        verticallyAccurate = YES;
        //[self write:[NSString stringWithFormat:@"%@", @"Vertical Accuracy: PASS"]];
        
    } else {
        
        verticallyAccurate = NO;
        //[self write:[NSString stringWithFormat:@"%@", @"Vertical Accuracy: FAIL"]];
        //[self write:[NSString stringWithFormat:@"%@ %lu %@", @"Required: < ", (unsigned long)verticalAccuracyRequiredInMeters, @" meters"]];
        //[self write:[NSString stringWithFormat:@"%@ %lu %@", @"Actual: ", (unsigned long)newLocation.verticalAccuracy, @" meters"]];
        
    }
    
    if (recent == YES && horzontallyAccurate == YES && verticallyAccurate == YES) {
        
        [self.locationManager stopUpdatingLocation];
        //[self write:[NSString stringWithFormat:@"%@", @"Stopping location updates"]];
        
    } else {
        
        //[self write:[NSString stringWithFormat:@"%@", @"Continuing location updates"]];
    }
    
    //[self write:@""];
}
*/

@end
