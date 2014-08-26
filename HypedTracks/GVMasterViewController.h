//
//  GVMasterViewController.h
//  HypedTracks
//
//  Created by Jonathan Engelsma on 8/26/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GVDetailViewController;

@interface GVMasterViewController : UITableViewController

@property (strong, nonatomic) GVDetailViewController *detailViewController;

@end
