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
    
Send multipart form data that contains file for upload:

    WebRequest *request = [[WebRequest alloc] initWithPath:@"...documents/create.json"];
    request.delegate = delegate;
    request.notificationName = @"NotificationDocumentUploaded";
    
    NSMutableData *body = [NSMutableData data];
    NSString *boundary = @"TeslaSchoolProjectFormBoundary";
    
    [body appendPartName:@"document[name]" value:@"Test" boundary:boundary];
    [body appendPartName:@"document[description]" value:@"This is a description" boundary:boundary];
    [body appendPartName:@"document[category]" value:@"Drama" boundary:boundary];
    ...
    [body appendPartName:@"commit" value:@"Save" boundary:boundary];
    NSData *fileData = [[NSData alloc] initWithContentsOfURL:someFileURL];
    [body appendPartFile:fileName name:@"document[file]" data:fileData mimeType:mimeType boundary:boundary];
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
    
    NSString *bodyLength = [NSString stringWithFormat:@"%lu",(unsigned long)[body length]];
    [request addValue:bodyLength forHTTPHeaderField:@"Content-Length"];
    [request addValue:@"gzip,deflate,sdch" forHTTPHeaderField:@"Accept-Encoding"];
    [request addValue:@"max-age=0" forHTTPHeaderField:@"Cache-Control"];
    [request addValue:@"text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8" forHTTPHeaderField:@"Accept"];
    [request addValue:@"en-US,en;q=0.8,hr;q=0.6,it;q=0.4,sk;q=0.2,sl;q=0.2,sr;q=0.2" forHTTPHeaderField:@"Accept-Language"];
    
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; charset=utf-8; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:@"POST"];
    [WebRequestProcessor process:request];
