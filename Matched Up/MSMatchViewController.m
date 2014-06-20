//
//  MSMatchViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/19/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSMatchViewController.h"

@interface MSMatchViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *matchedUserImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentUserImageView;

@property (strong, nonatomic) IBOutlet UIButton *viewChatsButton;
@property (strong, nonatomic) IBOutlet UIButton *keepSearchingButton;


@end

@implementation MSMatchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)viewChatsButtonPressed:(UIButton *)sender
{
}
- (IBAction)keepSearchingButtonPressed:(UIButton *)sender
{
}


@end
