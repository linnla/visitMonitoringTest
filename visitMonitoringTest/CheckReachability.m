//
//  CheckReachability.m
//  Library
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "CheckReachability.h"

#define DISPLAY_ALERTS 0

NSString* const kInternetReachable = @"Internet Reachable";
NSString* const kInternetNotReachable = @"Internet NOT Reachable";

NSString* const kHostReachable = @"Host Reachable";
NSString* const kHostNotReachable = @"Host NOT Reachable";
NSString* const kHostError = @"Host Error";

NSString* const kWAN = @"WWAN";
NSString* const kWiFi = @"WiFi";

NSString* const kInternetError = @"Internet Error";
NSString* const kNetworkError = @"Network Error";
NSString* const kUnknownError = @"Unknown Error";

@implementation CheckReachability

+ (BOOL)internetReachable {
    
    NetworkStatus netStatus = [[Reachability reachabilityForInternetConnection] currentReachabilityStatus];
    
    if (netStatus) {

        switch (netStatus) {
            
            case ReachableViaWWAN: {
            
                if (DISPLAY_ALERTS) [Messages displayErrorMessage:kInternetReachable message:kWAN cancelButtonTitle:kOk];
                
                return YES;
            }
            
            case ReachableViaWiFi: {
            
                if (DISPLAY_ALERTS) [Messages displayAlertView:kInternetReachable message:kWiFi cancelButtonTitle:kOk];
                return YES;
            }
            
            case NotReachable: {
                
                if (DISPLAY_ALERTS) [Messages displayErrorMessage:kInternetNotReachable message:nil cancelButtonTitle:kOk];
                return NO;
            }
            
            default: {
            
                if (DISPLAY_ALERTS) [Messages displayAlertView:kInternetNotReachable message:kUnknownError cancelButtonTitle:kOk];
                return NO;
            }
        }
        
    } else {
        
        [Messages displayErrorMessage:kInternetNotReachable message:kUnknownError cancelButtonTitle:kOk];
        return NO;
    }
}

+ (BOOL)hostReachable:(NSString *)myHost {
    
    NetworkStatus netStatus = [[Reachability reachabilityWithHostName:myHost] currentReachabilityStatus];
    
    switch (netStatus) {
            
        case ReachableViaWWAN: {
            
            if (DISPLAY_ALERTS) [Messages displayAlertView:kHostReachable message:kWAN cancelButtonTitle:kOk];
            NSLog (@"%@ %@", kHostReachable, kWAN);
            return YES;
        }
        
        case ReachableViaWiFi: {
            
            if (DISPLAY_ALERTS) [Messages displayAlertView:kHostReachable message:kWiFi cancelButtonTitle:kOk];
            NSLog (@"%@ %@", kHostReachable, kWiFi);
            return YES;
        }
        
        case NotReachable: {
            
            if (DISPLAY_ALERTS) [Messages displayErrorMessage:kHostNotReachable message:myHost cancelButtonTitle:kOk];
            //[GlobalMethods displayAlertView:kHostNotReachable message:myHost cancelButtonTitle:kOk];
             NSLog (@"%@ %@", kHostNotReachable, myHost);
            return NO;
        }
        
        default: {
            
            if (DISPLAY_ALERTS) [Messages displayErrorMessage:kHostNotReachable message:myHost cancelButtonTitle:kOk];
            //[GlobalMethods displayAlertView:kHostNotReachable message:myHost cancelButtonTitle:kOk];
            NSLog (@"%@ %@", kHostNotReachable, myHost);
            return NO;
        }
    }
}

@end
