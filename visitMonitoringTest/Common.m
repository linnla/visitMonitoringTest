//
//  Common.m
//  MySun
//
//  Created by Laure Linn on 10/2/14.
//  Copyright (c) 2014 LAL. All rights reserved.
//

#import "Common.h"

@implementation Common

+ (NSDateFormatter *)dateFormatter_localTime {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterNoStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    return df;
}

+ (NSDateFormatter *)dateFormatter_localDate {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterShortStyle];
    [df setTimeStyle:NSDateFormatterNoStyle];
    //[df setDateFormat:@"yyyy-MM-dd"];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    return df;
}

+ (NSDateFormatter *)dateFormatter_localDateTime {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateStyle:NSDateFormatterMediumStyle];
    [df setTimeStyle:NSDateFormatterShortStyle];
    [df setTimeZone:[NSTimeZone localTimeZone]];
    return df;
}

+ (NSString *)fileNameFromDate:(NSDate *)date {
    
    NSString *filename;
    NSDateFormatter *dateFormatter_FileName = [[NSDateFormatter alloc] init];
    [dateFormatter_FileName setDateFormat:@"yyyyMMdd"];
    filename = [dateFormatter_FileName stringFromDate:date];
    
    return filename;
}

+ (NSString *)computeDurationStringWithDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    
    NSString *duration;
    
    NSTimeInterval timeInterval = abs([date1 timeIntervalSinceDate:date2]);
    
    // When distant past or distant future dates in date1 or date2, timeInterval is negative and can't be fixed.
    if (timeInterval < 0) {
        return nil;
    }
    
    long seconds = lroundf(timeInterval); // Modulo (%) operator below needs int or long
    
    // This condition should not occur as only one day is presented at a time
    // In this case, seconds will be greater than seconds in 1 day
    NSInteger secondsInDay = 24*60*60;
    if (seconds > secondsInDay) return nil;
    
    int hours = seconds / 3600;
    NSString *hoursString = [[NSString stringWithFormat:@"%d", hours] stringByAppendingString:@" hr"];
    
    int mins = (seconds % 3600) / 60;
    NSString *minsString = [[NSString stringWithFormat:@"%d", mins] stringByAppendingString:@" min"];
    
    int secs = seconds % 60;
    NSString *secsString = [[NSString stringWithFormat:@"%d", secs] stringByAppendingString:@" sec"];
    
    if (hours == 0 && seconds < 60) duration = @"< 1 min";
    else if (hours >= 1 && mins != 0) duration = [[hoursString stringByAppendingString:@" "] stringByAppendingString:minsString];
    else if (hours >= 1 && mins == 0) duration = [hoursString stringByAppendingString:@" "];
    else duration = minsString;
    
    return duration;
}

+ (NSString *)computeDurationFromNowStringWithDate:(NSDate *)date  {
    
    NSString *duration;
    
    if (![[NSCalendar currentCalendar] isDateInToday:date]) return nil;
    
    NSTimeInterval timeInterval = abs([date timeIntervalSinceNow]);
    
    // When distant past or distant future dates in date1 or date2, timeInterval is negative and can't be fixed.
    if (timeInterval < 0) {
        return nil;
    }
    
    long seconds = lroundf(timeInterval); // Modulo (%) operator below needs int or long
    
    int hours = seconds / 3600;
    NSString *hoursString = [[NSString stringWithFormat:@"%d", hours] stringByAppendingString:@" hr"];
    
    int mins = (seconds % 3600) / 60;
    NSString *minsString = [[NSString stringWithFormat:@"%d", mins] stringByAppendingString:@" min"];
    
    int secs = seconds % 60;
    NSString *secsString = [[NSString stringWithFormat:@"%d", secs] stringByAppendingString:@" sec"];
    
    if (hours == 0 && seconds < 60) duration = @"< 1 min";
    else if (hours >= 1 && mins != 0) duration = [[hoursString stringByAppendingString:@" "] stringByAppendingString:minsString];
    else if (hours >= 1 && mins == 0) duration = [hoursString stringByAppendingString:@" "];
    else duration = minsString;
    
    return duration;
}

+ (NSUInteger)computeDurationInMinutesWithDate1:(NSDate *)date1 date2:(NSDate *)date2 {
    
    NSTimeInterval timeInterval = abs([date1 timeIntervalSinceDate:date2]);
    long seconds = lroundf(timeInterval); // Modulo (%) operator below needs int or long
    
    return floor(seconds/60);
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (UIColor *)colorWith8BitRed:(NSInteger)red green:(NSInteger)green blue:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(red/255.0) green:(green/255.0) blue:(blue/255.0) alpha:alpha];
}

+ (UIColor *)colorWithHex:(NSString*)hex alpha:(CGFloat)alpha
{
    assert(7 == [hex length]);
    assert('#' == [hex characterAtIndex:0]);
    
    NSString *redHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(1, 2)]];
    NSString *greenHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(3, 2)]];
    NSString *blueHex = [NSString stringWithFormat:@"0x%@", [hex substringWithRange:NSMakeRange(5, 2)]];
    
    unsigned redInt = 0;
    NSScanner *rScanner = [NSScanner scannerWithString:redHex];
    [rScanner scanHexInt:&redInt];
    
    unsigned greenInt = 0;
    NSScanner *gScanner = [NSScanner scannerWithString:greenHex];
    [gScanner scanHexInt:&greenInt];
    
    unsigned blueInt = 0;
    NSScanner *bScanner = [NSScanner scannerWithString:blueHex];
    [bScanner scanHexInt:&blueInt];
    
    return [self colorWith8BitRed:redInt green:greenInt blue:blueInt alpha:alpha];
}

+ (UIColor *)getHSBWithRGB:(double)redValue green:(double)greenValue blue:(double)blueValue
{
    // Test values
    CGFloat red = redValue/255.0f;
    CGFloat green = greenValue/255.0f;
    CGFloat blue = blueValue/255.0f;
    
    CGFloat hue = 0;
    CGFloat saturation = 0;
    CGFloat brightness = 0;
    
    CGFloat minRGB = MIN(red, MIN(green,blue));
    CGFloat maxRGB = MAX(red, MAX(green,blue));
    
    if (minRGB==maxRGB) {
        hue = 0;
        saturation = 0;
        brightness = minRGB;
    } else {
        CGFloat d = (red==minRGB) ? green-blue : ((blue==minRGB) ? red-green : blue-red);
        CGFloat h = (red==minRGB) ? 3 : ((blue==minRGB) ? 1 : 5);
        hue = (h - d/(maxRGB - minRGB)) / 6.0;
        saturation = (maxRGB - minRGB)/maxRGB;
        brightness = maxRGB;
    }
    NSLog(@"hue: %0.2f, saturation: %0.2f, value: %0.2f", hue, saturation, brightness);
    
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    
}

+ (NSString *)filePathForPlaces {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = documentsDirectory;
    NSString *fileName = kPlaces;
    NSString *filePath = [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:kJsonFileExtension];
    return filePath;
}

+ (NSString *)filePathForRegions {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = documentsDirectory;
    NSString *fileName = kRegions;
    NSString *filePath = [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:kJsonFileExtension];
    return filePath;
}

+ (NSString *)filePathForLocations {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = documentsDirectory;
    NSString *fileName = kLocations;
    NSString *filePath = [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:kJsonFileExtension];
    return filePath;
}

+ (NSString *)filePathForLastCLVisit {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = documentsDirectory;
    NSString *fileName = @"lastCLVisit";
    NSString *filePath = [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:kJsonFileExtension];
    return filePath;
}

+ (NSString *)filePathForCLVisits {
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
    NSString *directory = documentsDirectory;
    NSString *fileName = kCLVisits;
    NSString *filePath = [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:kJsonFileExtension];
    return filePath;
}

+ (void)fireNotificationWithText:(NSString *)text {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = text;
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    notification.fireDate = [NSDate date];
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

@end
