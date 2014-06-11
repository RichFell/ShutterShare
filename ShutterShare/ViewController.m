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

@interface ViewController ()<PFSignUpViewControllerDelegate, PFLogInViewControllerDelegate>
@property NSArray *photos;
@end

@implementation ViewController

//-(id)initWithCoder:(NSCoder *)aDecoder
//{
//    if (self = [super initWithCoder:aDecoder])
//    {
//        self.parseClassName = @"Photo";
//    }
//    return self;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.photos = [NSMutableArray array];
    [self queryPhotos];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    if (![PFUser currentUser]) {
//        PFLogInViewController *loginViewController = [PFLogInViewController new];
//        PFSignUpViewController *signUpViewController = [PFSignUpViewController new];
//        loginViewController.delegate = self;
//        signUpViewController.delegate = self;
//
//        loginViewController.signUpController = signUpViewController;
//        [self presentViewController:loginViewController animated:YES completion:nil];
//    }
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.photos.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    Photo *photoObject = [self.photos objectAtIndex:indexPath.row];
    NSString *imageString = [NSString stringWithFormat:@"%@", photoObject.image];
    cell.imageViewPhoto.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:imageString]];
    cell.labelCaption.text = photoObject.caption;
    return cell;
}

-(void)unwindSegue: (UIStoryboardSegue *)segue
{
    [self refreshControl];
}

-(void)queryPhotos
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        self.photos = [[NSArray alloc]initWithArray:objects];

        NSLog(@"%@", self.photos);
    }];
}


@end
