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
@property (strong, nonatomic) NSMutableData *imageData;


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

- (void)viewDidAppear:(BOOL)animated
{
    //check if user is cached and linked to Facebook, if so, bypass login
    if ([PFUser currentUser] && [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])
    {
        [self updateUserInformation];
        NSLog(@"the user is already signed in");
        [self performSegueWithIdentifier:@"loginToTabBarSegue" sender:self];
    }
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

#pragma mark - Helper Methods
//Let's create a method to update user information to Parse. We will call this method when a new user is created or some user data has been updated and we need to sync it.
- (void)updateUserInformation
{
    FBRequest *request = [FBRequest requestForMe];
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error)
    {
        if (!error)
        {
            NSDictionary *userDictionary = (NSDictionary *)result;
            
            //Create URL. Next we want to get a URL for the users profile picture. We could access all of our users photos but this is a great time to show you how to hit a URL and get data back which we can convert into our photo. Hopefully, you’ll be able to see the bigger picture by the time we’re done and be ready to access other URLs to get information from all over the web! Below we used the constant kMSUserProfilePictureURL constant to save the picture.
            NSString *facebookID = userDictionary[@"id"];
            NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
            
            NSMutableDictionary *userProfile = [[NSMutableDictionary alloc] initWithCapacity:7];
            if (userDictionary[@"name"])
            {
                userProfile[kMSUserProfileNameKey] = userDictionary[@"name"];
            }
            if (userDictionary[@"first_name"])
            {
                userProfile[kMSUserProfileFirstNameKey] = userDictionary[@"first_name"];
            }
            if (userDictionary[@"location"][@"name"])
            {
                userProfile[kMSUserProfileLocationKey] = userDictionary[@"location"][@"name"];
            }
            if (userDictionary[@"gender"])
            {
                userProfile[kMSUserProfileGenderKey] = userDictionary[@"gender"];
            }
            if (userDictionary[@"birthday"])
            {
                userProfile[kMSUserProfileBirthdayKey] = userDictionary[@"birthday"];
            }
            if (userDictionary[@"interested_in"])
            {
                userProfile[kMSUserProfileInterestedInKey] = userDictionary[@"interested_in"];
            }
            if ([pictureURL absoluteString])
            {
                userProfile[kMSUserProfilePictureURL] = [pictureURL absoluteString];
            }
            [[PFUser currentUser] setObject:userProfile forKey:kMSUserProfileKey];
            [[PFUser currentUser] saveInBackground];
            [self requestImage];
        }
        else
        {
            NSLog(@"Error in Facebook Request %@", error);
        }
    }];
}

//Create a helper method to upload a UIImage to Parse. Data objects let simple allocated buffers (that is, data with no embedded pointers) take on the behavior of Foundation objects.
- (void)uploadPFFileToParse:(UIImage *)image
{
    //JPEG to decrease file size and enable faster uploads & downloads
    NSLog(@"upload called");
    NSData *imageData = UIImageJPEGRepresentation(image, 0.8);
    if (!imageData)
    {
        NSLog(@"upload called, but no imageData found");
        return;
    }
    PFFile *photoFile = [PFFile fileWithData:imageData];
    [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (succeeded)
        {
            PFObject *photo = [PFObject objectWithClassName:kMSPhotoClassKey];
            [photo setObject:[PFUser currentUser] forKey:kMSPhotoUserKey];
            [photo setObject:photoFile forKey:kMSPhotoPictureKey];
            [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                NSLog(@"Photo uploaded successfully");
            }];
        }
    }];
}

//method to request an image from parse
- (void)requestImage
{
    PFQuery *query = [PFQuery queryWithClassName:kMSPhotoClassKey];
    [query whereKey:kMSPhotoUserKey equalTo:[PFUser currentUser]];
    [query countObjectsInBackgroundWithBlock:^(int number, NSError *error)
    {
        if (number ==0)
        {
            PFUser *user = [PFUser currentUser];
            self.imageData = [[NSMutableData alloc] init];
            NSURL *profilePictureURL = [NSURL URLWithString:user[kMSUserProfileKey][kMSUserProfilePictureURL]];
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:profilePictureURL cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:4.0f];
            //to run network request asynchronously
            NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
            if (!urlConnection)
            {
                NSLog(@"Failed to download Picture");
            }
        }
    }];
}

//Conform to the <NSURLConnectionDataDelegate> Remember that imageData property we added earlier? Time to use it. Lets implement both of the NSURLConnection Delegates
//As chunks of the image are received, we build our data file
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.imageData appendData:data];
}

//all data has been downloaded, now we can set the image in the header image view
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    UIImage *profileImage = [UIImage imageWithData:self.imageData];
    [self uploadPFFileToParse:profileImage];
}



@end
