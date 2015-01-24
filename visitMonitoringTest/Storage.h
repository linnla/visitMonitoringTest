//
//  Storage.h
//  MySun
//
//  Created by Laure Linn on 9/24/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSON.h"
#import <CoreLocation/CoreLocation.h>

@interface Storage : NSObject

+ (Storage *) store;

@property (readonly, assign, nonatomic) int visitCount;

-(NSDictionary *)firstVisit;
-(NSDictionary *)lastVisit;
-(NSDictionary *)visitAtIndex:(int)index;

- (void)saveVisit:(CLVisit *) visit;

@end
