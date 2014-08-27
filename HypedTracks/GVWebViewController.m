//
//  GVWebViewController.m
//  HypedTracks
//
//  Created by Jonathan Engelsma on 8/26/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import "GVWebViewController.h"

@interface GVWebViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end


@implementation GVWebViewController


#pragma mark - Managing the detail item

- (void)setWebURL:(NSString *)newWebUrl
{
    if (_webURL != newWebUrl) {
        _webURL = newWebUrl;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

- (void)configureView
{
    NSURL* url = [NSURL URLWithString:self.webURL];
    NSMutableURLRequest *request =[NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    request.HTTPMethod = @"GET";
    
    // automatically replace the webview everytime a new web url is set on iPad.
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        
        // allocate a new webview
        UIWebView* newView = [[UIWebView alloc] init];
        newView.frame = self.webView.frame;
        
        // remove the old view from the superview, and add the new one.
        [self.webView removeFromSuperview];
        [self.view addSubview:newView];
        self.webView = newView;
    }
    
    self.webView.delegate = self;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.webView loadRequest:request];
}

#pragma mark - Lifecylce overrides

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
        NSArray *toolbarItems = [NSArray arrayWithObjects:backItem, nil];
        [self setToolbarItems:toolbarItems];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WebViewDelegate

/* 
 * This nifty backbutton technique shamelessly stolen from here:
http://stackoverflow.com/questions/6991623/how-to-convert-navigationcontrollers-back-button-into-browsers-back-button-in
 */
- (void) updateBackButton
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        if([self.webView canGoBack]) {
            [self.navigationController setToolbarHidden:NO];
        } else {
            [self.navigationController setToolbarHidden:YES];
        }
    }
    else {
        if([self.webView canGoBack]) {
            if(!self.navigationItem.leftBarButtonItem) {
                [self.navigationItem setHidesBackButton:YES animated:YES];
                UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(backPressed)];
                [self.navigationItem setLeftBarButtonItem:backItem animated:YES];
            }
        } else {
            [self.navigationItem setLeftBarButtonItem:nil animated:YES];
            [self.navigationItem setHidesBackButton:NO animated:YES];
        }
    }
}

-(void) backPressed
{
    if([self.webView canGoBack]) {
        [self.webView goBack];
    }
}

- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [self updateBackButton];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    [self updateBackButton];
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Tracks", @"Tracks");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}



@end
