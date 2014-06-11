//
//  FeedTableViewCell.h
//  ShutterShare
//
//  Created by Richard Fellure on 6/9/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface FeedTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageViewPhoto;
@property (weak, nonatomic) IBOutlet UILabel *labelCaption;

@end
