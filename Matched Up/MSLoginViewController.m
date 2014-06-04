//
//  MSLoginViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/3/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSLoginViewController.h"

@interface MSLoginViewController ()

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end

@implementation MSLoginViewController

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
    self.activityIndicator.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)loginButtonPressed:(UIButton *)sender
{
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    NSArray *permissionsArray = @[@"user_about_me", @"user_interests", @"user_relationships", @"user_birthday", @"user_location", @"user_relationship_details"];
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error)
    {
        [self.activityIndicator stopAnimating];
        self.activityIndicator.hidden = YES;
        if (!user)
        {
            if (!error)
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log In Error" message:@"The Facebook Login was cancelled" delegate:nil cancelButtonTitle:@"okay" otherButtonTitles:nil];
                [alertView show];
            }
            else
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Log in Error" message:[error description] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
                [alertView show];
            }
        }
        else
        {
            [self updateUserInformation];
            [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
        }
    }];
}

#pragma mark - Helper Method
//Let's create a method to update user information to Parse. We will call this method when a new user is created or some user data has been updated and we need to sync it.
- (void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        NSLog(@"%@",result);
        if (!error)
        {
            NSDictionary *userDictionary = (NSDictionary *)result;
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:7];
            if (userDictionary[@"name"])
            {
                userProfile[@"name"] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"])
            {
                userProfile[@"first_name"] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"location"][@"name"])
            {
                userProfile[@"location"] = userDictionary[@"location"][@"name"];
            }
            if (userDictionary[@"gender"])
            {
                userProfile[@"gender"] = userDictionary[@"gender"];
            }
            if (userDictionary[@"birthday"])
            {
                userProfile[@"birthday"] = userDictionary[@"birthday"];
            }
            if (userDictionary[@"interested_in"])
            {
                userProfile[@"interested_in"] = userDictionary[@"interested_in"];
            }
            [[PFUser currentUser] setObject:userProfile forKey:@"profile"];
            [[PFUser currentUser] saveInBackground];
        }
        else
        {
            NSLog(@"Error in Facebook Request %@", error);
        }
    }];
}








@end
