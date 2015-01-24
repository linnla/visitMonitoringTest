//
//  CLVisitLog.h
//  MySun
//
//  Created by Laure Linn on 9/24/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import <CoreLocation/CoreLocation.h>

@interface CLVisitLog : NSObject

@property (nonatomic, strong) NSDate *arrivalDate;
@property (nonatomic, strong) NSDate *departureDate;
@property (nonatomic, strong) NSDate *timestamp;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *horizontalAccuracy;

+ (NSDateFormatter *)dateFormatter_clVisit_LocalTime;
+ (NSDateFormatter *)dateFormatter_clVisit_UTCTime;

@end
