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
@property NSMutableSet* sectionHeaders;
@property NSMutableDictionary *outstandingSectionHeaderQueries;
@property BOOL shouldReloadOnAppear;

@end


@implementation ViewController

@synthesize sectionHeaders;
@synthesize outstandingSectionHeaderQueries;
@synthesize shouldReloadOnAppear;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.parseClassName = @"Users";
    }
    return self;
}

- (void)viewDidLoad
{
    self.parseClassName = @"Photo";
    [super viewDidLoad];

    self.paginationEnabled = YES;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self)
    {
        self.outstandingSectionHeaderQueries = [NSMutableDictionary dictionary];

        self.sectionHeaders = [NSMutableSet setWithCapacity:3];
    }
    return self;
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

-(FeedTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(Photo *)photo
{
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];

    if (cell == nil)
    {
        cell = [[FeedTableViewCell alloc]init];
    }
    cell.imageViewPhoto.file = photo.image;
    cell.labelCaption.text = photo.caption;
    [cell.imageViewPhoto loadInBackground];
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    Photo *photo = [Photo objectWithClassName:@"Photo"];
    return photo.user;
}

-(void)unwindSegue: (UIStoryboardSegue *)segue
{
    [self refreshControl];
}

@end
