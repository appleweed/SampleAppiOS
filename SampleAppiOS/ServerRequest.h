//
//  ServerRequest.h
//  DropBeats
//
//  Created by Omar Abdelwahed on 5/12/18.
//  Copyright © 2018 Omar Abdelwahed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonModel.h"

@interface ServerRequest : NSObject<NSURLSessionTaskDelegate, NSURLSessionDelegate, NSURLSessionDataDelegate, NSURLSessionStreamDelegate, NSStreamDelegate>
+(ServerRequest *)sharedServer;
-(void)getPerson:(void (^)(PersonModel *person))handler;
@end
