//
//  NSMutableData+Multipart.h
//  MdmStory
//
//  Created by Kresimir Prcela on 18/02/14.
//  Copyright (c) 2014 minus5. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableData(Multipart)

- (void) appendPartName:(NSString*)name value:(NSString*)value boundary:(NSString*)boundary;
- (void) appendPartFile:(NSString*)fileName name:(NSString*)name data:(NSData*)data mimeType:(NSString*)mimeType boundary:(NSString*)boundary;

@end
