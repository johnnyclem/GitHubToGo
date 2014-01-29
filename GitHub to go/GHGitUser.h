//
//  GHGitUser.h
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/28/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHGitUser : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *avatar;
@property (weak, atomic) NSOperationQueue *downloadQueue;
@property (nonatomic) BOOL isDownloading;

-(void)initializeImage;

@end
