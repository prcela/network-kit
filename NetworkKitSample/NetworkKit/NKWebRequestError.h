//
//  WebRequestError.h
//  NetworkKitSample
//
//  Created by Kresimir Prcela on 31/03/15.
//  Copyright (c) 2015 100kas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKWebRequestError : NSObject
@property(nonatomic,strong) NSDate *timestamp;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong) NSError *error;
@property(nonatomic,assign) NSInteger statusCode;
@end

NS_ASSUME_NONNULL_END