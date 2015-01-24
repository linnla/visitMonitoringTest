//
//  Messages.m
//  Library
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "Messages.h"

@implementation Messages

#define DISPLAY_ALERTS 1
#define ERROR [NSString stringWithFormat: @"%@\n", @"ERROR"]

+ (NSString *)decodeNetworkErrors:(NSInteger)errorCode
{
    /* CFURL and CFURLConnection Errors */
    
    if (errorCode == -1001) return @"The request took longer than the allocated time.";
    else if (errorCode == 503) return @"Service Unavailable";
    else if (errorCode == -1003) return @"The host could not be found.";
    //else if (errorCode == -1004) return @"The host would not let us establish a connection.";
    else if (errorCode == -1004) return @"Nodejs not running";
    else if (errorCode == -1005) return @"Network connection lost.";
    else if (errorCode == -1009) return @"Not connected to the internet.";
    else return @"Error Code Not Found";
}

+ (void)displayAlertView:(NSString *)messageTitle
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
{
    
    if (messageTitle.length == 0 || messageTitle == nil) messageTitle = @"";
    if (message.length == 0 || message == nil) message = @"";
    if (cancelButtonTitle.length == 0 || cancelButtonTitle == nil) cancelButtonTitle = kOk;
    
    NSLog(@"ERROR: %@", [[messageTitle stringByAppendingString:@" "] stringByAppendingString:message]);
}

+ (void)displayErrorMessage:(NSString *)messageTitle
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle
{
    
    if (messageTitle.length == 0 || messageTitle == nil) messageTitle = @"";
    if (message.length == 0 || message == nil) message = @"";
    if (cancelButtonTitle.length == 0 || cancelButtonTitle == nil) cancelButtonTitle = kOk;
    
    NSLog(@"ERROR: %@", [[messageTitle stringByAppendingString:@" "] stringByAppendingString:message]);
}

@end
