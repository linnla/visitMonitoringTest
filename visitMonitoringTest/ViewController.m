//
//  ViewController.m
//  visitMonitoringTest
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import "ViewController.h"
@import CoreLocation;

@interface ViewController () <CLLocationManagerDelegate> {
    NSMutableString *_log;
    CLLocationManager *_locationManager;
    double latitude;
    double longitude;
    CLLocation *oldLocation;
    CLLocation *newLocation;
    CLLocation *visitLocation;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)monitorRegion100Meters:(id)sender;
- (IBAction)monitorRegion50Meters:(id)sender;
- (IBAction)monitorRegion20Meters:(id)sender;
- (IBAction)stopMonitoring:(id)sender;
- (IBAction)reportStatus:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *logTextView;

- (IBAction)clearButtonTouchUpInside:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self clearLog];
    [self now];
    
    [self configureLocationManger];
    if (_locationManager) {
        [_locationManager startMonitoringSignificantLocationChanges];
        [_locationManager startUpdatingLocation];
    } else {
        [self write:[NSString stringWithFormat:@"%@", @"Location Manager Error"]];
        [self locationServicesStatus];
        [self authorizationStatus];
    }
}

/*
+ (LocationServices *)sharedLocationInstance {
    
    static LocationServices *sharedLocationInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedLocationInstance = [[LocationServices alloc] init];
        
    });
    
    return sharedLocationInstance;
}
 */

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [self clearLog];
}

-(void)configureLocationManger {
    _locationManager = [[CLLocationManager alloc] init];
    _locationManager.delegate = self;
    
    [_locationManager requestAlwaysAuthorization];
    
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    _locationManager.pausesLocationUpdatesAutomatically = NO;
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
}

-(void)fireNotificationWithText:(NSString *)text {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = text;
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.fireDate = [NSDate date];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

-(void)write:(NSString *)msg {
    NSLog(@"%@", msg);
    [_log appendFormat:@"%@\n", msg];
    self.logTextView.text = _log;
    
    CGPoint bottomOffset = CGPointMake(0, [self.logTextView contentSize].height - self.logTextView.frame.size.height);
    
    if (bottomOffset.y > 0)
        [self.logTextView setContentOffset: bottomOffset animated: YES];
    
    
}

#pragma mark CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    //[self write:[NSString stringWithFormat:@"%s status:%d", __PRETTY_FUNCTION__, status]];
    
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [_locationManager startMonitoringVisits];
            break;
        default:
            break;
    }
    [self authorizationStatus];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [self now];
    [self write:[NSString stringWithFormat:@"%@", @"didUpdateLocations"]];
    
    NSInteger objCount = [locations count];
    if (objCount > 1) oldLocation = [locations objectAtIndex:objCount - 1];
    newLocation = [locations lastObject];
    
    // Age description
    RelativeDateDescriptor *timeDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    // Example Prior Date Description Formats:  @"%@ ago", @"occured %@ ago", @"happend %@ in the past"
    // Example Post Date Description Formats:   @"in %@", @"occuring in %@", @"happening in %@"
    
    [timeDescriptor setExpressedUnits:RDDTimeUnitHours|RDDTimeUnitMinutes|RDDTimeUnitSeconds];
    NSString *description = [timeDescriptor describeDate:newLocation.timestamp relativeTo:[NSDate date]];
    
    // See how recent the event is
    NSDate* eventDate = newLocation.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    NSUInteger maxAgeInSeconds = 15;
    BOOL recent;
    
    if (abs(howRecent) < maxAgeInSeconds) {
        
        recent = YES;
        [self write:[NSString stringWithFormat:@"%@", @"Recency: PASS"]];

    } else {
        
        recent = NO;
        [self write:[NSString stringWithFormat:@"%@", @"Recency: FAIL"]];
        [self write:[NSString stringWithFormat:@"%@ %lu %@", @"Required: < ", (unsigned long)maxAgeInSeconds, @" seconds"]];
        [self write:[NSString stringWithFormat:@"%@ %@", @"Actual: ", description]];
    }
    
    // Horizontal Accuracy in meters
    NSUInteger horizontalAccuracyRequiredInMeters = 35;
    BOOL horzontallyAccurate;
    
    if(newLocation.horizontalAccuracy < horizontalAccuracyRequiredInMeters) {
        
        horzontallyAccurate = YES;
        [self write:[NSString stringWithFormat:@"%@", @"Horizontal Accuracy: PASS"]];
        
    } else {
        
        horzontallyAccurate = NO;
        [self write:[NSString stringWithFormat:@"%@", @"Horizontal Accuracy: FAIL"]];
        [self write:[NSString stringWithFormat:@"%@ %lu %@", @"Required: < ", (unsigned long)horizontalAccuracyRequiredInMeters, @" meters"]];
        [self write:[NSString stringWithFormat:@"%@ %lu %@", @"Actual: ", (unsigned long)newLocation.horizontalAccuracy, @" meters"]];
    }
    
    // Vertically Accuracy in meters
    NSUInteger verticalAccuracyRequiredInMeters = 35;
    BOOL verticallyAccurate;
    
    if(newLocation.verticalAccuracy < verticalAccuracyRequiredInMeters) {
        
        verticallyAccurate = YES;
        [self write:[NSString stringWithFormat:@"%@", @"Vertical Accuracy: PASS"]];
        
    } else {
        
        verticallyAccurate = NO;
        [self write:[NSString stringWithFormat:@"%@", @"Vertical Accuracy: FAIL"]];
        [self write:[NSString stringWithFormat:@"%@ %lu %@", @"Required: < ", (unsigned long)verticalAccuracyRequiredInMeters, @" meters"]];
        [self write:[NSString stringWithFormat:@"%@ %lu %@", @"Actual: ", (unsigned long)newLocation.verticalAccuracy, @" meters"]];

    }
    
    if (recent == YES && horzontallyAccurate == YES && verticallyAccurate == YES) {
        
        [_locationManager stopUpdatingLocation];
        [self write:[NSString stringWithFormat:@"%@", @"Stopping location updates"]];
        
    } else {
        
        [self write:[NSString stringWithFormat:@"%@", @"Continuing location updates"]];
    }
    
    [self write:@""];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    [self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    [self write:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
    
    [self decodeLocationServicesErrors:[error code]];
}

-(void)locationManagerDidPauseLocationUpdates:(CLLocationManager *)manager {
    [self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
}

-(void)locationManagerDidResumeLocationUpdates:(CLLocationManager *)manager {
    [self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
}

- (void)locationManager:(CLLocationManager *)manager didVisit:(CLVisit *)visit {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    [self now];
    [self write:@""];
    [self write:[NSString stringWithFormat:@"%@", @"didVisit"]];
    //[self write:[NSString stringWithFormat:@"%@", visit]];
    //[self write:@""];
    [self write:[NSString stringWithFormat:@"%@", visit.arrivalDate]];
    [self write:[NSString stringWithFormat:@"%@", visit.departureDate]];
    [self write:@""];
    visitLocation = [[CLLocation alloc] initWithCoordinate:visit.coordinate altitude:0 horizontalAccuracy:visit.horizontalAccuracy verticalAccuracy:0 timestamp:[NSDate date]];
    
    if ([visit.departureDate isEqual: [NSDate distantFuture]]) {
        
        NSString *message = @"We arrived somewhere!";
        [self fireNotificationWithText:message];
        [self write:[NSString stringWithFormat:@"%@", message]];
    } else {
        
        NSString *message = @"We left somewhere!";
        [self fireNotificationWithText:message];
        [self write:[NSString stringWithFormat:@"%@", message]];
    }
    [self locationStatus:visitLocation];
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
    
    [self now];
    NSString *message = [NSString stringWithFormat:@"%@ %@", @"Entered region: ", region.identifier];
    [self write:message];
    [self write:@""];
    [self fireNotificationWithText:message];
}

-(void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    
    [self now];
    NSString *message = [NSString stringWithFormat:@"%@ %@", @"Exited region: ", region.identifier];
    [self write:message];
    [self write:@""];
    [self fireNotificationWithText:message];
}

-(void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region {
    
    [self now];
    [self write:[NSString stringWithFormat:@"%@ %@", @"Started monitoring region: ", region.identifier]];
    [self write:@""];
}

-(void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error {
    
    [self now];
    [self write:[NSString stringWithFormat:@"%@", @"monitoringDidFailForRegion"]];
    [self write:[NSString stringWithFormat:@"%@", region.identifier]];
    [self write:[NSString stringWithFormat:@"%@", [error localizedDescription]]];
    
    [self write:@""];
}

-(void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region {
    
    [self now];
    [self write:[NSString stringWithFormat:@"%@ %@", @"Determined state: ", region.identifier]];
    
    switch (state) {
        case CLRegionStateInside:
            [self write:[NSString stringWithFormat:@"%@", @"RegionStateInside"]];
            break;
        case CLRegionStateOutside:
            [self write:[NSString stringWithFormat:@"%@", @"RegionStateOutside"]];
            break;
        case CLRegionStateUnknown:
            [self write:[NSString stringWithFormat:@"%@", @"RegionStateUnknown"]];
            break;
        default:
            [self write:[NSString stringWithFormat:@"%@", @"RegionStateNotFound"]];
            break;
    }
    
    [self write:@""];
}

#pragma mark Methods

-(void)clearLog {
    _log = [[NSMutableString alloc] init];
    self.logTextView.text = @"";
}

-(CLLocationCoordinate2D)getLocationCoordinates {
    
    CLLocationCoordinate2D location;
    
    if (newLocation && visitLocation) {
        if ([newLocation.timestamp laterDate:visitLocation.timestamp]) {
            location.latitude = newLocation.coordinate.latitude;
            location.longitude = newLocation.coordinate.longitude;
        } else {
            location.latitude = visitLocation.coordinate.latitude;
            location.longitude = visitLocation.coordinate.longitude;
        }
    } else if (newLocation) {
        location.latitude = newLocation.coordinate.latitude;
        location.longitude = newLocation.coordinate.longitude;
    } else if (visitLocation) {
        location.latitude = visitLocation.coordinate.latitude;
        location.longitude = visitLocation.coordinate.longitude;
    }
    
    return location;
}

- (IBAction)clearButtonTouchUpInside:(id)sender {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    [self clearLog];
}

- (IBAction)monitorRegion100Meters:(id)sender {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    float rad = 100;
    
    CLLocationCoordinate2D location = [self getLocationCoordinates];
    if (!location.latitude || !location.longitude) {
        [self write:[NSString stringWithFormat:@"%@", @"No location coordinates"]];
        return;
    } else {
        CLCircularRegion * reg1 = [[CLCircularRegion alloc] initWithCenter:location radius:rad identifier:@"100 Meters"];
        [_locationManager startMonitoringForRegion:reg1];
        
        [self write:[NSString stringWithFormat:@"%f", location.latitude]];
        [self write:[NSString stringWithFormat:@"%f", location.longitude]];
    }
    
    [self write:@""];
}

- (IBAction)monitorRegion50Meters:(id)sender {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    float rad = 50;
    CLLocationCoordinate2D location = [self getLocationCoordinates];
    if (!location.latitude || !location.longitude) {
        [self write:[NSString stringWithFormat:@"%@", @"No location coordinates"]];
        return;
    } else {
        CLCircularRegion * reg1 = [[CLCircularRegion alloc] initWithCenter:location radius:rad identifier:@"50 Meters"];
        [_locationManager startMonitoringForRegion:reg1];
        
        [self write:[NSString stringWithFormat:@"%f", location.latitude]];
        [self write:[NSString stringWithFormat:@"%f", location.longitude]];
    }
    
    [self write:@""];
}

- (IBAction)monitorRegion20Meters:(id)sender {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    float rad = 20;
    CLLocationCoordinate2D location = [self getLocationCoordinates];
    if (!location.latitude || !location.longitude) {
        [self write:[NSString stringWithFormat:@"%@", @"No location coordinates"]];
        return;
    } else {
        CLCircularRegion * reg1 = [[CLCircularRegion alloc] initWithCenter:location radius:rad identifier:@"20 Meters"];
        [_locationManager startMonitoringForRegion:reg1];
        
        [self write:[NSString stringWithFormat:@"%f", location.latitude]];
        [self write:[NSString stringWithFormat:@"%f", location.longitude]];
    }
    
    [self write:@""];

}

- (IBAction)stopMonitoring:(id)sender {
    [self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    // stop monitoring for any and all current regions
    for (CLRegion *region in [[_locationManager monitoredRegions] allObjects]) {
        [self write:[NSString stringWithFormat:@"%@", region.identifier]];
        [self write:[NSString stringWithFormat:@"%@", region.description]];
        [_locationManager stopMonitoringForRegion:region];
    }
    
    [self write:@""];
}

- (IBAction)reportStatus:(id)sender {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    [self write:@"*********************************"];
    [self write:@"*********************************"];
    [self write:@""];
    
    [self now];
    [self locationServicesStatus];
    [self authorizationStatus];
    [self locationMangerSettings];
    [self regionsMonitored];
    [self locationStatus:newLocation];
    [self write:@""];
    
    [self write:@"*********************************"];
    [self write:@"*********************************"];
}

-(void)now {
    NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
    [localTime setDateStyle:NSDateFormatterMediumStyle];
    [localTime setTimeStyle:NSDateFormatterMediumStyle];
    [localTime setTimeZone:[NSTimeZone localTimeZone]];
    
    [self write:[NSString stringWithFormat: @"%@", [localTime stringFromDate:[NSDate date]]]];
}

- (void)locationStatus:(CLLocation *)location {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    // Last Location
    [self write:[NSString stringWithFormat: @"Latitude: %f", location.coordinate.latitude]];
    [self write:[NSString stringWithFormat: @"Longitude: %f", location.coordinate.longitude]];
    [self write:[NSString stringWithFormat: @"Altitude: %f", location.altitude]];
    
    // Last Location Accuracy
    [self write:[NSString stringWithFormat: @"Horizontal Accuracy: %f", location.horizontalAccuracy]];
    [self write:[NSString stringWithFormat: @"Vertical Accuracy: %f", location.verticalAccuracy]];
    
    // Last Location timestamp
    NSDateFormatter *localTime = [[NSDateFormatter alloc] init];
    [localTime setDateFormat:@"hh:mm:ss a"];
    [localTime setTimeZone:[NSTimeZone localTimeZone]];
    [self write:[NSString stringWithFormat: @"Timestamp: %@", [localTime stringFromDate:location.timestamp]]];
    
    RelativeDateDescriptor *timeDescriptor = [[RelativeDateDescriptor alloc] initWithPriorDateDescriptionFormat:@"%@ ago" postDateDescriptionFormat:@"in %@"];
    // Example Prior Date Description Formats:  @"%@ ago", @"occured %@ ago", @"happend %@ in the past"
    // Example Post Date Description Formats:   @"in %@", @"occuring in %@", @"happening in %@"
    [timeDescriptor setExpressedUnits:RDDTimeUnitHours|RDDTimeUnitMinutes|RDDTimeUnitSeconds];
    NSString *description = [timeDescriptor describeDate:location.timestamp relativeTo:[NSDate date]];
    
    NSString *message = description;
    [self write:[NSString stringWithFormat:@"%@", message]];
    
    [self write:@""];
}

- (void)locationServicesStatus {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    BOOL enabled = [CLLocationManager locationServicesEnabled];
    if (enabled ==YES) [self write:[NSString stringWithFormat:@"%@", @"Location Services enabled"]];
    else [self write:[NSString stringWithFormat:@"%@", @"Location Services NOT enabled"]];
    
    [self write:@""];
}

- (void)regionsMonitored {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    NSUInteger regionCount = [_locationManager monitoredRegions].count;
    [self write:[NSString stringWithFormat: @"Regions monitored: %lu", (unsigned long)regionCount]];
    
    for (CLRegion *region in [[_locationManager monitoredRegions] allObjects]) {
        [self write:[NSString stringWithFormat:@"%@", region.identifier]];
        [self write:[NSString stringWithFormat:@"%@", region.description]];
    }
    
    [self write:@""];
}

- (void)locationMangerSettings {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    [self write:[NSString stringWithFormat: @"Desired accuracy: %f", _locationManager.desiredAccuracy]];
    [self write:[NSString stringWithFormat: @"Distance filter: %f", _locationManager.distanceFilter]];
    
    NSString *canPause = _locationManager.pausesLocationUpdatesAutomatically ? @"YES" : @"NO";
    [self write:[NSString stringWithFormat: @"Pauses location updates: %@", canPause]];
    
    [self write:@""];
}

- (void)authorizationStatus {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    switch(status){
                
        case kCLAuthorizationStatusNotDetermined:
            [self write:[NSString stringWithFormat:@"%@", @"AuthorizationStatusNotDetermined"]];
            break;
        case kCLAuthorizationStatusRestricted:
            [self write:[NSString stringWithFormat:@"%@", @"AuthorizationStatusRestricted"]];
            break;
        case kCLAuthorizationStatusDenied:
            [self write:[NSString stringWithFormat:@"%@", @"AuthorizationStatusDenied"]];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
            [self write:[NSString stringWithFormat:@"%@", @"AuthorizationStatusAuthorizedAlways"]];
            break;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self write:[NSString stringWithFormat:@"%@", @"AuthorizationStatusAuthorizedWhenInUse"]];
            break;
        default:
            [self write:[NSString stringWithFormat:@"%@", @"AuthorizationStatusNotFound"]];
            break;
    }
    
    [self write:@""];
}

- (NSNumber*)calculateDistanceInMetersBetweenCoord:(CLLocationCoordinate2D)coord1 coord:(CLLocationCoordinate2D)coord2 {
    //[self write:[NSString stringWithFormat:@"%s", __PRETTY_FUNCTION__]];
    
    NSInteger nRadius = 6371; // Earth's radius in Kilometers
    double latDiff = (coord2.latitude - coord1.latitude) * (M_PI/180);
    double lonDiff = (coord2.longitude - coord1.longitude) * (M_PI/180);
    double lat1InRadians = coord1.latitude * (M_PI/180);
    double lat2InRadians = coord2.latitude * (M_PI/180);
    double nA = pow ( sin(latDiff/2), 2 ) + cos(lat1InRadians) * cos(lat2InRadians) * pow ( sin(lonDiff/2), 2 );
    double nC = 2 * atan2( sqrt(nA), sqrt( 1 - nA ));
    double nD = nRadius * nC;
    // convert to meters
    return @(nD*1000);
}

- (void)decodeLocationServicesErrors:(NSInteger)errorCode {
    
    /* CFURL and CFURLConnection Errors */
    // CL ERRORS
    
    /*
     kCLErrorLocationUnknown   = 0,
     kCLErrorDenied ,
     kCLErrorNetwork ,
     kCLErrorHeadingFailure ,
     kCLErrorRegionMonitoringDenied ,
     kCLErrorRegionMonitoringFailure ,
     kCLErrorRegionMonitoringSetupDelayed ,
     kCLErrorRegionMonitoringResponseDelayed ,
     kCLErrorGeocodeFoundNoResult ,
     kCLErrorGeocodeFoundPartialResult ,
     kCLErrorGeocodeCanceled ,
     kCLErrorDeferredFailed ,
     kCLErrorDeferredNotUpdatingLocation ,
     kCLErrorDeferredAccuracyTooLow ,
     kCLErrorDeferredDistanceFiltered ,
     kCLErrorDeferredCanceled ,
     kCLErrorRangingUnavailable ,
     kCLErrorRangingFailure ,
     */
    NSLog(@"%ld", (long)errorCode);
    
    [self networkStatus];
    if (errorCode == 0) [self write:[NSString stringWithFormat:@"%@", @"Is the phone in airplane mode?"]];
    else [self write:[NSString stringWithFormat:@"%@", @"Unknown error code"]];
}

-(void)networkStatus {
    
    // INTERNET
    NSString *internetConnectivityStatus = @"unknown device error";
    
    Reachability *internetConnection = [Reachability reachabilityForInternetConnection];
    NetworkStatus netStatus = [internetConnection currentReachabilityStatus];
    switch (netStatus)

    {
        case ReachableViaWWAN: {
            
            internetConnectivityStatus = @"Internet reachable via WWAN/3G";
            break;
            
        } case ReachableViaWiFi: {
            internetConnectivityStatus = @"Internet reachable via WIFI";
            break;
            
        } case NotReachable: {
            internetConnectivityStatus = @"Internet not reachable";
            break;
            
        } default: {
            internetConnectivityStatus = @"Unknown internet error";
            break;
        }
    }
    
    [self write:[NSString stringWithFormat:@"%@", internetConnectivityStatus]];
}

/*
- (void)locationManager:(CLLocationManager *)manager didUpdateLocationsPart2:(NSArray *)locations {
    
    NSLog(@"Location Services didUpdateLocations");
    
    if (locations.count != 0) {
        
        CLLocation *currentLocation = [locations lastObject];
        NSString *distance;
        
        if (locations.count >= 2) {
            
            CLLocation *lastLocation = [locations objectAtIndex:[locations count]];
            
            if (currentLocation != lastLocation) distance = [NSString stringWithFormat: @"%.2f m", [currentLocation distanceFromLocation:lastLocation]];
            else distance = @"0";
            
        } else distance = @"Inital location";
        
        NSString *latitude = [[NSString alloc] initWithFormat:@"%g", currentLocation.coordinate.latitude];
        NSString *longitude = [[NSString alloc] initWithFormat:@"%g", currentLocation.coordinate.longitude];
        NSLog(@"Latitude: %@  Longitude: %@", latitude, longitude);
        
        NSString *verticalAccuracy;
        if (currentLocation.verticalAccuracy) verticalAccuracy = [NSString stringWithFormat: @"%.2f m", currentLocation.verticalAccuracy];
        else verticalAccuracy = kUnknown;
        
        NSString *horizontalAccuracy;
        if (currentLocation.horizontalAccuracy) horizontalAccuracy = [NSString stringWithFormat: @"%.2f m", currentLocation.horizontalAccuracy];
        else horizontalAccuracy = kUnknown;
        
        NSString *altitude;
        if (currentLocation.altitude) altitude = [NSString stringWithFormat: @"%.2f m", currentLocation.altitude];
        else altitude = kUnknown;
        
        // Reverse GeoCode the Location if internet is reachable
        
        if ([CheckReachability internetReachable]) {
            
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            
            [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *geocoderError) {
                
                if (geocoderError) {
                    
                    if ([CheckReachability internetReachable]) {
                        
                        NSString *appleGeocodeURL = @"https://gsp-ssl.ls.apple.com/revgeo.arpc";
                        
                        if ([CheckReachability hostReachable:appleGeocodeURL]) {
                            
                            NSLog(@"Geocoder Error: %@ %ld %@", [geocoderError domain], (long)[geocoderError code], [[geocoderError userInfo] description]);
                            
                            [Messages displayErrorMessage:kGeocoderError message:[geocoderError localizedDescription] cancelButtonTitle:kOk];
                            
                        } else {
                            
                            if (![CheckReachability hostReachable:@"www.google.com"]) [Messages displayErrorMessage:kInternetNotReachable message:nil cancelButtonTitle:kOk];
                        }
                    }
                    
                } else {
                    
                    if ([placemarks count] > 0) {
                        
                        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                        [defaults setObject:[placemarks[0] name] forKey:@"placeName"];
                        [defaults setObject:[placemarks[0] subThoroughfare] forKey:@"streetNumber"];
                        [defaults setObject:[placemarks[0] thoroughfare] forKey:@"street"];
                        [defaults setObject:[placemarks[0] subLocality] forKey:@"neighborhood"];
                        [defaults setObject:[placemarks[0] locality] forKey:@"placemarkCity"];
                        [defaults setObject:[placemarks[0] subAdministrativeArea] forKey:@"county"];
                        [defaults setObject:[placemarks[0] administrativeArea] forKey:@"state"];
                        [defaults setObject:[placemarks[0] postalCode] forKey:@"zipCode"];
                        [defaults setObject:[placemarks[0] country] forKey:@"country"];
                        [defaults setObject:[placemarks[0] ISOcountryCode] forKey:@"countryCode"];
                        [defaults setObject:[placemarks[0] inlandWater] forKey:@"inlandWater"];
                        [defaults setObject:[placemarks[0] ocean] forKey:@"oceanLabel"];
                        
                        [defaults synchronize];
                        
                    } else if (DISPLAY_ALERTS) [Messages displayErrorMessage:kGeocoderError message:kUnknownError cancelButtonTitle:kOk];
                }
            }];
            
        } else if (DISPLAY_ALERTS) [Messages displayErrorMessage:kInternetNotReachable message:nil cancelButtonTitle:kOk];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:latitude forKey:@"latitude"];
        [defaults setObject:longitude forKey:@"longitude"];
        [defaults setObject:altitude forKey:@"altitude"];
        [defaults setObject:distance forKey:@"distance"];
        [defaults setObject:verticalAccuracy forKey:@"verticalAccuracy"];
        [defaults setObject:horizontalAccuracy forKey:@"horizontalAccuracy"];
        [defaults synchronize];
        
        [[LocationServices sharedLocationInstance].locationManager stopUpdatingLocation];
        locationManager = nil;
        
    } else [Messages displayErrorMessage:kLocationServicesError message:kUnknownError cancelButtonTitle:kOk];
}
*/

@end
