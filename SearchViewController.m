//
//  SearchViewController.m
//  ShutterShare
//
//  Created by David Warner on 6/11/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *searchResultsArray;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation SearchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResultsArray = [NSMutableArray new];
}

- (IBAction)onSearchButtonPressed:(id)sender
{
    NSString *searchString = self.searchBar.text;

    PFQuery *query = [PFUser query];
    [query whereKey:@"username" equalTo:searchString];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        [self.searchResultsArray addObjectsFromArray:objects];
        [self.tableView reloadData];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self.searchResultsArray objectAtIndex:indexPath.row];

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [object objectForKey:@"name"];
    cell.detailTextLabel.text = [object objectForKey:@"username"];

    return cell;
}



@end
