//
//  MSTransitionAnimator.h
//  Matched Up
//
//  Created by Mat Sletten on 6/25/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

@property (nonatomic, assign) BOOL presenting;

@end
