//
//  SearchViewController.m
//  ShutterShare
//
//  Created by David Warner on 6/11/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController


- (PFQuery *)queryForTable {
    return [PFUser query];
}

- (IBAction)onSearchButtonPressed:(id)sender
{
    NSString *searchString = self.searchBar.text;
    NSMutableArray *searchResultsArray = [[NSMutableArray alloc] init];

    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {

    }];



}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFUser *)user
{
    PFTableViewCell *cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"ABC"];
    cell.textLabel.text = [user objectForKey:@"name"];
    cell.detailTextLabel.text = [user objectForKey:@"username"];

    cell.imageView.file = [user objectForKey:@"profilePic"];
    [cell.imageView loadInBackground];

    return cell;
}

@end
