//
//  GHUserCollectioniPhoneMaster.m
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/28/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "GHUserCollectioniPhoneMaster.h"
#import "GHDetailViewController.h"
#import "GHRepoSearch.h"
#import "GHSearchedUserCell.h"

@interface GHUserCollectioniPhoneMaster ()
@property (nonatomic) UIPanGestureRecognizer *panner;
@property (nonatomic) GHDetailViewController *detailViewController;
@property (nonatomic) NSArray *searchResults;
@property (nonatomic) NSArray *userArray;
@property (nonatomic) NSOperationQueue *downloadQueue;

@end

@implementation GHUserCollectioniPhoneMaster

- (void)viewDidLoad
{
    [super viewDidLoad];
    @try
    {
        self.searchResults = [[GHRepoSearch sharedController] searchForUser:@"bob"];
    }
    @catch (NSException *exception)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"GitHub exploded!"
                                                        message:@"Their shields cannot withstand our bombardment, but we need them alive!"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cease fire"
                                              otherButtonTitles:nil];
        [alert show];
    }
    self.userArray = [self createUsersFromArray:self.searchResults];
    self.userCollection.delegate = self;
    self.userCollection.dataSource = self;
    self.downloadQueue = [NSOperationQueue new];
    
    
    //Eventually, this and everything in the Pan Gesture setup will be transferred out into a subclass, but I'm too preoccupied with other tasks right now to do that right away.
    //Builds the detail views on top of the list of GitHub repos
    self.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"iphonewebview"];
    [self addChildViewController:self.detailViewController];
    self.detailViewController.view.frame = self.view.frame;
    [self.view addSubview:self.detailViewController.view];
    [self.detailViewController didMoveToParentViewController:self];
    self.detailViewController.view.backgroundColor = [UIColor grayColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadFinishedNotification:) name:@"DOWNLOAD_NOTIFICATION" object:nil];
    
    //Sets up a slider menu, so that you can actually get to the list of GitHub repos
    [self setUpPanGesture];
    
    //Makes a shadow underneath the slider, for aesthetic purposes
    [self.detailViewController.view.layer setShadowOpacity:0.8];
    [self.detailViewController.view.layer setShadowOffset:CGSizeMake(-8, -8)];
    [self.detailViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
    [self openMenu];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)userSearchButton:(id)sender
{
    
}

#pragma mark -Pan gesture setup

-(void) setUpPanGesture
{
    //Builds mthe slider itself
    self.panner = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(slidePanel)];
    self.panner.minimumNumberOfTouches = 1;
    self.panner.maximumNumberOfTouches = 1;
    self.panner.delegate = self;
    
    //Makes the slider apply to the detail view controller
    [self.detailViewController.view addGestureRecognizer:self.panner];
}

-(void) slidePanel
{
    CGPoint translation = [self.panner translationInView:self.view];
    
    //This code makes the slider slide to the right, but not up, down, or left
    if (self.panner.state == UIGestureRecognizerStateChanged)
    {
        if (self.detailViewController.view.frame.origin.x+ translation.x > 0)
        {
            self.detailViewController.view.center = CGPointMake(self.detailViewController.view.center.x +translation.x, self.detailViewController.view.center.y);
            [self.panner setTranslation:CGPointMake(0,0) inView:self.view];
        }
    }
    
    //This will make the slider snap open or snap closed if the user lets go of panner
    if (self.panner.state == UIGestureRecognizerStateEnded)
    {
        if (self.detailViewController.view.frame.origin.x > self.view.frame.size.width / 2)
        {
            [self openMenu];
        }
        if (self.detailViewController.view.frame.origin.x < self.view.frame.size.width / 2 )
        {
            [UIView animateWithDuration:.4 animations:^{
                self.detailViewController.view.frame = self.view.frame;
            } completion:^(BOOL finished) {
                [self closeMenu];
            }];
        }
    }
}

//The method used above for snapping open
- (void)closeMenu
{
    [UIView animateWithDuration:0.2 animations:^{
        self.detailViewController.view.frame = CGRectMake(self.detailViewController.view.frame.origin.x + 20.f, self.detailViewController.view.frame.origin.y, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.detailViewController.view.frame = self.view.frame;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.detailViewController.view.frame = CGRectMake(self.detailViewController.view.frame.origin.x + 15.f, self.detailViewController.view.frame.origin.y, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
            } completion:^(BOOL finished) {
                [UIView animateWithDuration:0.1 animations:^{
                    self.detailViewController.view.frame = self.view.frame;
                }];
            }];
        }];
    }];
}

//The above code for when the user was opening the slider and went past halfway
- (void)openMenu
{
    [UIView animateWithDuration:1 animations:^{
        
        self.detailViewController.view.frame = CGRectMake(self.view.frame.size.width * .8, self.detailViewController.view.frame.origin.y, self.detailViewController.view.frame.size.width, self.detailViewController.view.frame.size.height);
    } completion:^(BOOL finished) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(slideBack)];
        [self.detailViewController.view addGestureRecognizer:tap];
    }];
}

//Makes the detail view slide back if the user taps on it
-(void)slideBack
{
    [UIView animateWithDuration:.4 animations:^{
        self.detailViewController.view.frame = self.view.frame;
    } completion:^(BOOL finished) {
        [self closeMenu];
    }];
}

#pragma mark -Collection View setup

-(GHSearchedUserCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GHSearchedUserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.avatarView.image = nil;
    //Connects each cell with a user and initializes a background queue for their downloads
    cell.user = [self.userArray objectAtIndex:indexPath.row];
    cell.user.downloadQueue = self.downloadQueue;
    
    //Sets up the cell display after initializing the downloads
    [cell initializeDisplay];
    
    return cell;
}

//Sets the number of cells for the collectionView to be the number of items
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.userArray.count;
}

//Sets each collectionView item to a corresponding cell
-(void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.detailViewController.detailItem = self.searchResults[indexPath.row];
}

//Reloads the UIImage on the cells when they finish downloading
- (void)downloadFinishedNotification:(NSNotification *)note
{
    id sender = [[note userInfo] objectForKey:@"user"];
    
    if ([sender isKindOfClass:[GHGitUser class]])
    {
        NSIndexPath *userPath = [NSIndexPath indexPathForItem:[self.userArray indexOfObject:sender] inSection:0];
        GHSearchedUserCell *cell = [self.userCollection cellForItemAtIndexPath:userPath];
        cell.user.isDownloading = NO;
        [self.userCollection reloadItemsAtIndexPaths:@[userPath]];
    }
}
@end
