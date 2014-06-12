//
//  OPPViewController.m
//  ShutterShare
//
//  Created by David Warner on 6/12/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "OPPViewController.h"
#import "CustomCollectionViewCell.h"

@interface OPPViewController ()
@property (weak, nonatomic) IBOutlet UILabel *userInformationLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong) NSMutableArray *imagesArray;
@property NSArray *imagefilesArray;
@property (weak, nonatomic) IBOutlet UIButton *followButtonOutlet;

@end

@implementation OPPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.followButtonOutlet.layer.cornerRadius = 5.0f;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self queryParseForImages];

    self.navigationItem.title = [self.objectFromSearch objectForKey:@"username"];
    self.nameLabel.text = [self.objectFromSearch objectForKey:@"name"];

    if ([self.objectFromSearch objectForKey:@"profilePic"]) {
        PFFile *pffile = [self.objectFromSearch objectForKey:@"profilePic"];
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
    [query whereKey:@"user" equalTo:self.objectFromSearch];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.imagefilesArray = [[NSArray alloc] initWithArray:objects];
            self.userInformationLabel.text = [NSString stringWithFormat:@"%lu, 1, 1,", (unsigned long)self.imagefilesArray.count];
        }
        [self.collectionView reloadData];
    }];
}



@end
