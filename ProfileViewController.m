//
//  ProfileViewController.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/9/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userActivityInfoLabel;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = [PFUser currentUser].username;
//    self.userActivityInfoLabel.text = [NSString stringWithFormat:@"%@, %@, %@", posts, followers, following];
}

@end
