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

@end

@implementation ViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        self.parseClassName = @"Photo";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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

-(void)unwindSegue: (UIStoryboardSegue *)segue
{
    [self refreshControl];
}

@end
