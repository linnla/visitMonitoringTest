//
//  CLVisitLog.m
//  MySun
//
//  Created by Laure Linn on 9/24/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import "CLVisitLog.h"

@implementation CLVisitLog

@synthesize arrivalDate;
@synthesize departureDate;
@synthesize timestamp;
@synthesize latitude;
@synthesize longitude;
@synthesize horizontalAccuracy;

+ (NSDateFormatter *)dateFormatter_clVisit_LocalTime {
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    return df;
}

+ (NSDateFormatter *)dateFormatter_clVisit_UTCTime {
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    [df setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return df;
}

@end
