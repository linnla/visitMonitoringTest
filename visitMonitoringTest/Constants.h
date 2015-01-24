//
//  Constants.h
//  MySun
//
//  Created by Laure Linn on 8/30/13.
//  Copyright (c) 2013 Laure Linn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Common.h"

@interface Constants : NSObject

extern NSString* const kAppName;

// Files used in app
extern NSString* const kLocations;
extern NSString* const kCLVisits;
extern NSString* const kPlaces;
extern NSString* const kSunLog;
extern NSString* const kRegions;

extern NSString* const kOk;
extern NSString* const kSave;
extern NSString* const kCancel;
extern NSString* const kUnknown;

// File Names
extern NSString* const kFileName;
extern NSString* const kDirectory;
extern NSString* const kCanEditPage;
extern NSString* const kPageNumber;

// File Extensions
extern NSString* const kJsonFileExtension;
extern NSString* const kAudioFileExtension;
extern NSString* const kMovieFileExtension;
extern NSString* const kImageFileExtension;

// Forms
extern NSString* const kFormSegmentText;
extern NSString* const kFormFilePrefix;
extern NSString* const kFormsDirectory;
extern NSString* const kFormTemplates;

// Drafts
extern NSString* const kDraftSegmentText;
extern NSString* const kDraftsFilePrefix;
extern NSString* const kDraftsDirectory;
extern NSString* const kDraftStatus;

// Submitted
extern NSString* const kSubmittedSegmentText;
extern NSString* const kSubmittedFilePrefix;
extern NSString* const kSubmittedDirectory;
extern NSString* const kSubmittedStatus;

// Form
extern NSString* const kFormError;

extern NSString* const kFormCreated;
extern NSString* const kFormCreateError;

extern NSString* const kFormUpdated;
extern NSString* const kFormUpdateError;

extern NSString* const kFormSaved;
extern NSString* const kFormSaveError;

extern NSString* const kFormSavedToServer;
extern NSString* const kFormSaveToServerError;

extern NSString* const kFormSubmitted;
extern NSString* const kFormSubmitError;

extern NSString* const kFormDeleted;
extern NSString* const kFormDeleteError;

extern NSString* const kFormExists;
extern NSString* const kFormExistsError;

extern NSString* const kFormConvertedToDictionary;
extern NSString* const kFormConvertToDictionaryError;

extern NSString* const kFormConvertedToJSON;
extern NSString* const kFormConvertToJSONError;

// PDF
extern NSString* const kPDFCreated;
extern NSString* const kPDFCreateError;

extern NSString* const kPDFSaved;
extern NSString* const kPDFSaveError;

extern NSString* const kPDFWriteError;
extern NSString* const kPDFReadError;

extern NSString* const kPDFDeleted;
extern NSString* const kPDFDeleteError;

extern NSString* const kPDFExists;
extern NSString* const kPDFExistsError;
extern NSString* const kPDFNotFoundError;

// File
extern NSString* const kFileError;

extern NSString* const kFileCreated;
extern NSString* const kFileCreateError;

extern NSString* const kFileSaved;
extern NSString* const kFileSaveError;
extern NSString* const kFileWriteError;

extern NSString* const kFileDeleted;
extern NSString* const kFileDeleteError;

extern NSString* const kFileExists;
extern NSString* const kFileExistsError;
extern NSString* const kFileNotFound;
extern NSString* const kFileNotFoundError;

extern NSString* const kFileLoaded;
extern NSString* const kFileLoadError;

extern NSString* const kFileCopied;
extern NSString* const kFileCopyError;

// Directory
extern NSString* const kDirectoryCreated;
extern NSString* const kDirectoryCreateError;

extern NSString* const kDirectoryReadError;

extern NSString* const kDirectoryDeleted;
extern NSString* const kDirectoryDeleteError;

extern NSString* const kDirectoryExists;
extern NSString* const kDirectoryNotExistsError;
extern NSString* const kDirectoryExistsError;
extern NSString* const kDirectoryNotFoundError;

// JSON
extern NSString* const kJSONCreated;
extern NSString* const kJSONCreateError;

extern NSString* const kJSONConverted;
extern NSString* const kJSONConversionError;

extern NSString* const kJSONResponseNil;
extern NSString* const kJSONResponseError;
extern NSString* const kJSONSubmitError;
extern NSString* const kJSONNotArrayError;
extern NSString* const kJSONNotDictionaryError;

extern NSString* const kJSONParsed;
extern NSString* const kJSONParsingError;

extern NSString* const kJSONToDictionaryConverted;
extern NSString* const kJSONToDictionaryConversionError;

extern NSString* const kJSONToArrayConverted;
extern NSString* const kJSONToArrayConversionError;

// Data
extern NSString* const kDataError;
extern NSString* const kDataNotFoundError;
extern NSString* const kDataNilError;

// Array
extern NSString* const kArrayNilError;
extern NSString* const kArrayCountZeroError;

// HTTP
extern NSString* const kHttpRequestSent;
extern NSString* const kHttpMethodError;
extern NSString* const kHttpResponseError;

extern NSString* const kHttpPost;
extern NSString* const kHttpPostError;
extern NSString* const kHttpPostRequest;
extern NSString* const kHttpPostResponsed;
extern NSString* const kHttpPostSuccess;
extern NSString* const kHttpPostFailure;

extern NSString* const kHttpPut;
extern NSString* const kHttpPutError;
extern NSString* const kHttpPutRequest;
extern NSString* const kHttpPutResponsed;
extern NSString* const kHttpPutSuccess;
extern NSString* const kHttpPutFailure;

extern NSString* const kHttpGet;
extern NSString* const kHttpGetError;
extern NSString* const kHttpGetRequest;
extern NSString* const kHttpGetResponseNoData;
extern NSString* const kHttpGetResponded;
extern NSString* const kHttpGetSuccess;
extern NSString* const kHttpGetFailure;

extern NSInteger const kServerTimeOut;
extern NSString* const kDataServerURL;
extern NSString* const kEPADataServerURL;
extern NSString* const kStoresURL;

+ (NSString *)decodeNetworkErrors:(NSInteger)errorCode;


@end
