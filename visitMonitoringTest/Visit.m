//
//  Visit.m
//  MySun
//
//  Created by Laure Linn on 9/24/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import "Visit.h"

@implementation Visit

+ (NSMutableDictionary *)convertVisitToDictionary:(Visit *)visit {
    
    // Discard the visit if it doesn't have this information
    if (visit.arrivalDate == nil || visit.departureDate == nil ||
        visit.latitude == nil || visit.longitude == nil ||
        visit.horizontalAccuracy == nil) {
        return nil;
    }
    
    NSDateFormatter *df = [CLVisitLog dateFormatter_clVisit_LocalTime];
    
    NSMutableDictionary *visitInfo = [[NSMutableDictionary alloc] init];
    
    [visitInfo setValue:[df stringFromDate:visit.arrivalDate] forKey:@"arrivalDate"];
    [visitInfo setValue:[df stringFromDate:visit.departureDate] forKey:@"departureDate"];
    [visitInfo setValue:visit.latitude forKey:@"latitude"];
    [visitInfo setValue:visit.longitude forKey:@"longitude"];
    [visitInfo setValue:visit.horizontalAccuracy forKey:@"horizontalAccuracy"];
    
    [JSON writeJSON:visitInfo toFilePath:[Common filePathForLastCLVisit] deleteFileIfExists:YES createDirectoryIfNotExists:YES];

    return visitInfo;
}

+ (NSMutableArray *)retrieveVisits {
    
    NSMutableArray *visitArray = [[NSMutableArray alloc] init];
    
    NSString *filePath = [Common filePathForCLVisits];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        NSMutableArray *visits = [JSON getJSONAtFilePath:filePath];
        
        for (NSDictionary *visit in visits) {
            
            [visitArray addObject:visit];
        }
    }
    
    return visitArray;
}

+ (BOOL)logVisitToJSON:(Visit *) visit {
    
    BOOL visitLogged = NO;
    
    NSString *filePath = [Common filePathForCLVisits];
    
    NSMutableArray *visitsMutableArray = [[NSMutableArray alloc] init];
    
    ///// Comment this out to prune the log --- existing log entries don't get loaded.
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        visitsMutableArray = [Visit retrieveVisits];
        
    }
    
    NSDictionary *visitDictionary = [Visit convertVisitToDictionary:visit];
    
    // Check to see if visit is a duplicate
    if ([visitsMutableArray containsObject:visitDictionary]) {
        
        NSLog(@"%@", @"Equal object found");
        return visitLogged;
        
    } else {
        
        NSLog(@"%@", @"Equal object NOT found");
        
        [visitsMutableArray addObject:visitDictionary];
        
        if ([JSON writeJSON:visitsMutableArray toFilePath:filePath deleteFileIfExists:YES createDirectoryIfNotExists:YES]) {
            visitLogged = YES;
            NSLog(@"%@", @"JSON Saved");
        } else {
            visitLogged = NO;
            NSLog(@"%@", @"JSON NOT Saved");
        }
    }
    
    return visitLogged;
}

@end
