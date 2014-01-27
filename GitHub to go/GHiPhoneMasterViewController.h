//
//  GHiPhoneMasterViewController.h
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/27/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//


@interface GHiPhoneMasterViewController : UIViewController
<UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *GHTable;

@end
