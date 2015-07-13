//
//  WebRequest.h
//  MdmStory
//
//  Created by Kresimir Prcela on 9/20/13.
//  Copyright (c) 2013 100kas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKWebRequest : NSMutableURLRequest

@property (nonatomic, strong, nullable) NSString *notificationName;
@property (nonatomic, retain, nullable) NSObject *notificationObject;
@property (nonatomic, retain, nullable) NSOperationQueue *queue;
@property (nonatomic, assign) id<NSURLSessionDelegate> delegate;

- (instancetype) initWithHost:(NSString*)host path:(nullable NSString*)path;
- (instancetype) initWithMethod: (NSString*)method host:(NSString*)host path:(nullable NSString*)path params:(nullable NSString*)params;
- (instancetype) initWithHost:(NSString*)host path:(nullable NSString *)path jsonData:(NSData*)data;
@end

NS_ASSUME_NONNULL_END