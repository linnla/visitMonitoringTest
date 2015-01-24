//
//  LocationServices.m
//  CustomClasses
//
//  Created by Laure Linn on 6/7/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import "LocationServices.h"

#define DISPLAY_ALERTS 1

NSString* const kGeocoderError = @"Geocoder Error";

NSString* const kLocationServicesAvailable = @"Location Services Available";
NSString* const kLocationServicesAuthorized = @"Location Services Authorized";
NSString* const kLocationServicesError = @"Location Services Error";

NSString* const kLocationServicesRestricted = @"Location Services are Restricted for this App";
NSString* const kLocationServicesRestrictedRemedy = @"Parental Privacy Restrictions Exist";

NSString* const kLocationServicesDisabled = @"Location Services are either Disabled on this Device or Disabled for this App";
NSString* const kLocationServicesDisabledRemedy = @"To re-enable go to Settings, Privacy and make sure Location Services are turned on.  If Location Services are turned on, make sure Location Services are enabled for this App.";

NSString* const kLocationServicesStatusUndetermined = @"Location Services Status Undetermined";
NSString* const kLocationServicesStatusUndeterminedRemedy = @"To re-enable go to Settings, Privacy and make sure Location Services is turned on.  If that doesn't work, shutdown and restart the mobile device";

NSString* const kLocationServicesUnKnown = @"Location Services UnKnown Error";
NSString* const kLocationServicesUnKnownRemedy = @"Restart Your Device";

NSString* const kUnicodeForDegreeSign = @"%g\u00B0";

@implementation LocationServices

@synthesize locationManager, oldLocation, lastLocation;

+ (LocationServices *)sharedLocationInstance {
    
    static LocationServices *sharedLocationInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedLocationInstance = [[LocationServices alloc] init];
        
    });
    
    return sharedLocationInstance;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        self.locationManager.distanceFilter = kCLDistanceFilterNone;
        
        BOOL locationServicesAreAvailable = [CLLocationManager locationServicesEnabled];
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        
        if (locationServicesAreAvailable && (status == kCLAuthorizationStatusAuthorizedAlways)) {
            [self.locationManager startUpdatingLocation];
            [self.locationManager startMonitoringVisits];
            
        } else {
            [locationManager requestAlwaysAuthorization];
        }
    }
   
    return self;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    
    NSInteger objCount = [locations count];
    if (objCount > 1) oldLocation = [locations objectAtIndex:objCount - 1];
    lastLocation = [locations lastObject];
    
    // Age description
    RelativeDateDescriptor *timeDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    // Example Prior Date Description Formats:  @"%@ ago", @"occured %@ ago", @"happend %@ in the past"
    // Example Post Date Description Formats:   @"in %@", @"occuring in %@", @"happening in %@"
    
    [timeDescriptor setExpressedUnits:RDDTimeUnitHours|RDDTimeUnitMinutes|RDDTimeUnitSeconds];
    NSString *description = [timeDescriptor describeDate:lastLocation.timestamp relativeTo:[NSDate date]];
    
    // See how recent the event is
    NSDate* eventDate = lastLocation.timestamp;
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
    
    if(lastLocation.horizontalAccuracy < horizontalAccuracyRequiredInMeters) {
        
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
    
    if(lastLocation.verticalAccuracy < verticalAccuracyRequiredInMeters) {
        
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

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    if (DISPLAY_ALERTS) [Messages displayErrorMessage:kLocationServicesError message:[error localizedDescription] cancelButtonTitle:kOk];
    
    [self.locationManager stopUpdatingLocation];
    locationManager = nil;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusNotDetermined){
        [self.locationManager startUpdatingLocation];
        [self.locationManager startMonitoringVisits];
    }
}

#pragma mark - CLLocationManager Error Handling

+ (BOOL)locationServicesAvailable {
    
    BOOL locationServicesAvailable = YES;
    
    if([CLLocationManager locationServicesEnabled]){
        
        if (DISPLAY_ALERTS) [Messages displayErrorMessage:kLocationServicesAvailable message:nil cancelButtonTitle:kOk];
        
    } else {
        
        locationServicesAvailable = NO;
        switch([CLLocationManager authorizationStatus]){
                
            case kCLAuthorizationStatusAuthorizedAlways:
                
                break;
                
            case kCLAuthorizationStatusDenied:
                
                // denied by user
                [Messages displayErrorMessage:kLocationServicesDisabled message:kLocationServicesDisabledRemedy cancelButtonTitle:kOk];
                break;
                
            case kCLAuthorizationStatusRestricted:
                
                // restricted by parental controls
                [Messages displayErrorMessage:kLocationServicesRestricted message:kLocationServicesRestrictedRemedy cancelButtonTitle:kOk];
                break;
                
            case kCLAuthorizationStatusNotDetermined:
                
                // unable to determine, possibly disabled -- error usually occurs when using simulated locations
                [Messages displayErrorMessage:kLocationServicesStatusUndetermined message:kLocationServicesStatusUndeterminedRemedy cancelButtonTitle:kOk];
                break;
                
            default:
                // user denied starting location services when prompted, or location unknown
                // kCLErrorLocationUnknown or kCLErrorDenied
                [Messages displayErrorMessage:kLocationServicesUnKnown message:kLocationServicesUnKnownRemedy cancelButtonTitle:kOk];
                break;
        }
    }
    
    return locationServicesAvailable;
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    NSString *message = [NSString stringWithFormat:@"%@ %@", @"Entered region: ", region.identifier];
    NSLog(@"%@", message);
    [Common fireNotificationWithText:message];
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    NSString *message = [NSString stringWithFormat:@"%@ %@", @"Exited region: ", region.identifier];
    NSLog(@"%@", message);
    [Common fireNotificationWithText:message];
}

- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    NSString *message = [NSString stringWithFormat:@"%@ %@", @"Did start monitoring region: ", region.identifier];
    NSLog(@"%@", message);
    [Common fireNotificationWithText:message];
}

- (void)locationManager:(CLLocationManager *)manager didStopMonitoringForRegion:(CLRegion *)region {
    
    NSString *message = [NSString stringWithFormat:@"%@ %@", @"Did stop monitoring region: ", region.identifier];
    NSLog(@"%@", message);
    [Common fireNotificationWithText:message];
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    NSString *message = [NSString stringWithFormat:@"%@ %@", @"Region monitoring failed: ", [error localizedDescription]];
    NSLog(@"%@", message);
    [Common fireNotificationWithText:message];
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    NSString *message;
    
    switch (state) {
        case CLRegionStateInside:
            message = [NSString stringWithFormat:@"%@", @"RegionStateInside"];
            break;
        case CLRegionStateOutside:
            message = [NSString stringWithFormat:@"%@", @"RegionStateOutside"];
            break;
        case CLRegionStateUnknown:
            message = [NSString stringWithFormat:@"%@", @"RegionStateUnknown"];
            break;
        default:
            message = [NSString stringWithFormat:@"%@", @"RegionStateNotFound"];
            break;
    }
    
    NSLog(@"%@", message);
    [Common fireNotificationWithText:message];
}

-(void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    if ([visit.departureDate isEqual: [NSDate distantFuture]]) {
        notification.alertBody = [NSString stringWithFormat:@"MySun didVisit: We arrived somewhere!"];
    } else {
        notification.alertBody = @"MySun didVisit: We left somewhere!";
    }
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.fireDate = [NSDate date];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    
    //[self didVisit:visit];
    
    [[Storage store] saveVisit:visit];
}

@end