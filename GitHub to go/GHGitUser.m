//
//  GHGitUser.m
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/28/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "GHGitUser.h"

@implementation GHGitUser

-(void)setImageURL:(NSString *)imageURL
{
    _imageURL = imageURL;
    
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageURL]];
    _userImage = [UIImage imageWithData:imageData];
}

@end
