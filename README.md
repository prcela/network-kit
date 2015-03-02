# network-kit
NetworkKit

#About
NetworkKit can be used for easy asynchrounus processing of web requests and responses.

# Installation
Just drag the NetworkKit folder into your iOS project.

# Usage
Process the web request which returns the json object:

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
