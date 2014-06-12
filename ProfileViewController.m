//
//  ProfileViewController.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/9/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import "Photo.h"
#import "CustomCollectionViewCell.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *userActivityInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (strong) NSMutableArray *imagesArray;
@property NSArray *imagefilesArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIButton *editProfileButtonOutlet;

@end

@implementation ProfileViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.editProfileButtonOutlet.layer.cornerRadius = 5.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryParseForImages];

    self.navigationItem.title = [PFUser currentUser].username;
    self.navigationItem.title = [[PFUser currentUser] objectForKey:@"username"];
    self.nameLabel.text = [[PFUser currentUser] objectForKey:@"name"];

    if ([[PFUser currentUser] objectForKey:@"profilePic"]) {
        PFFile *pffile = [[PFUser currentUser] objectForKey:@"profilePic"];
        [pffile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.imageView.image = [UIImage imageWithData:data];
            self.imageView.layer.cornerRadius = self.imageView.frame.size.width /2;
            self.imageView.clipsToBounds = YES;
        }];
    }
    else
    {
        self.imageView.image = [UIImage imageNamed:@"bear"];
        self.imageView.layer.cornerRadius = self.imageView.frame.size.width /2;
        self.imageView.clipsToBounds = YES;
    }
}

# pragma mark - CollectionView Methods

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.imagefilesArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectioncell" forIndexPath:indexPath];

    PFObject *imageObject = [self.imagefilesArray objectAtIndex:indexPath.row];
    PFFile *imageFile = [imageObject objectForKey:@"thumbnail"];
    [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            cell.imageView.image = [UIImage imageWithData:data];
            [self.collectionView reloadData];
        }
    }];

    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0;
}

# pragma mark - Helper methods

-(void)queryParseForImages
{
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.imagefilesArray = [[NSArray alloc] initWithArray:objects];
            self.userActivityInfoLabel.text = [NSString stringWithFormat:@"%lu, 1, %@,", (unsigned long)self.imagefilesArray.count, [[PFUser currentUser] objectForKey:@"totalFollows"]];
        }
        [self.collectionView reloadData];
    }];
}


@end
