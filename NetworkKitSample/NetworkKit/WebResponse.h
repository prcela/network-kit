//
//  WebResponse.h
//  MdmStory
//
//  Created by Kresimir Prcela on 04/12/13.
//  Copyright (c) 2013 100kas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WebResponse : NSObject

@property(nonatomic,assign) NSInteger statusCode;
@property(nonatomic,strong) NSData *data;

- (BOOL) isOk;
- (id) parsedJsonObject;
@end
