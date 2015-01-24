//
//  Messages.h
//  Library
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface Messages : NSObject

+ (NSString *)decodeNetworkErrors:(NSInteger)errorCode;

+ (void)displayAlertView:(NSString *)messageTitle
                 message:(NSString *)message
       cancelButtonTitle:(NSString *)cancelButtonTitle;

+ (void)displayErrorMessage:(NSString *)messageTitle
                    message:(NSString *)message
          cancelButtonTitle:(NSString *)cancelButtonTitle;

@end
