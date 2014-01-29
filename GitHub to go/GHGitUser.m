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
    if (!self.avatar)
    {
        [self.downloadQueue addOperationWithBlock:^void{
            NSData *imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageURL]];
            self.avatar = [UIImage imageWithData:imageData];
        }];
    }

    [[NSOperationQueue mainQueue] addOperationWithBlock:
     ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"DOWNLOAD_NOTIFICATION"
                                                            object:nil
                                                          userInfo:@{@"user": self}];
    }];
}

@end
