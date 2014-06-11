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

@interface ViewController ()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
@property NSArray *photos;
@property NSMutableArray *commentArray;

@end


@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.commentArray = [NSMutableArray array];

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

-(void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error
{
    NSLog(@"Fail to Login");
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    PFObject *photoObject = [self.photos objectAtIndex:indexPath.section];

    [self queryCommentsForPhoto:photoObject];

    PFFile *imageFile = [photoObject objectForKey:@"image"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.imageViewPhoto.image = [UIImage imageWithData:data];
        }
        [self.tableView reloadData];
    }];
    cell.labelCaption.text = [photoObject objectForKey:@"caption"];
//    cell.commentTextField.text = [NSString stringWithFormat:@"%@/n%@/n%@", [self.commentArray objectAtIndex:0], [self.commentArray objectAtIndex:1], [self.commentArray objectAtIndex:2]];
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

-(void)queryPhotos
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query includeKey:@"user"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            self.photos = [[NSArray alloc]initWithArray:objects];
        }
        [self.tableView reloadData];
        NSLog(@"%i", self.photos.count);
    }];
}

-(void)queryCommentsForPhoto: (PFObject *)photo
{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    [query whereKey:@"photo" equalTo:photo];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
//            self.commentArray = [[NSArray alloc]initWithArray:objects];
            for (PFObject *commentObject in objects)
            {
                NSString *comment = [commentObject objectForKey:@"commentText"];
                [self.commentArray addObject:comment];

            }
        }
        [self.tableView reloadData];
    }];
}


@end
