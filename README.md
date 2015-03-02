# network-kit
NetworkKit

#About
NetworkKit can be used for easy asynchrounus processing of web requests and responses.
It supports json sending in body, downloading large files, multipart forms, query serialization from NSDictionary and more.

# Installation
Just drag the NetworkKit folder into your iOS project.

# Usage

Process the web request which returns the JSON object:

    WebRequest *request = [[WebRequest alloc] initWithPath:@"http://ip.jsontest.com/"];
    NSLog(@"Sending %@", request.description);
    
    [WebRequestProcessor process:request
                         success:^(NSObject *response) {
                             NSDictionary *result = [(WebResponse*)response parsedJsonObject];
                             NSLog(@"Result as dictionary: %@", result);
                         }
                         failure:nil
                          finish:nil];

Note that the success block is invoked in separate thread.

Request with serialization of get params:

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

Post JSON object:

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

Download file with procesing it in desire queue, save it to local path and post desired notification on finish:

    DownloadWebRequest *webRequest = [[DownloadWebRequest alloc] initWithURL:url];
    webRequest.delegate = delegate;
    webRequest.downloadFilePath = [some local path];
    webRequest.notificationObject = [identificator string];
    webRequest.notificationName = @"NotificationDownloadDocument";
    webRequest.queue = [your operation queue];
    
    [WebRequestProcessor process:webRequest];
