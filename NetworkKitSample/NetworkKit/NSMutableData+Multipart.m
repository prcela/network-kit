//
//  NSMutableData+Multipart.m
//  MdmStory
//
//  Created by Kresimir Prcela on 18/02/14.
//  Copyright (c) 2014 minus5. All rights reserved.
//

#import "NSMutableData+Multipart.h"

@implementation NSMutableData(Multipart)

- (void) appendPartName:(NSString*)name value:(NSString*)value boundary:(NSString *)boundary
{
    [self appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@", name, value] dataUsingEncoding:NSUTF8StringEncoding]];
}

- (void) appendPartFile:(NSString *)fileName name:(NSString*)name data:(NSData *)data mimeType:(NSString *)mimeType boundary:(NSString *)boundary
{
    [self appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", name, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", mimeType] dataUsingEncoding:NSUTF8StringEncoding]];
    [self appendData:data];
}
@end
