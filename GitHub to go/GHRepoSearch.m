//
//  GH.m
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/27/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "GHRepoSearch.h"
#import "GHGitUser.h"

@interface GHRepoSearch()

@end

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

-(NSArray *) searchForUser:(NSString *)searchString
{
    searchString = [NSString stringWithFormat:@"https://api.github.com/search/users?q=%@", searchString];
    searchString = [searchString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSError *error;
    NSURL *searchURL = [NSURL URLWithString:searchString];
    NSData *searchData = [NSData dataWithContentsOfURL:searchURL];
    NSDictionary *searchDictionary = [NSJSONSerialization JSONObjectWithData:searchData
                                                                     options:NSJSONReadingMutableContainers
                                                                       error:&error];
    
    NSArray *searchArray = searchDictionary[@"items"];
    NSArray *usersArray = [self createUsersFromArray:searchArray];
    return usersArray;
}

-(NSArray *) createUsersFromArray:(NSArray *)searchArray
{
    NSMutableArray *usersArray = [NSMutableArray new];
    for (NSDictionary *dictionary in searchArray)
    {
        GHGitUser *user = [GHGitUser new];
        user.name = dictionary[@"login"];
        user.imageURL = dictionary[@"avatar_url"];
        
        [usersArray addObject:user];
    }
    return usersArray;
}

@end