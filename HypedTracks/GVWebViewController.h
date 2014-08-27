//
//  GVWebViewController.h
//  HypedTracks
//
//  Created by Jonathan Engelsma on 8/26/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GVWebViewController : UIViewController <UISplitViewControllerDelegate, UIWebViewDelegate>
@property (strong, nonatomic) NSString *webURL;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end
