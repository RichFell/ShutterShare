//
//  SearchViewController.m
//  ShutterShare
//
//  Created by David Warner on 6/11/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "SearchViewController.h"
#import "CustomSearchCellTableViewCell.h"

@interface SearchViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *searchResultsArray;
@property NSArray *skimmmedResults;
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
    [self.searchResultsArray removeAllObjects];

    NSString *search = self.searchBar.text;
    NSString *searchlower = [self.searchBar.text lowercaseString];
    NSString *searchupper = [self.searchBar.text uppercaseString];
    NSString *searchcapfirst = [self.searchBar.text capitalizedString];

    [self queryParse:search];
    [self queryParse:searchlower];
    [self queryParse:searchupper];
    [self queryParse:searchcapfirst];
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

    PFFile *pffile = [object objectForKey:@"profilePic"];
    [pffile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        cell.imageView.image = [UIImage imageWithData:data];
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
        cell.imageView.clipsToBounds = YES;
    }];

    return cell;
}

-(void)queryParse:(NSString *)string
{
    PFQuery *query1 = [PFUser query];
    [query1 whereKey:@"username" containsString:string];
    PFQuery *query2 = [PFUser query];
    [query2 whereKey:@"name" containsString:string];
    PFQuery *query3 = [PFQuery orQueryWithSubqueries:@[query1,query2]];

    [query3 findObjectsInBackgroundWithBlock:^(NSArray *results, NSError *error) {
                [self.searchResultsArray addObjectsFromArray:results];
                [self.tableView reloadData];
    }];
}



@end
