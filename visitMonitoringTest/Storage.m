//
//  Storage.m
//  MySun
//
//  Created by Laure Linn on 9/24/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import "Storage.h"
#import "Visit.h"

@interface Storage ()

@property (strong, nonatomic) NSArray *visits;

@end

@implementation Storage

+ (Storage *) store
{
    static Storage *store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[Storage alloc] init];
    });
    
    return store;
}

- (id) init
{
    self = [super init];
    if (self) {
        
        _visits = [Visit retrieveVisits];
    }
    return self;
}

#pragma mark - Storage and Retrieval

- (NSDictionary *)dictionaryFromVisit:(Visit *)visit
{
    NSDateFormatter *df = [CLVisitLog dateFormatter_clVisit_LocalTime];
    NSString *arrival = [df stringFromDate:visit.arrivalDate];
    
    //NSDateFormatter *df = [[NSDateFormatter alloc] init];
    //df.dateFormat = @"MM-dd-yy h:mm a";
    //[df setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *arrivalDate = ([visit.arrivalDate isEqualToDate:[NSDate distantPast]] ? @"distantPast" : [df stringFromDate:visit.arrivalDate]);
    NSString *departureDate = ([visit.departureDate isEqualToDate:[NSDate distantFuture]] ? @"distantFuture" : [df stringFromDate:visit.departureDate]);
    
    //NSString *timestamp = [df stringFromDate:visit.timestamp];
    //NSDictionary *visitInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               //arrivalDate, @"arrivalDate", departureDate, @"departureDate", timestamp, @"timestamp", visit.latitude, @"latitude", visit.longitude, @"longitude", nil];
    
    NSDictionary *visitInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                               arrivalDate, @"arrivalDate", departureDate, @"departureDate", visit.latitude, @"latitude", visit.longitude, @"longitude", nil];
    return visitInfo;
}

- (int) visitCount
{
    return (int)[_visits count];
}

- (void)saveVisit:(CLVisit *) clvisit
{
    Visit *visit = [[Visit alloc] init];
    
    visit.arrivalDate = clvisit.arrivalDate;
    visit.departureDate = clvisit.departureDate;
    visit.latitude = [NSNumber numberWithDouble:clvisit.coordinate.latitude];
    visit.longitude = [NSNumber numberWithDouble:clvisit.coordinate.longitude];
    visit.horizontalAccuracy = [NSNumber numberWithDouble:clvisit.horizontalAccuracy];
    
    //[self writeVisitToLog:visit];
    
    [Visit logVisitToJSON:visit];
}

- (void)writeVisitToLog:(Visit *)visit {
    
    NSDictionary *dictionary = [self dictionaryFromVisit:visit];
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = documentsDirectory;
    NSString *fileName = @"visitFromCLVisit";
    NSString *filePath = [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:kJsonFileExtension];
    
    [JSON writeJSON:dictionary toFilePath:filePath deleteFileIfExists:YES createDirectoryIfNotExists:YES];
}

- (NSDictionary *)firstVisit
{
    if ([_visits count]) {
        //return [self dictionaryFromVisit:_visits[0]];
        return _visits[0];
    }
    return nil;
}

-(NSDictionary *)lastVisit
{
    if ([_visits count]) {
        //return [self dictionaryFromVisit:_visits[[_visits count]-1]];
        return _visits[[_visits count]-1];
    }
    return nil;
}

-(NSDictionary *)visitAtIndex:(int)index
{
    if ([_visits count] > index)
        //return [self dictionaryFromVisit:_visits[index]];
        return _visits[index];
    return nil;
}

@end
