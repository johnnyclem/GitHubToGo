//
//  GHGitUser.m
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/28/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "GHGitUser.h"

@implementation GHGitUser

-(void)initializeImage
{
    self.isDownloading = TRUE;
    [self.downloadQueue addOperationWithBlock:^void{
    NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
    self.avatar = [UIImage imageWithData:imageData];
    }];
}

@end
