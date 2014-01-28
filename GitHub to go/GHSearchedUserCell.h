//
//  GHSearchedUserCell.h
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/28/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GHGitUser.h"

@interface GHSearchedUserCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) GHGitUser *user;

-(void)initializeDisplay;

@end
