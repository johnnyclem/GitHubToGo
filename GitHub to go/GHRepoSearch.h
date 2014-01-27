//
//  GH.h
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/27/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GHRepoSearch : NSObject
- (NSArray *)reposForSearchString: (NSString *)searchString;
+(GHRepoSearch *)sharedController;

@end
