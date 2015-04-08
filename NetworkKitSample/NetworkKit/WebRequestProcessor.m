//
//  WebRequestProcessor.m
//  MdmStory
//
//  Created by Kresimir Prcela on 15/02/14.
//  Copyright (c) 2014 minus5. All rights reserved.
//

#import "WebRequestProcessor.h"
#import "DownloadWebRequest.h"
#import "WebResponse.h"
#import "WebRequestError.h"

@implementation WebRequestProcessorInfo
@end

@implementation WebRequestProcessor

+ (WebRequestProcessorInfo*)info
{
    static WebRequestProcessorInfo *_info = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _info = [WebRequestProcessorInfo new];
        _info.errors = [NSMutableArray new];
    });
    return _info;
}

+ (NSURLSessionConfiguration*) defaultConfiguration
{
    static NSURLSessionConfiguration *_defaultConfiguration = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _defaultConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _defaultConfiguration.timeoutIntervalForRequest = 30;
    });
    return _defaultConfiguration;
}

+ (void) process:(WebRequest*)request
{
    [self process:request
          success:nil
          failure:nil
           finish:nil];
}

+ (void) process:(WebRequest*)request
         success:(void (^)(NSObject *response))success
         failure:(void (^)(NSError *error))failure
          finish:(void (^)())finish
{
    NSURLSession *session;
    if (request.queue || request.delegate)
    {
        session = [NSURLSession sessionWithConfiguration:[self defaultConfiguration]
                                                delegate:request.delegate
                                           delegateQueue:request.queue];
    }
    else
    {
        session = [NSURLSession sessionWithConfiguration:[self defaultConfiguration]];
    }
    
    if ([request isKindOfClass:[DownloadWebRequest class]])
    {
        [self processDownloadRequest:(DownloadWebRequest*)request
                             session:session
                             success:success
                             failure:failure
                              finish:finish];
    }
    else
    {
        [self processDataRequest:request
                         session:session
                         success:success
                         failure:failure
                          finish:finish];
    }
    
}

+ (void) processDataRequest:(WebRequest *)request
                    session:(NSURLSession*)session
                    success:(void (^)(NSObject *response))success
                    failure:(void (^)(NSError *error))failure
                     finish:(void (^)())finish
{
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                  {
                                      NSHTTPURLResponse *httpResp = (NSHTTPURLResponse*) response;
                                      WebResponse *webResponse = [WebResponse new];
                                      webResponse.data = data;
                                      webResponse.statusCode = httpResp.statusCode;
                                      
                                      NSLog(@"Finished request %@ with status: %ld", request.URL, (long)[httpResp statusCode]);
                                      
#ifdef DEBUG
                                      if ([data length]<1000)
                                      {
                                          NSString *strData = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                                          if (strData.length)
                                          {
                                              NSLog(@"%@", strData);
                                          }
                                      }
                                      else
                                      {
                                          NSLog(@"Response data is large... Wont dump it.");
                                      }
#endif
                                      
                                      if (error)
                                      {
                                          WebRequestError *webReqError = [WebRequestError new];
                                          webReqError.error = error;
                                          webReqError.timestamp = [NSDate new];
                                          webReqError.url = request.URL;
                                          webReqError.statusCode = webResponse.statusCode;

                                          NSLog(@"%@", [error localizedDescription]);

                                          
                                          if (failure)
                                          {
                                              failure(error);
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [[self info].errors addObject:webReqError];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWebRequestError
                                                                                                  object:webReqError];
                                          });
                                      }
                                      else if (webResponse.statusCode >= 400 && webResponse.statusCode != 401)
                                      {
                                          WebRequestError *webReqError = [WebRequestError new];
                                          webReqError.error = error;
                                          webReqError.timestamp = [NSDate new];
                                          webReqError.url = request.URL;
                                          webReqError.statusCode = webResponse.statusCode;
                                          
                                          if (failure)
                                          {
                                              failure(error);
                                          }
                                          
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              [[self info].errors addObject:webReqError];
                                              [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWebRequestError
                                                                                                  object:webReqError];
                                          });
                                      }
                                      else
                                      {
                                          if(success)
                                          {
                                              success(webResponse);
                                          }
                                      }
                                      
                                      if (request.notificationName)
                                      {
                                          dispatch_async(dispatch_get_main_queue(), ^{
                                              id object = request.notificationObject ? request.notificationObject : webResponse;
                                              [[NSNotificationCenter defaultCenter] postNotificationName: request.notificationName
                                                                                                  object: object];
                                          });
                                      }
                                      
                                      if (finish)
                                      {
                                          finish();
                                      }
                                  }];
    
    [task resume];
    
    
}

+ (void) processDownloadRequest:(DownloadWebRequest*)request
                        session:(NSURLSession*)session
                        success:(void (^)(NSObject *response))success
                        failure:(void (^)(NSError *error))failure
                         finish:(void (^)())finish
{
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                        NSHTTPURLResponse *httpResp __unused = (NSHTTPURLResponse*) response;
                                                        
                                                        NSLog(@"Finished download request %@ with status:%ld", request.URL, (long)[httpResp statusCode]);
                                                        
                                                        if (error)
                                                        {
                                                            WebRequestError *webReqError = [WebRequestError new];
                                                            webReqError.error = error;
                                                            webReqError.timestamp = [NSDate new];
                                                            webReqError.url = request.URL;
                                                            webReqError.statusCode = httpResp.statusCode;

                                                            NSLog(@"%@", [error localizedDescription]);
                                                            
                                                            if (failure)
                                                            {
                                                                failure(error);
                                                            }
                                                            
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                [[self info].errors addObject:webReqError];
                                                                [[NSNotificationCenter defaultCenter] postNotificationName:NotificationWebRequestError
                                                                                                                    object:webReqError];
                                                            });

                                                        }
                                                        else
                                                        {
                                                            if (request.downloadFilePath)
                                                            {
                                                                NSFileManager *fm = [NSFileManager defaultManager];
                                                                NSString *folder = [request.downloadFilePath stringByDeletingLastPathComponent];
                                                                if (![fm fileExistsAtPath:folder])
                                                                {
                                                                    [fm createDirectoryAtPath:folder withIntermediateDirectories:YES attributes:nil error:&error];
                                                                }
                                                                if ([fm fileExistsAtPath:request.downloadFilePath])
                                                                {
                                                                    [fm removeItemAtPath:request.downloadFilePath error:&error];
                                                                }
                                                                [fm moveItemAtURL:location toURL:[NSURL fileURLWithPath:request.downloadFilePath] error:&error];
                                                                if (error)
                                                                {
                                                                    NSLog(@"%@", error.description);
                                                                }
                                                            }
                                                            
                                                            if (success)
                                                            {
                                                                success(response);
                                                            }
                                                        }
                                                        
                                                        if (request.notificationName)
                                                        {
                                                            dispatch_async(dispatch_get_main_queue(), ^{
                                                                id object = request.notificationObject ? request.notificationObject : response;
                                                                [[NSNotificationCenter defaultCenter] postNotificationName: request.notificationName
                                                                                                                    object: object];
                                                            });
                                                        }
                                                        
                                                        if (finish)
                                                        {
                                                            finish();
                                                        }
                                                        
                                                    }];
    [task resume];
}

@end
