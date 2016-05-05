
#import "PxHTTPConnection.h"
#import "HTTPDataResponse.h"
#import "HTTPLogging.h"

// This should be parse from the master playlist and not hardcoded.
static const NSString *actualHost = @"http://vevoplaylist-live.hls.adaptive.level3.net";

@implementation PxHTTPConnection

- (NSObject<HTTPResponse> *)httpResponseForMethod:(NSString *)method URI:(NSString *)path
{
    //NSLog(@"Path: %@", path);
    NSData  *data = [self downloadFile:path];
    
    if ([path hasSuffix:@".m3u8"]){
        // Parse the manifest and pull out any information we want/don't want before sending it
        // back to the player.
        NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@", newStr);
    }
    return [[HTTPDataResponse alloc] initWithData:data];
}

+ (NSData *)sendSynchronousRequest:(NSURLRequest *)request
                 returningResponse:(__autoreleasing NSURLResponse **)responsePtr
                             error:(__autoreleasing NSError **)errorPtr {

    dispatch_semaphore_t    sem;
    __block NSData *        result;

    result = nil;

    sem = dispatch_semaphore_create(0);

    [[[NSURLSession sharedSession] dataTaskWithRequest:request
                                     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                         if (errorPtr != NULL) {
                                             *errorPtr = error;
                                         }
                                         if (responsePtr != NULL) {
                                             *responsePtr = response;
                                         }  
                                         if (error == nil) {  
                                             result = data;  
                                         }  
                                         dispatch_semaphore_signal(sem);  
                                     }] resume];  
    
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    return result;  
}

- (NSData *)downloadFile:(NSString *)path
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", actualHost, path];

    //NSLog(@"Fetching: %@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *remoteRequest =
    [NSMutableURLRequest requestWithURL:url
                            cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                        timeoutInterval:10];
    
    [remoteRequest setHTTPMethod: @"GET"];
    
    NSError *requestError = nil;
    NSURLResponse *urlResponse = nil;

    // TODO: Check for errors
    return [[self class] sendSynchronousRequest:remoteRequest returningResponse:&urlResponse error:&requestError];
}

@end