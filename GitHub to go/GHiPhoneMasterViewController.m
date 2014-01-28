//
//  GHiPhoneMasterViewController.m
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/27/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import "GHiPhoneMasterViewController.h"
#import "GHDetailViewController.h"
#import "GHRepoSearch.h"
#import <QuartzCore/QuartzCore.h>

@interface GHiPhoneMasterViewController ()

@property (nonatomic) UIPanGestureRecognizer *panner;
@property (nonatomic) GHDetailViewController *detailViewController;
@property (nonatomic) NSArray *searchResults;

@end

@implementation GHiPhoneMasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.searchResults = [[GHRepoSearch sharedController] reposForSearchString:@"ios"];
    self.GHTable.delegate = self;
    self.GHTable.dataSource = self;
    
    
    //Eventually, this and everything in the Pan Gesture setup will be transferred out into a subclass, but I'm too preoccupied with other tasks right now to do that right away.
    //Builds the detail views on top of the list of GitHub repos
    self.detailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"iphonewebview"];
    [self addChildViewController:self.detailViewController];
    self.detailViewController.view.frame = self.view.frame;
    [self.view addSubview:self.detailViewController.view];
    [self.detailViewController didMoveToParentViewController:self];
    self.detailViewController.view.backgroundColor = [UIColor grayColor];
    
    //Sets up a slider menu, so that you can actually get to the list of GitHub repos
    [self setUpPanGesture];
    
    //Makes a shadow underneath the slider, for aesthetic purposes
    [self.detailViewController.view.layer setShadowOpacity:0.8];
    [self.detailViewController.view.layer setShadowOffset:CGSizeMake(-8, -8)];
    [self.detailViewController.view.layer setShadowColor:[UIColor blackColor].CGColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchButton:(id)sender
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

#pragma mark -Table Setup

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    NSDictionary *repo = self.searchResults[indexPath.row];
    cell.textLabel.text = [repo objectForKey:@"name"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *repoDict = self.searchResults[indexPath.row];
    self.detailViewController.detailItem = repoDict;
    [self.detailViewController.view setNeedsDisplay];
}

@end
