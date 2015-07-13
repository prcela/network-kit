//
//  WebResponse.m
//  MdmStory
//
//  Created by Kresimir Prcela on 04/12/13.
//  Copyright (c) 2013 100kas. All rights reserved.
//

#import "NKWebResponse.h"

@implementation NKWebResponse

@synthesize statusCode;
@synthesize data;

- (BOOL) isOk
{
    return statusCode == 200;
}

- (NSObject*) parsedJsonObject
{
    if (data)
    {
        NSObject *object = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingMutableContainers
                                                             error:nil];
        return object;
    }
    return nil;
}
@end
