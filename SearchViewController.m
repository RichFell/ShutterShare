//
//  SearchViewController.m
//  ShutterShare
//
//  Created by David Warner on 6/11/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomSearchCellTableViewCell.h"
#import "OPPViewController.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *searchResultsArray;
@property NSArray *skimmmedResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UIButton *searchButtonOutlet;

@end

@implementation SearchViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResultsArray = [NSMutableArray new];
}

- (IBAction)onSearchButtonPressed:(id)sender
{
    [self.searchResultsArray removeAllObjects];

    NSString *search = self.searchBar.text;

    [self queryParse:search];

    [self.searchBar endEditing:YES];
    self.searchButtonOutlet.enabled = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResultsArray.count;
}

-(CustomSearchCellTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *object = [self.searchResultsArray objectAtIndex:indexPath.row];
    CustomSearchCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    cell.nameLabel.text = [object objectForKey:@"name"];
    cell.usernameLabel.text = [object objectForKey:@"username"];

    PFFile *pffile = [object objectForKey:@"profilePicSmall"];
    [pffile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
        cell.imageView.clipsToBounds = YES;
    }];

    return cell;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *selectedIndexPath = self.tableView.indexPathForSelectedRow;
    NSInteger integer = selectedIndexPath.row;
    PFObject *object = [self.searchResultsArray objectAtIndex:integer];
    OPPViewController *nextVC = segue.destinationViewController;
    nextVC.objectFromSearch = object;
}

-(void)queryParse:(NSString *)string
{
    PFQuery *query1 = [PFUser query];
    [query1 whereKey:@"username" containsString:string];
    PFQuery *query2 = [PFUser query];
    [query2 whereKey:@"name" containsString:string];
    PFQuery *query3 = [PFQuery orQueryWithSubqueries:@[query1,query2]];

    NSLog(@"Working");
    [query3 findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                [self.searchResultsArray addObjectsFromArray:results];
        NSLog(@"Got the data");
                [self.tableView reloadData];
            self.searchButtonOutlet.enabled = YES;
    }];
}

@end
