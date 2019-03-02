//
//  ServerRequest.m
//  DropBeats
//
//  Created by Omar Abdelwahed on 5/12/18.
//  Copyright © 2018 Omar Abdelwahed. All rights reserved.
//

#import "ServerRequest.h"
#import "ViewController.h"

#define BASEURL @"jsonplaceholder.typicode.com"
#define SERVERSENDPOINT @"/todos/1"

@interface ServerRequest () <NSURLSessionTaskDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionStreamDelegate, NSStreamDelegate> {
    
    NSURLSession *session;
    
}
@end

@implementation ServerRequest

static ServerRequest *serverRequest = nil;

+ (ServerRequest *) sharedServer {
    @synchronized(self)     {
        if (!serverRequest) {
            serverRequest = [[ServerRequest alloc] init];
        }
    }
    return serverRequest;
}

+ (id) alloc {
    @synchronized(self)     {
        NSAssert(serverRequest == nil, @"Attempted to allocate a second instance of a singleton, ServerRequest.");
        return [super alloc];
    }
    return nil;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        session = [NSURLSession sharedSession];
    }
    return self;
}

- (void)dealloc
{
    [session invalidateAndCancel];
}

- (void)getPerson:(void (^)(PersonModel *person))handler {
    
    NSString *url = [NSString stringWithFormat:@"https://%@%@", BASEURL, SERVERSENDPOINT];
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    //create the Method "GET"
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                      {
                                          
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          if(httpResponse.statusCode == 200)
                                          {
                                              NSError *parseError = nil;
                                              NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              NSLog(@"The server response is - %@", responseDict);
                                              
                                              // instantiate return object
                                              PersonModel *person = [[PersonModel alloc] init];
                                              
                                              if (responseDict && [responseDict count] > 0) {
                                                  person.userID = [responseDict objectForKey:@"userId"];
                                                  person.title = [responseDict objectForKey:@"title"];
                                              }
                                              
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  handler(person);
                                              });
                                              
                                          }
                                          else
                                          {
                                              NSLog(@"HTTP Error %ld: %@", (long)httpResponse.statusCode, httpResponse.description);
                                              dispatch_async(dispatch_get_main_queue(), ^{
                                                  handler(nil);
                                              });
                                          }
                                          
                                      }];
    [dataTask resume];
    
}

#pragma mark Date Utilities

- (NSDate*)jsonDateToNSDate:(NSString*)jsonDate {
    NSDate *d = nil;
    if (jsonDate != nil) {
        
        // remove trailing timezone
        jsonDate = [jsonDate stringByReplacingOccurrencesOfString:@" Etc/GMT" withString:@""];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]]; // server time is GMT!
        d = [formatter dateFromString:jsonDate];
        
    }
    return d;
}

- (NSString*)NSDateToString:(NSDate*)date {
    NSString *dateString = nil;
    if (date != nil) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setLocale:enUSPOSIXLocale];
        [formatter setDateFormat:@"yyyy'-'MM'-'dd' 'HH':'mm':'ss"];
        [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        dateString = [formatter stringFromDate:date];
    }
    return dateString;
}

@end
