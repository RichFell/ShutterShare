//
//  User.h
//  ShutterShare
//
//  Created by David Warner on 6/10/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import <Parse/Parse.h>

@interface User : PFObject <PFSubclassing>

+(id)parseClassName;
@property PFFile *profilePic;

@end
