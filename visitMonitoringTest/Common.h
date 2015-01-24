//
//  Common.h
//  MySun
//
//  Created by Laure Linn on 10/2/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLVisitLog.h"
#import "UIColor+MLPFlatColors.h"
#import "Constants.h"
#import "LocationServices.h"
#import "RelativeDateDescriptor.h"
#import "Messages.h"
#import "JSON.h"
#import "Images.h"

@interface Common : NSObject

+ (NSDateFormatter *)dateFormatter_localDate;
+ (NSDateFormatter *)dateFormatter_localTime;
+ (NSDateFormatter *)dateFormatter_localDateTime;

+ (NSString *)filePathForLocations;
+ (NSString *)filePathForCLVisits;
+ (NSString *)filePathForPlaces;
+ (NSString *)filePathForLastCLVisit;
+ (NSString *)filePathForRegions;

+ (NSString *)computeDurationStringWithDate1:(NSDate *)date1 date2:(NSDate *)date2;
+ (NSUInteger)computeDurationInMinutesWithDate1:(NSDate *)date1 date2:(NSDate *)date2;
+ (NSString *)computeDurationFromNowStringWithDate:(NSDate *)date;

+ (void)fireNotificationWithText:(NSString *)text;

+ (NSString *)fileNameFromDate:(NSDate *)date;

+ (UIImage *)imageWithColor:(UIColor *)color;

+ (UIColor *)colorFromHexString:(NSString *)hexString;

// wrapper for [UIColor colorWithRed:green:blue:alpha:]
// values must be in range 0 - 255
+ (UIColor*)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha;

// Creates color using hex representation
// hex - must be in format: #FF00CC
// alpha - must be in range 0.0 - 1.0
+ (UIColor*)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha;

+ (UIColor *)getHSBWithRGB:(double)redValue green:(double)greenValue blue:(double)blueValue;

@end
