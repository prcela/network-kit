//
//  ViewController.m
//  NetworkKitSample
//
//  Created by Kresimir Prcela on 27/02/15.
//  Copyright (c) 2015 100kas. All rights reserved.
//

#import "ViewController.h"
#import "NKWebRequest.h"
#import "NKWebRequestError.h"
#import "NKWebRequestProcessor.h"
#import "NKWebResponse.h"
#import "NKQuerySerializer.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onRequestError:)
                                                     name:NotificationWebRequestError
                                                   object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self simple];
    [self simpleWithSerializingGetParams];
    [self simplePostJSON];
    [self simpleFail];
}

- (void) simple
{
    NSString *host = @"http://ip.jsontest.com";
    NKWebRequest *request = [[NKWebRequest alloc] initWithHost:host
                                                      path:@""];
    NSLog(@"Sending %@", request.description);
    
    [NKWebRequestProcessor process:request
                         success:^(NSObject *response) {
                             NSDictionary *result = (NSDictionary*)[(NKWebResponse*)response parsedJsonObject];
                             NSLog(@"Result as dictionary: %@", result);
                         }
                         failure:nil
                          finish:nil];
}

- (void) simpleWithSerializingGetParams
{
    // "http://md5.jsontest.com/?text=example_text"
    NSString *host = @"http://md5.jsontest.com";
    NSString *getParams = [NKQuerySerializer serialize:@{@"text":@"example_text"}];
    NKWebRequest *request = [[NKWebRequest alloc] initWithHost:host path:[@"?" stringByAppendingString:getParams]];
    NSLog(@"Sending %@", request.description);
    
    [NKWebRequestProcessor process:request
                         success:^(NSObject *response) {
                             NSDictionary *result = (NSDictionary*)[(NKWebResponse*)response parsedJsonObject];
                             NSLog(@"Result of serializing get as dictionary: %@", result);
                         }
                         failure:nil
                          finish:nil];
}

- (void) simplePostJSON
{
    NSString *host = @"http://httpbin.org";
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"text":@"example_text"} options:0 error:nil];
    NKWebRequest *request = [[NKWebRequest alloc] initWithHost:host
                                                      path:@"post"
                                                  jsonData:data];
    
    NSLog(@"Sending %@", request.description);
    
    [NKWebRequestProcessor process:request
                         success:^(NSObject *response) {
                             NSDictionary *result = (NSDictionary*)[(NKWebResponse*)response parsedJsonObject];
                             NSLog(@"Result of simple JSON post as dictionary: %@", result);
                         }
                         failure:nil
                          finish:nil];
    
    
}

- (void) simpleFail
{
    NSString *host = @"http://error.error";
    NKWebRequest *request = [[NKWebRequest alloc] initWithHost:host
                                                      path:nil];
    
    [NKWebRequestProcessor process:request
                         success:^(NSObject *response) {
                         }
                         failure:^(NSError *error) {
                             NSLog(@"Intentionally made error: %@", error);
                         }
                        finish:nil];
}

- (void) onRequestError:(NSNotification*)notification
{
    // sample for request error
    NSLog(@"Catched the network error.");
    NKWebRequestError *webReqError = notification.object;
    NSLog(@"url: %@ \ntimestamp: %@ \nerror: %@", webReqError.url, webReqError.timestamp, webReqError.error);
}


@end
