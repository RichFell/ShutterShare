//
//  Photo.m
//  ShutterShare
//
//  Created by Richard Fellure on 6/10/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@dynamic image;
@dynamic caption;
@dynamic user;

+(id)parseClassName
{
    return @"Photo";
}

@end
