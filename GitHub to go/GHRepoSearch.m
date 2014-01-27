//
//  GH.m
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/27/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "GHRepoSearch.h"

@implementation GHRepoSearch


+(GHRepoSearch *)sharedController
{
    static dispatch_once_t pred;
    static GHRepoSearch *shared = nil;
    
    dispatch_once(&pred, ^{
        shared = [[GHRepoSearch alloc] init];
    });
    return shared;
}

- (NSArray *)reposForSearchString: (NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/repositories?q=%@+&sort=stars&order=desc", searchString];
    NSURL *searchURL = [NSURL URLWithString:searchString];
//    You'll need to factor this into a background queue at some point
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData options:NSJSONReadingMutableContainers error: nil]; //his error said &error, but that gave me an error
    return searchDictionary[@"items"];
}

@end