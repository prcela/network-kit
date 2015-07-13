//
//  WebRequestProcessor.h
//  MdmStory
//
//  Created by Kresimir Prcela on 15/02/14.
//  Copyright (c) 2014 minus5. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NKWebRequest.h"

#define NotificationWebRequestError @"NotificationWebRequestError"

@interface NKWebRequestProcessorInfo : NSObject
@property(nonatomic,strong) NSMutableArray *errors;
@end

@interface NKWebRequestProcessor : NSObject

+ (NKWebRequestProcessorInfo*)info;

+ (void) process:(NKWebRequest*)request;

+ (void) process:(NKWebRequest*)request
         success:(void (^)(NSObject *response))success
         failure:(void (^)(NSError *error))failure
         finish:(void (^)())finish;

@end

