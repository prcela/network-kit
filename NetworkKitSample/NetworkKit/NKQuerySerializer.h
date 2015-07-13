//
//  QuerySerializer.h
//  MdmStory
//
//  Created by Kresimir Prcela on 07/01/14.
//  Copyright (c) 2014 100kas. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NKQuerySerializer : NSObject

+(NSString*)serialize:(NSDictionary*)query;

@end

NS_ASSUME_NONNULL_END