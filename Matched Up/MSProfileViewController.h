//
//  MSProfileViewController.h
//  Matched Up
//
//  Created by Mat Sletten on 6/9/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MSProfileViewControllerDelegate <NSObject>

- (void)didPressLike;
- (void)didPressDislike;

@end

@interface MSProfileViewController : UIViewController

@property (strong, nonatomic) PFObject *profilePhoto;
@property (weak, nonatomic) id <MSProfileViewControllerDelegate> delegate;

@end
