//
//  JSON.m
//  Library
//
//  Created by Laure Linn on 8/21/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "JSON.h"

#define DISPLAY_ALERTS 1

@implementation JSON

+ (NSDictionary *)getJSONDictionaryAtFilePath:(NSString *)filePath {
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *errorMessage = [[kFileNotFoundError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *jsonDataError;
    id JSONResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonDataError];
    
    if (jsonDataError) {
        NSString *errorMessage = [[[[kJSONParsingError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]]
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[jsonDataError localizedDescription]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    if (![JSONResponse isKindOfClass:[NSDictionary class]]) {
        NSString *errorMessage = [[kJSONNotDictionaryError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    return JSONResponse;
}

+ (NSArray *)getJSONArrayAtFilePath:(NSString *)filePath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *errorMessage = [[kFileNotFoundError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *jsonDataError;
    id JSONResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonDataError];
    
    if (jsonDataError) {
        NSString *errorMessage = [[[[kJSONParsingError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]]
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[jsonDataError localizedDescription]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    if (![JSONResponse isKindOfClass:[NSArray class]]) {
        NSString *errorMessage = [[kJSONNotArrayError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    return JSONResponse;
}

+ (id)getJSONAtFilePath:(NSString *)filePath {
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSString *errorMessage = [[kFileNotFoundError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSError *jsonDataError;
    id JSONResponse = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &jsonDataError];
    
    if (jsonDataError) {
        NSString *errorMessage = [[[[kJSONParsingError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]]
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[jsonDataError localizedDescription]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileLoadError message:errorMessage cancelButtonTitle:kOk];
        return nil;
    }
    
    return JSONResponse;
}

+ (BOOL)    writeJSON:(id)json
                    toFilePath:(NSString *)filePath
            deleteFileIfExists:(BOOL)deleteFileIfExists
    createDirectoryIfNotExists:(BOOL)createDirectoryIfNotExists {
    BOOL jsonWritten;
    
    NSString *directory = [filePath stringByDeletingLastPathComponent];
    
    BOOL isDirectory = YES;
    if (![[NSFileManager defaultManager] fileExistsAtPath:directory isDirectory:&isDirectory])
    {
        if (createDirectoryIfNotExists == YES)
        {
            NSError *directoryCreateError;
            [[NSFileManager defaultManager] createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:&directoryCreateError];
            
            if (directoryCreateError) {
                
                NSString *errorMessage = [[[[kDirectoryCreateError
                                        stringByAppendingString:@"\n"]
                                        stringByAppendingString:directory]
                                        stringByAppendingString:@"\n"]
                                        stringByAppendingString:[directoryCreateError localizedDescription]];
                
                NSLog(@"%@", errorMessage);
                //[Messages displayErrorMessage:kFileWriteError message:errorMessage cancelButtonTitle:kOk];
                return jsonWritten = NO;
            }
        } else {
            
            NSString *message = [[kDirectoryNotExistsError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:directory];
            
            NSLog(@"%@", message);
            //[Messages displayErrorMessage:kFileWriteError message:message cancelButtonTitle:kOk];
            return jsonWritten = NO;
        }
    }
    
    NSError *convertToJSONError;
    
    //id lookAtJSON = json;
    
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&convertToJSONError];
    
    if (convertToJSONError)
    {
        NSString *errorMessage = [[[[kJSONParsingError
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[filePath lastPathComponent]]
                                stringByAppendingString:@"\n"]
                                stringByAppendingString:[convertToJSONError localizedDescription]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileWriteError message:errorMessage cancelButtonTitle:kOk];
        return jsonWritten = NO;
    }
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath])
    {
        if (deleteFileIfExists == NO) {
            NSString *errorMessage = [[kFileExistsError
                                    stringByAppendingString:@"\n"]
                                    stringByAppendingString: [filePath lastPathComponent]];
        
            NSLog(@"%@", errorMessage);
            //[Messages displayErrorMessage:kFileDeleteError message:errorMessage cancelButtonTitle:kOk];
            NSLog(@"%@", errorMessage);
            
            return jsonWritten = NO;
        
        } else {
            
            NSError *deleteError = nil;
            [[NSFileManager defaultManager] removeItemAtPath:filePath error:&deleteError];
        
            if (deleteError) {
                
                NSString *errorMessage = [[[[kFileDeleteError
                                    stringByAppendingString:@"\n"]
                                    stringByAppendingString:[filePath lastPathComponent]]
                                    stringByAppendingString:@"\n"]
                                    stringByAppendingString: [deleteError localizedDescription]];
            
                NSLog(@"%@", errorMessage);
                //[Messages displayErrorMessage:kFileDeleteError message:errorMessage cancelButtonTitle:kOk];
                
                return jsonWritten = NO;
            }
        }
    }
    
    NSError *writeError;
    [data writeToFile:filePath options:NSUTF8StringEncoding error:&writeError];
    
    if (!writeError) return jsonWritten = YES;
    else
    {
        NSString *errorMessage = [[[filePath lastPathComponent]
                                stringByAppendingString:@"\n"]
                                stringByAppendingString: [writeError localizedDescription]];
        
        NSLog(@"%@", errorMessage);
        //[Messages displayErrorMessage:kFileWriteError message:errorMessage cancelButtonTitle:kOk];
        
        return jsonWritten = NO;
    }
}

@end
