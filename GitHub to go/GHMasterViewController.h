//
//  GHMasterViewController.h
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/27/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GHDetailViewController;

@interface GHMasterViewController : UITableViewController

@property (strong, nonatomic) GHDetailViewController *detailViewController;

@end
