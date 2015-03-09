//
//  ViewController.m
//  NetworkKitSample
//
//  Created by Kresimir Prcela on 27/02/15.
//  Copyright (c) 2015 100kas. All rights reserved.
//

#import "ViewController.h"
#import "WebRequest.h"
#import "WebRequestProcessor.h"
#import "WebResponse.h"
#import "QuerySerializer.h"

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
    WebRequest *request = [[WebRequest alloc] initWithPath:@"http://ip.jsontest.com/"];
    NSLog(@"Sending %@", request.description);
    
    [WebRequestProcessor process:request
                         success:^(NSObject *response) {
                             NSDictionary *result = [(WebResponse*)response parsedJsonObject];
                             NSLog(@"Result as dictionary: %@", result);
                         }
                         failure:nil
                          finish:nil];
}

- (void) simpleWithSerializingGetParams
{
    // "http://md5.jsontest.com/?text=example_text"
    NSString *getParams = [QuerySerializer serialize:@{@"text":@"example_text"}];
    WebRequest *request = [[WebRequest alloc] initWithPath:[@"http://md5.jsontest.com/?" stringByAppendingString:getParams]];
    NSLog(@"Sending %@", request.description);
    
    [WebRequestProcessor process:request
                         success:^(NSObject *response) {
                             NSDictionary *result = [(WebResponse*)response parsedJsonObject];
                             NSLog(@"Result of serializing get as dictionary: %@", result);
                         }
                         failure:nil
                          finish:nil];
}

- (void) simplePostJSON
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:@{@"text":@"example_text"} options:0 error:nil];
    WebRequest *request = [[WebRequest alloc] initWithPath:@"http://httpbin.org/post"
                                                  jsonData:data];
    
    NSLog(@"Sending %@", request.description);
    
    [WebRequestProcessor process:request
                         success:^(NSObject *response) {
                             NSDictionary *result = [(WebResponse*)response parsedJsonObject];
                             NSLog(@"Result of simple JSON post as dictionary: %@", result);
                         }
                         failure:nil
                          finish:nil];
    
    
}

- (void) simpleFail
{
    WebRequest *request = [[WebRequest alloc] initWithPath:@"http://error.error"];
    
    [WebRequestProcessor process:request
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
    NSLog(@"Catched the notification.");
}


@end
