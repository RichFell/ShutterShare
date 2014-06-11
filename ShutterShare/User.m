//
//  User.m
//  ShutterShare
//
//  Created by David Warner on 6/10/14.
//  Copyright (c) 2014 Rich. All rights reserved.
//

#import "User.h"

@implementation User
@dynamic profilePic;
@dynamic name;
@dynamic username;
@dynamic email;

+(id)parseClassName
{
    return @"User";
}

@end
