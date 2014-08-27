//
//  GVMasterViewController.m
//  HypedTracks
//
//  Created by Jonathan Engelsma on 8/26/14.
//  Copyright (c) 2014 Jonathan Engelsma. All rights reserved.
//

#import "GVMasterViewController.h"
#import "GVHTTPCommunication.h"
#import "GVWebViewController.h"
#import "GVTrackTableViewCell.h"
#import "UIImageView+Network.h"

@interface GVMasterViewController () {
    NSMutableArray *_objects;
    GVHTTPCommunication *http;
}
@end

@implementation GVMasterViewController

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.preferredContentSize = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    http = [[GVHTTPCommunication alloc] init];
    NSURL *url = [NSURL URLWithString:@"http://ws.audioscrobbler.com/2.0/?method=chart.gethypedtracks&api_key=316f518790c69642113e3628d020b9fc&format=json"];
    [http retrieveURL:url successBlock:^(NSData *response) {
        NSError *error = nil;
        NSDictionary *data = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
        if(!error) {
            NSDictionary *topTracks = data[@"tracks"];
            _objects = topTracks[@"track"];
            [self.tableView reloadData];
        }
    }];

    self.detailViewController = (GVWebViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _objects.count;
}

/*
 * return the height of the custom prototype (get's overridden by the tableview on dynamic rows)
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 58.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GVTrackTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomCell" forIndexPath:indexPath];

    NSDictionary *track = _objects[indexPath.row];
    cell.trackName.text = track[@"name"];
    NSDictionary *artist = track[@"artist"];
    cell.artistName.text = artist[@"name"];
    
    NSArray *images = track[@"image"];
    NSDictionary *firstImage = images[0];
    NSString *imageURL = firstImage[@"#text"];
    if(imageURL != nil) {
        [cell.thumbnail loadImageFromURL:[NSURL URLWithString:imageURL] placeholderImage:[UIImage imageNamed:@"Last_fm_logo"] cachingKey:imageURL];
    } else {
        cell.thumbnail.image = [UIImage imageNamed:@"Last_fm_logo"];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        NSDictionary *track = _objects[indexPath.row];
        NSString* url = track[@"url"];
        url = [url stringByReplacingOccurrencesOfString:@"www.last.fm" withString:@"m.last.fm"];
        
        self.detailViewController.webURL = url;
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *track = _objects[indexPath.row];
        NSString* url = track[@"url"];
        url = [url stringByReplacingOccurrencesOfString:@"www.last.fm" withString:@"m.last.fm"];
        [[segue destinationViewController] setWebURL:url];
    }
}


@end
