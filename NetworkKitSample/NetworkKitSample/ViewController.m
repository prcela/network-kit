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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self simple];
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


@end
