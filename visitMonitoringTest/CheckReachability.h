//
//  CheckReachability.h
//  Library
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"
#import "Reachability.h"

//#import <CoreTelephony/CTTelephonyNetworkInfo.h>
//#import <CoreTelephony/CTCarrier.h>
//#import <CoreLocation/CoreLocation.h>
//#import <SystemConfiguration/SystemConfiguration.h>
//#import <netinet/in.h>

extern NSString* const kInternetReachable;
extern NSString* const kInternetNotReachable;

extern NSString* const kHostReachable;
extern NSString* const kHostNotReachable;
extern NSString* const kHostError;

extern NSString* const kWAN;
extern NSString* const kWiFi;

extern NSString* const kInternetError;
extern NSString* const kNetworkError;
extern NSString* const kUnknownError;

@interface CheckReachability : NSObject

+ (BOOL) internetReachable;
+ (BOOL) hostReachable:(NSString *) myHost;

@end


