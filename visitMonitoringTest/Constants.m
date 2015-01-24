//
//  Constants.m
//  MySun
//
//  Created by Laure Linn on 7/16/14.
//  Copyright (c) 2014 Laure Linn. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString* const kAppName =  @"MySun";

// Files used in app
NSString* const kLocations = @"locations";
NSString* const kCLVisits = @"clvisits";
NSString* const kPlaces = @"places";
NSString* const kSunlog = @"sunlog";
NSString* const kRegions = @"regions";

NSString* const kOk =  @"Ok";
NSString* const kSave =  @"Save";
NSString* const kCancel =  @"Cancel";
NSString* const kUnknown =  @"Unknown";

// File Names
NSString* const kFileName =  @"fileName";
NSString* const kDirectory =  @"directory";
NSString* const kCanEditPage =  @"canEditPage";
NSString* const kPageNumber =  @"pageNumber";

// Forms
NSString* const kFormSegmentText =  @"New";
NSString* const kFormFilePrefix = @"Form_";
NSString* const kFormsDirectory = @"/forms";
NSString* const kFormTemplate = @"formTemplates";

// Drafts
NSString* const kDraftSegmentText =  @"Drafts";
NSString* const kDraftsFilePrefix =  nil;
NSString* const kDraftsDirectory = @"/drafts";
NSString* const kDraftStatus = @"Draft";

// Submitted
NSString* const kSubmittedSegmentText = @"Submitted";
NSString* const kSubmittedFilePrefix =  nil;
NSString* const kSubmittedDirectory = @"/submitted";
NSString* const kSubmittedStatus = @"Submitted";

// File Extensions
NSString* const kJsonFileExtension =  @"json";
NSString* const kAudioFileExtension =  @"caf";
NSString* const kMovieFileExtension =  @"mov";
NSString* const kImageFileExtension =  @"png";

// Form
NSString* const kFormError =  @"Form Error";

NSString* const kFormCreated =  @"Form Created";
NSString* const kFormCreateError =  @"Form NOT Created";

NSString* const kFormUpdated =  @"Form Updated";
NSString* const kFormUpdateError =  @"Form NOT Updated";

NSString* const kFormSaved =  @"Form Saved";
NSString* const kFormSaveError =  @"Form NOT Saved";

NSString* const kFormSavedToServer =  @"Form Saved To Server";
NSString* const kFormSaveToServerError =  @"Form NOT Saved To Server";

NSString* const kFormSubmitted =  @"Form Submitted";
NSString* const kFormSubmitError =  @"Form NOT Submitted";

NSString* const kFormDeleted =  @"Form Deleted";
NSString* const kFormDeleteError =  @"Form NOT Deleted";

NSString* const kFormExists =  @"Form Exists";
NSString* const kFormExistsError =  @"Error Form Exists";

NSString* const kFormConvertedToDictionary =  @"Form Converted To Dictionary";
NSString* const kFormConvertToDictionaryError =  @"Form NOT Converted To Dictionary";

NSString* const kFormConvertedToJSON =  @"Form Converted To JSON";
NSString* const kFormConvertToJSONError =  @"Form NOT Converted To JSON";

// PDF
NSString* const kPDFCreated =  @"PDF Created";
NSString* const kPDFCreateError = @"PDF NOT Created";

NSString* const kPDFSaved =  @"PDF Saved";
NSString* const kPDFSaveError = @"PDF NOT Saved";

NSString* const kPDFWriteError = @"PDF Write Error";
NSString* const kPDFReadError = @"PDF Read Error";

NSString* const kPDFDeleted =  @"PDF Deleted";
NSString* const kPDFDeleteError = @"PDF NOT Deleted";

NSString* const kPDFExists =  @"PDF Exists";
NSString* const kPDFExistsError = @"Error PDF Exists";
NSString* const kPDFNotFoundError = @"PDF NOT Found";

// File
NSString* const kFileError=  @"File Error";

NSString* const kFileCreated =  @"File Created";
NSString* const kFileCreateError=  @"File NOT Created";

NSString* const kFileSaved =  @"File Saved";
NSString* const kFileSaveError =  @"File NOT Saved";

NSString* const kFileWriteError =  @"File Write Error";
NSString* const kFileReadError =  @"File Read Error";

NSString* const kFileDeleted =  @"File Deleted";
NSString* const kFileDeleteError =  @"File NOT Deleted";

NSString* const kFileExists =  @"File Exists";
NSString* const kFileExistsError =  @"Error File Exists";
NSString* const kFileNotFound =  @"File Not Found";
NSString* const kFileNotFoundError =  @"File NOT Found";

NSString* const kFileLoaded =  @"File Loaded";
NSString* const kFileLoadError =  @"File NOT Loaded";

NSString* const kFileCopied =  @"File Copied";
NSString* const kFileCopyError =  @"File NOT Copied";

// Directory
NSString* const kDirectoryCreated =  @"Directory Created";
NSString* const kDirectoryCreateError=  @"Directory NOT Created";

NSString* const kDirectoryReadError =  @"Directory Read Error";

NSString* const kDirectoryDeleted =  @"Directory Deleted";
NSString* const kDirectoryDeleteError =  @"Directory NOT Deleted";

NSString* const kDirectoryExists =  @"Directory Exists";
NSString* const kDirectoryNotExistsError =  @"Directory Does Not Exist";
NSString* const kDirectoryExistsError =  @"Error Directory Exists";
NSString* const kDirectoryNotFoundError =  @"Directory NOT Found";

// JSON
NSString* const kJSONCreated =  @"JSON Created";
NSString* const kJSONCreateError =  @"JSON NOT Created";

NSString* const kJSONConverted =  @"JSON Converted";
NSString* const kJSONConversionError =  @"JSON NOT Converted";

NSString* const kJSONResponseNil = @"JSON Response is nil";
NSString* const kJSONResponseError = @"JSON Response error";
NSString* const kJSONSubmitError = @"JSON submit error";

NSString* const kJSONParsed = @"JSON Parsed";
NSString* const kJSONParsingError = @"JSON NOT Parsed";

NSString* const kJSONToDictionaryConverted = @"JSON Converted to Dictionary";
NSString* const kJSONToDictionaryConversionError = @"JSON NOT Converted to Dictionary";

NSString* const kJSONToArrayConverted = @"JSON Converted to Array";
NSString* const kJSONToArrayConversionError = @"JSON NOT Converted to Array";

NSString* const kJSONNotArrayError = @"JSON is NOT an Array";
NSString* const kJSONNotDictionaryError = @"JSON is NOT a Dictionary";

NSInteger const kServerTimeOut = 10;
//NSString* const kStoresURL = @"http://10.1.3.110/
NSString* const kEPADataServerURL = @"http://iaspub.epa.gov/enviro/efservice/getEnvirofactsUVHOURLY/ZIP/";

//NSString* const kDataServerURL = @"http://ec2-54-187-221-190.us-west-2.compute.amazonaws.com:4949";
NSString* const kDataServerURL = @"http://ec2-54-69-219-12.us-west-2.compute.amazonaws.com:4949";

// Data
NSString* const kDataError = @"Data error";
NSString* const kDataNotFoundError = @"Data not found";
NSString* const kDataNilError= @"Data is nil";

// Array
NSString* const kArrayNilError = @"Array is nil";
NSString* const kArrayCountZeroError = @"Array count equal";

// HTTP
NSString* const kHttpRequestSent = @"HTTP Request Sent";
NSString* const kHttpMethodError = @"HTTP Command Error";
NSString* const kHttpResponseError = @"HTTP Response Error";

NSString* const kHttpPost = @"POST";
NSString* const kHttpPostError = @"POST Error";
NSString* const kHttpPostRequest = @"HTTP POST Request Sent";
NSString* const kHttpPostResponded = @"HTTP POST Responded";
NSString* const kHttpPostSuccess = @"HTTP POST";
NSString* const kHttpPostFailure = @"HTTP POST FAILED";

NSString* const kHttpPut = @"PUT";
NSString* const kHttpPutError = @"PUT Error";
NSString* const kHttpPutRequest = @"HTTP PUT Request Sent";
NSString* const kHttpPutResponded = @"HTTP PUT Responded";
NSString* const kHttpPutSuccess = @"HTTP PUT";
NSString* const kHttpPutFailure = @"HTTP PUT FAILED";

NSString* const kHttpGet = @"GET";
NSString* const kHttpGetError = @"GET Error";
NSString* const kHttpGetRequest = @"HTTP GET Request Sent";
NSString* const kHttpGetResponseNoData = @"HTTP GET Responded With No Data";
NSString* const kHttpGetResponded = @"HTTP GET Responded";
NSString* const kHttpGetSuccess = @"HTTP GET";
NSString* const kHttpGetFailure = @"HTTP GET FAILED";

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

+ (NSString *)decodeLocationServicesErrors:(NSInteger)errorCode {
    
    /* CFURL and CFURLConnection Errors */
    // CL ERRORS
    
    /*
    kCLErrorLocationUnknown   = 0,
    kCLErrorDenied ,
    kCLErrorNetwork ,
    kCLErrorHeadingFailure ,
    kCLErrorRegionMonitoringDenied ,
    kCLErrorRegionMonitoringFailure ,
    kCLErrorRegionMonitoringSetupDelayed ,
    kCLErrorRegionMonitoringResponseDelayed ,
    kCLErrorGeocodeFoundNoResult ,
    kCLErrorGeocodeFoundPartialResult ,
    kCLErrorGeocodeCanceled ,
    kCLErrorDeferredFailed ,
    kCLErrorDeferredNotUpdatingLocation ,
    kCLErrorDeferredAccuracyTooLow ,
    kCLErrorDeferredDistanceFiltered ,
    kCLErrorDeferredCanceled ,
    kCLErrorRangingUnavailable ,
    kCLErrorRangingFailure ,
     */
    
    if (errorCode == 0) return @"Is the phone in airplane mode?";
    return nil;
}


@end
