//
//  VideoTableViewController.m
//  TWCChallenge
//
//  Created by Rayen Kamta on 9/2/15.
//  Copyright (c) 2015 Geeksdobyte. All rights reserved.
//

#import "VideoTableViewController.h"
#import "VideoCell.h"
#import "AFNetworking.h"

#define APIURL @"https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&maxResults=50&playlistId=PLWz5rJ2EKKc_XOgcRukSoKKjewFJZrKV0&key=AIzaSyBkKJRvNKAJ4cgdVY604OfkzhqHh7bvyi0"

NSDictionary *apiDict;
NSMutableArray *itemsCount;
NSMutableArray *videoTitles;
NSMutableArray *videoDes;
NSMutableArray *videoThumbs;


@implementation VideoTableViewController

- (BOOL) prefersStatusBarHidden
{
    return YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self downloadJSON];
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return itemsCount.count;
}



-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    VideoCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    myCell.titleLabel.text = [videoTitles objectAtIndex:indexPath.row];
    myCell.descriptionLabel.text =[videoDes objectAtIndex:indexPath.row];

    
    
    
    
    
    NSURL *imageURL = [NSURL URLWithString:[videoThumbs objectAtIndex:indexPath.row]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            myCell.thumbnailImg.image = [UIImage imageWithData:imageData];
            
            
        });
        
        
    });
    
    return myCell;
}


-(void) downloadJSON{
    
    NSURL *url = [NSURL URLWithString:APIURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        apiDict = (NSDictionary*)responseObject;
        itemsCount =[apiDict objectForKey:@"items"];
        videoTitles = [[[apiDict objectForKey:@"items"]valueForKey:@"snippet"]valueForKey:@"title"];
        videoDes =[[[apiDict objectForKey:@"items"]valueForKey:@"snippet"]valueForKey:@"description"];
        videoThumbs = [[[[[apiDict objectForKey:@"items"]valueForKey:@"snippet"]valueForKey:@"thumbnails"]valueForKey:@"default"]valueForKey:@"url"];
        NSLog(@"%@",videoTitles);
        [self.tableView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
       
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Data "
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
    
    [operation start];
}
    


@end
