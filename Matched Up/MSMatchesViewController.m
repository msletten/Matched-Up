//
//  MSMatchesViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/19/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSMatchesViewController.h"

@interface MSMatchesViewController ()

@property (strong, nonatomic) IBOutlet UITableView *matchesTableView;

@end

@implementation MSMatchesViewController

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

@end
