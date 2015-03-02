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

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    WebRequest *r = [[WebRequest alloc] initWithMethod:@"pero"
                                                  path:@"zdero"
                                                params:nil];
    NSLog(@"%@", r.description);
    
    [WebRequestProcessor process:r
                         success:nil
                         failure:nil
                          finish:nil];
}


@end
