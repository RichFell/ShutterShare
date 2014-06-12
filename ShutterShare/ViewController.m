//
//  ViewController.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/9/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ViewController.h"
#import "Photo.h"
#import "CameraViewController.h"
#import "FeedTableViewCell.h"
#import "CommentViewController.h"

@interface ViewController ()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property NSArray *photos;
@property NSMutableArray *commentArray;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryPhotos];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![PFUser currentUser]) {
        PFLogInViewController *loginViewController = [PFLogInViewController new];
        PFSignUpViewController *signUpViewController = [PFSignUpViewController new];
        loginViewController.delegate = self;
        signUpViewController.delegate = self;

        loginViewController.signUpController = signUpViewController;
        [self presentViewController:loginViewController animated:YES completion:nil];
    }
}

#pragma mark -Login methods

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Fail to Login");
}

#pragma mark -TableView Delegate Methods

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    PFObject *photoObject = [self.photos objectAtIndex:indexPath.section];
    PFFile *imageFile = [photoObject objectForKey:@"image"];

    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error)
        {
            cell.imageViewPhoto.image = [UIImage imageWithData:data];
        }
    }];

    cell.labelCaption.text = [photoObject objectForKey:@"caption"];

    NSLog(@"%@", self.commentArray);

    if (self.commentArray.count != 0)
    {
        cell.commentTextField.text = [NSString stringWithFormat:@"%@",[[self.commentArray objectAtIndex:0]objectForKey:@"commentText"]];
        [self.commentArray removeAllObjects];
    }
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.photos.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    PFObject *photo = [self.photos objectAtIndex:section];
    PFUser *user = [photo objectForKey:@"user"];
    return  [user objectForKey:@"username"];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    UILabel *sectionTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 320, 30)];
    PFObject *photo = [self.photos objectAtIndex:section];
    PFUser *user = [photo objectForKey:@"user"];
    sectionTitle.text = [NSString stringWithFormat:@"     %@",[user objectForKey:@"username"]];
    sectionTitle.shadowColor = [UIColor colorWithWhite:0 alpha:0.4];
    sectionTitle.shadowOffset = CGSizeMake(1, 1);
    sectionTitle.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.8];

    UIImageView *headerImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    if ([[PFUser currentUser] objectForKey:@"profilePic"]) {
        PFFile *pffile = [user objectForKey:@"profilePic"];
        [pffile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            headerImage.image = [UIImage imageWithData:data];
            headerImage.layer.cornerRadius = headerImage.frame.size.width /2;
            headerImage.clipsToBounds = YES;
        }];
    }
    else
    {
        headerImage.image = [UIImage imageNamed:@"bear"];
        headerImage.layer.cornerRadius = headerImage.frame.size.width /2;
        headerImage.clipsToBounds = YES;
    }
    [headerView addSubview:sectionTitle];
    [headerView addSubview:headerImage];
    return headerView;
}

#pragma mark -Query Helper Methods

-(void)queryPhotos
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            self.photos = [[NSArray alloc]initWithArray:objects];
            for (Photo *photo in self.photos)
            {
                [self queryCommentsForPhoto:photo];
            }
            [self.tableView reloadData];
        }
    }];
    [self.commentArray removeAllObjects];
}

-(void)queryCommentsForPhoto: (PFObject *)photo
{
    PFRelation *relation = [photo relationForKey:@"comments"];
    PFQuery *query = [relation query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.commentArray = [[NSMutableArray alloc]initWithArray:objects];
    }];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    CommentViewController *commentVC = segue.destinationViewController;
    UIButton *btn = (UIButton*) sender;
    UITableViewCell *cell = (UITableViewCell*) [btn superview];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    Photo *photo = [self.photos objectAtIndex:indexPath.section];

    commentVC.photo = photo;
}

@end
