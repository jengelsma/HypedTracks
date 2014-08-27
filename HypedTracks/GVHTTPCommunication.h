//
//  GVHTTPCommunication.h
//  HypedTracks
//
//  Created by Jonathan Engelsma on 8/26/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVHTTPCommunication : NSObject <NSURLSessionDataDelegate>
-(void) retrieveURL:(NSURL *)url successBlock:(void (^) (NSData*))successBlk;
@end
