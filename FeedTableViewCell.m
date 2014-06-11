//
//  FeedTableViewCell.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/9/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "FeedTableViewCell.h"

@implementation FeedTableViewCell

@synthesize imageViewPhoto;
@synthesize labelCaption;

- (void)awakeFromNib
{
    // Initialization code
}



-(void)layoutSubviews
{

    [super layoutSubviews];
//    self.imageViewPhoto.bounds = CGRectMake(0, 10, 50, 50);
//    self.imageViewPhoto.frame = CGRectMake(0, 10, 50, 50);
//    self.imageViewPhoto.contentMode = UIViewContentModeScaleAspectFill;
//
//    [self.superview addSubview:self.imageViewPhoto];
}


@end
