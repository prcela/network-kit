//
//  DownloadWebRequest.h
//  MdmStory
//
//  Created by Kresimir Prcela on 24/02/14.
//  Copyright (c) 2014 minus5. All rights reserved.
//

#import "NKWebRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface NKDownloadWebRequest : NKWebRequest

@property (nonatomic, strong, nullable) NSString *downloadFilePath;

@end

NS_ASSUME_NONNULL_END