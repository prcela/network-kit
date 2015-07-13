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

NS_ASSUME_NONNULL_BEGIN

@interface NKWebRequestProcessorInfo : NSObject
@property(nonatomic,strong) NSMutableArray *errors;
@end

@interface NKWebRequestProcessor : NSObject

+ (NKWebRequestProcessorInfo*)info;

+ (void) process:(NKWebRequest*)request;

+ (void) process:(NKWebRequest*)request
         success:(nullable void (^)(NSObject *response))success
         failure:(nullable void (^)(NSError *error))failure
         finish:(nullable void (^)())finish;

@end

NS_ASSUME_NONNULL_END