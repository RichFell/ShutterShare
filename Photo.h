//
//  Photo.h
//  ShutterShare
//
//  Created by Richard Fellure on 6/10/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import <Parse/Parse.h>

@interface Photo : PFObject <PFSubclassing>

+(id)parseClassName;
@property PFFile *image;
@property NSString *caption;
@property NSString *user;

@end
