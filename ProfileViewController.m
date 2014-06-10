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
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.title = [[PFUser currentUser] objectForKey:@"username"];
    self.nameLabel.text = [[PFUser currentUser] objectForKey:@"name"];
    //    self.userActivityInfoLabel.text = [NSString stringWithFormat:@"%@, %@, %@", posts, followers, following];

    PFFile *pffile = [[PFUser currentUser] objectForKey:@"profilePic"];
    [pffile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        self.imageView.image = [UIImage imageWithData:data];
    }];
}

@end
