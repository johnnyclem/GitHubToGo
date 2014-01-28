//
//  GHUserCollectioniPhoneMaster.h
//  GitHub to go
//
//  Created by Andrew Rodgers on 1/28/14.
//  Copyright (c) 2014 Andrew Rodgers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GHUserCollectioniPhoneMaster : UIViewController

<UIGestureRecognizerDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *userCollection;

@end
