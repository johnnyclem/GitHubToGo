//
//  GHSearchedUserCell.m
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/28/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "GHSearchedUserCell.h"

@implementation GHSearchedUserCell

-(void)initializeDisplay
{
    self.userName.text = self.user.name;
    
    if (self.user.avatar)
    {
        self.avatarView.image = self.user.avatar;
    }
    else
    {
        if (!self.user.isDownloading)
        {
            [self.user initializeImage];
            self.backgroundColor = [UIColor purpleColor];
        }
    }
}

@end