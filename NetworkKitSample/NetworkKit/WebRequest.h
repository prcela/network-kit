//
//  WebRequest.h
//  MdmStory
//
//  Created by Kresimir Prcela on 9/20/13.
//  Copyright (c) 2013 100kas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebRequest : NSMutableURLRequest

@property (nonatomic, strong) NSString *notificationName;
@property (nonatomic, retain) NSObject *notificationObject;
@property (nonatomic, retain) NSOperationQueue *queue;
@property (nonatomic, assign) id<NSURLSessionDelegate> delegate;

- (instancetype) initWithPath:(NSString*)path;
- (instancetype) initWithMethod: (NSString*)method path:(NSString*)path params:(NSString*)params;
- (instancetype) initWithPath:(NSString *)path jsonData:(NSData*)data;
@end
