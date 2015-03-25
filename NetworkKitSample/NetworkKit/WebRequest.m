//
//  WebRequest.m
//  MdmStory
//
//  Created by Kresimir Prcela on 9/20/13.
//  Copyright (c) 2013 100kas. All rights reserved.
//

#import "WebRequest.h"
#import "WebResponse.h"

@implementation WebRequest

@synthesize notificationName;
@synthesize notificationObject;
@synthesize queue;
@synthesize delegate;

- (instancetype) initWithHost:(NSString *)host path:(NSString *)path
{
    NSString *fullPath = path ? [host stringByAppendingPathComponent:path] : host;
    NSURL *url = [NSURL URLWithString:[fullPath stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    self = [super initWithURL:url];
    return self;
}



- (instancetype) initWithMethod: (NSString*)method host:(NSString *)host path:(NSString *)path params:(NSString *)params
{
    NSString *fullPath = path ? [host stringByAppendingPathComponent:path] : host;
    if (self = [super initWithURL:[NSURL URLWithString:fullPath]])
    {
        [super setHTTPMethod:method];
        [super setValue:@"application/x-www-form-urlencoded; charset=utf-8" forHTTPHeaderField:@"Content-Type"];

        if (params)
        {
            NSString *paramsEscaped = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            paramsEscaped = [paramsEscaped stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
            NSData * postData = [paramsEscaped dataUsingEncoding:NSUTF8StringEncoding];
            NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
            [super setValue:postLength forHTTPHeaderField:@"Content-Length"];
            [super setHTTPBody:postData];
        }
    }
    return self;
}

- (instancetype) initWithHost:(NSString *)host path:(NSString *)path jsonData:(NSData *)data
{
    NSString *fullPath = path ? [host stringByAppendingPathComponent:path] : host;
    if (self = [super initWithURL:[NSURL URLWithString:fullPath]])
    {
        [super setHTTPMethod:@"POST"];
        [super setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [super setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [super setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[data length]] forHTTPHeaderField:@"Content-Length"];
        [super setHTTPBody: data];
    }
    return self;
}





@end
