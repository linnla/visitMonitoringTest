//
//  JSON.h
//  Library
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface JSON : NSObject

// Throws error messages if FILE DOES NOT exist or JSON is NOT a DICTIONARY OBJECT.

//+ (NSDictionary *)getJSONDictionaryAtFilePath:(NSString *)filePath;

// Throws error messages if FILE DOES NOT exist or JSON is NOT a ARRAY OBJECT.

+ (NSArray *)getJSONArrayAtFilePath:(NSString *)filePath;

// Throws error messages if FILE DOES NOT exist.
// Use this when you doesn't know what type of object the json is.

+ (id)getJSONAtFilePath:(NSString *)filePath;

+ (BOOL)    writeJSON:(id)json
                    toFilePath:(NSString *)filePath
            deleteFileIfExists:(BOOL)deleteFileIfExists
    createDirectoryIfNotExists:(BOOL)createDirectoryIfNotExists;

@end
