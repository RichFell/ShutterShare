//
//  CustomSearchCellTableViewCell.h
//  ShutterShare
//
//  Created by David Warner on 6/11/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface CustomSearchCellTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;


@end
