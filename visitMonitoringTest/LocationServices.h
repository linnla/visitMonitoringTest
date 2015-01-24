//
//  LocationServices.h
//  Library
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <MapKit/MapKit.h>
//#import "RegionMonitoring.h"
#import "Storage.h"

@interface LocationServices : NSObject <CLLocationManagerDelegate>

extern NSString* const kGeocoderError;

extern NSString* const kLocationServicesAvailable;
extern NSString* const kLocationServicesAuthorized;
extern NSString* const kLocationServicesError;

extern NSString* const kLocationServicesRestricted;
extern NSString* const kLocationServicesRestrictedRemedy;

extern NSString* const kLocationServicesDisabled;
extern NSString* const kLocationServicesDisabledRemedy;

extern NSString* const kLocationServicesStatusUndetermined;
extern NSString* const kLocationServicesStatusUndeterminedRemedy;

extern NSString* const kLocationServicesUnKnown;
extern NSString* const kLocationServicesUnKnownRemedy;

extern NSString* const kUnicodeForDegreeSign;

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *oldLocation;
@property (nonatomic, strong) CLLocation *lastLocation;

+ (LocationServices *)sharedLocationInstance;

@end
