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
    self.imageView.frame = CGRectMake(200, 10, 100, 100);
}


@end
