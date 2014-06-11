//
//  SearchViewController.m
//  ShutterShare
//
//  Created by David Warner on 6/11/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "SearchViewController.h"
#import "User.h"

@interface SearchViewController ()

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController


- (PFQuery *)queryForTable {
    return [PFUser query];
}

- (IBAction)onSearchButtonPressed:(id)sender
{

}

-(PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(User *)user
{
    PFTableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath object:user];
    cell.textLabel.text = [user objectForKey:@"name"];
    cell.detailTextLabel.text = [user objectForKey:@"username"];

    return cell;
}

@end
