//
//  Visit.h
//  MySun
//
//  Created by Laure Linn on 9/24/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import "Common.h"

@interface Visit : NSObject

@property (nonatomic, strong) NSDate * arrivalDate;
@property (nonatomic, strong) NSDate * departureDate;
@property (nonatomic, strong) NSNumber *latitude;
@property (nonatomic, strong) NSNumber *longitude;
@property (nonatomic, strong) NSNumber *horizontalAccuracy;

+ (NSMutableDictionary *)convertVisitToDictionary:(Visit *)visit;

+ (BOOL)logVisitToJSON:(Visit *)visit;

+ (NSMutableArray *)retrieveVisits;



@end
