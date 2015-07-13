//
//  WebResponse.h
//  MdmStory
//
//  Created by Kresimir Prcela on 04/12/13.
//  Copyright (c) 2013 100kas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKWebResponse : NSObject

@property(nonatomic,assign) NSInteger statusCode;
@property(nonatomic,strong) NSData *data;

- (BOOL) isOk;
- (nullable NSObject*) parsedJsonObject;
@end

NS_ASSUME_NONNULL_END