//
//  GVAppDelegate.h
//  HypedTracks
//
//  Created by Jonathan Engelsma on 8/26/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVAppDelegate : UIResponder <UIApplicationDelegate>
@property (nonatomic,readonly) int networkActivityCounter;
-(void) incrementNetworkActivity;
-(void) decrementNetworkActivity;
-(void) resetNetworkActivity;
@property (strong, nonatomic) UIWindow *window;

@end
