//
//  WebRequestProcessor.h
//  MdmStory
//
//  Created by Kresimir Prcela on 15/02/14.
//  Copyright (c) 2014 minus5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebRequest.h"

#define NotificationWebRequestError @"NotificationWebRequestError"

@interface WebRequestProcessorInfo : NSObject
@property(nonatomic,strong) NSDate *lastProcessedTimestamp;
@property(nonatomic,strong) WebRequest *lastProcessedWebRequest;
@property(nonatomic,assign) BOOL success;
@end

@interface WebRequestProcessor : NSObject

+ (WebRequestProcessorInfo*)info;

+ (void) process:(WebRequest*)request;

+ (void) process:(WebRequest*)request
         success:(void (^)(NSObject *response))success
         failure:(void (^)(NSError *error))failure
         finish:(void (^)())finish;

@end

