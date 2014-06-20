//
//  MSMatchViewController.h
//  Matched Up
//
//  Created by Mat Sletten on 6/19/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSMatchViewControllerDelegate <NSObject>

- (void)presentMatchesViewController;

@end

@interface MSMatchViewController : UIViewController

@property (strong, nonatomic) UIImage *matchedUserImage;

@property (weak) id <MSMatchViewControllerDelegate> matchVCDelegate;

@end
