//
//  MSHomeViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/9/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSHomeViewController.h"
#import "MSTestUser.h"
#import "MSProfileViewController.h"
#import "MSMatchViewController.h"

@interface MSHomeViewController () <MSMatchViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *chatBarButtonItem;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *settingsBarButtonItem;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
@property (strong, nonatomic) IBOutlet UILabel *firstNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *likeButton;
@property (strong, nonatomic) IBOutlet UIButton *infoButton;
@property (strong, nonatomic) IBOutlet UIButton *dislikeButton;
//The HomeViewController is is where users will see images of other users that they can like and dislike. We'll need an array to hold the photos, and an integer to track the current photo that is showing.
@property (strong, nonatomic) NSArray *photoArray;
@property (strong, nonatomic) PFObject *userPhoto;
@property (strong, nonatomic) NSMutableArray *activities;

@property (nonatomic) int currentPhotoIndex;
@property (nonatomic) BOOL isLikedByCurrentUser;
@property (nonatomic) BOOL isDislikedByCurrentUser;


@end

@implementation MSHomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
//Set the current values of some properties. We don't want our buttons enabled to disable them; The current index we are on is the first photo since we haven't seen any photos yet. The first photo of course is index 0; Now we want to query Parse for our photos. We also want to download user information for each photo so we can show the data like tag line on each photo. The includeKey: method is where you request the user information along with the photo.
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [MSTestUser saveTestUserToParse];
    
    self.likeButton.enabled = NO;
    self.dislikeButton.enabled = NO;
    self.infoButton.enabled = NO;
    
    self.currentPhotoIndex = 0;
    
    PFQuery *query = [PFQuery queryWithClassName:kMSPhotoClassKey];
    [query whereKey:@"user" notEqualTo:[PFUser currentUser]];
    [query includeKey:kMSPhotoUserKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        self.photoArray = objects;
        [self queryForCurrentPhotoIndex];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//When the user presses the view chats button, we need to show all the matches in a table. The way to do this is to create a delegate to the match view controller so it dismisses itself.
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"homeToProfileSegue"])
    {
        MSProfileViewController *profileVC = segue.destinationViewController;
        profileVC.profilePhoto = self.userPhoto;
    }
    else if ([segue.identifier isEqualToString:@"homeToMatchSegue"])
    {
        MSMatchViewController *matchVC = segue.destinationViewController;
        matchVC.matchedUserImage = self.photoImageView.image;
        matchVC.matchVCDelegate = self;
    }
}

#pragma mark - IBActions
//call helper methods in button actions to evaluate as needed
- (IBAction)chatBarButtonPressed:(UIBarButtonItem *)sender
{
}
- (IBAction)settingsButtonPressed:(UIBarButtonItem *)sender
{
}
- (IBAction)likeButtonPressed:(UIButton *)sender
{
    [self checkLike];
}
- (IBAction)infoButtonPressed:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"homeToProfileSegue" sender:nil];
}
- (IBAction)dislikeButtonPressed:(UIButton *)sender
{
    [self checkDislike];
}

#pragma mark - Helper Methods
//We need a property to store the current photo, which is retrieved by downloading the image from Parse as shown below.
- (void)queryForCurrentPhotoIndex
{
    if ([self.photoArray count] > 0)
    {
        self.userPhoto = self.photoArray[self.currentPhotoIndex];
        PFFile *imageFile = self.userPhoto[kMSPhotoPictureKey];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
        {
        if (!error)
        {
            UIImage *userImage = [UIImage imageWithData:data];
            self.photoImageView.image = userImage;
            [self updateView];
        }
         else NSLog(@"%@", error);
        }];
        //We need to query for likes and dislikes before we enable our buttons to be pressed. Then we joined the queries together as two subqueries of a multiple query.
        PFQuery *queryForLike = [PFQuery queryWithClassName:kMSActivityClassKey];
        [queryForLike whereKey:kMSActivityTypeKey equalTo:kMSActivityTypeLikeKey];
        [queryForLike whereKey:kMSActivityPhotoKey equalTo:self.userPhoto];
        [queryForLike whereKey:kMSActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *queryForDislike = [PFQuery queryWithClassName:kMSActivityClassKey];
        [queryForDislike whereKey:kMSActivityTypeKey equalTo:kMSActivityTypeDislikeKey];
        [queryForDislike whereKey:kMSActivityPhotoKey equalTo:self.userPhoto];
        [queryForDislike whereKey:kMSActivityFromUserKey equalTo:[PFUser currentUser]];
        
        PFQuery *likeAndDislikeQuery = [PFQuery orQueryWithSubqueries:@[queryForLike, queryForDislike]];
        [likeAndDislikeQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
        {
            if (!error)
            {
                self.activities = [objects mutableCopy];
                if ([self.activities count] == 0)
                {
                    self.isLikedByCurrentUser = NO;
                    self.isDislikedByCurrentUser = NO;
                }
                else
                {
                    PFObject *activity = self.activities[0];
                    if ([activity[kMSActivityTypeKey] isEqualToString:kMSActivityTypeLikeKey])
                    {
                        self.isLikedByCurrentUser = YES;
                        self.isDislikedByCurrentUser = NO;
                    }
                    else if ([activity[kMSActivityTypeKey] isEqualToString:kMSActivityTypeDislikeKey])
                    {
                        self.isLikedByCurrentUser = NO;
                        self.isDislikedByCurrentUser = YES;
                    }
                    else
                    {
                        //some other type of activity
                    }
                }
                self.likeButton.enabled = YES;
                self.dislikeButton.enabled = YES;
                self.infoButton.enabled = YES;
            }
        }];
    }
}
//Our labels need to be updated to show the user information for each photo.
- (void)updateView
{
    self.firstNameLabel.text = self.userPhoto[kMSPhotoUserKey][kMSUserProfileKey][kMSUserProfileFirstNameKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", self.userPhoto[kMSPhotoUserKey][kMSUserProfileKey][kMSUserProfileAgeKey]];
    self.tagLineLabel.text = self.userPhoto[kMSPhotoUserKey][kMSUserTagLineKey];
}

//Our user presses the like or dislike button and moves to the next photo. We need a method to handle that work of tracking the photo index and calling the query.
- (void)setupNextPhoto
{
    if (self.currentPhotoIndex + 1 < self.photoArray.count)
    {
        self.currentPhotoIndex ++;
        [self queryForCurrentPhotoIndex];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No More Users to View" message:@"Check Back Later for more People!" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }
}

//save likes to Parse. We initialize a class name with a capital for "Activity". Those actions will now show up on Parse.
- (void)saveLike
{
    PFObject *likeActivity = [PFObject objectWithClassName:kMSActivityClassKey];
    [likeActivity setObject:kMSActivityTypeLikeKey forKey:kMSActivityTypeKey];
    [likeActivity setObject:[PFUser currentUser] forKey:kMSActivityFromUserKey];
    [likeActivity setObject:[self.userPhoto objectForKey:kMSPhotoUserKey] forKey:kMSActivityToUserKey];
    [likeActivity setObject:self.userPhoto forKey:kMSActivityPhotoKey];
    [likeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        self.isLikedByCurrentUser = YES;
        self.isDislikedByCurrentUser = NO;
        [self.activities addObject:likeActivity];
        [self checkForPhotoUserLikes];
        [self setupNextPhoto];
    }];
}
//save dislikes to Parse
- (void)saveDislike
{
    PFObject *dislikeActivity = [PFObject objectWithClassName:kMSActivityClassKey];
    [dislikeActivity setObject:kMSActivityTypeDislikeKey forKey:kMSActivityTypeKey];
    [dislikeActivity setObject:[PFUser currentUser] forKey:kMSActivityFromUserKey];
    [dislikeActivity setObject:[self.userPhoto objectForKey:kMSPhotoUserKey] forKey:kMSActivityToUserKey];
    [dislikeActivity setObject:self.userPhoto forKey:kMSActivityPhotoKey];
    [dislikeActivity saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        self.isLikedByCurrentUser = NO;
        self.isDislikedByCurrentUser = YES;
        [self.activities addObject:dislikeActivity];
        [self setupNextPhoto];
    }];
}
//Cehck if a photo has already been liked or disliked. We don't want to keep viewing photos that we already liked. So we setup the next photo if the current one is already liked. We delete the activity if the photo has been disliked. Only if the photo has not been neither liked nor disliked do we save the like.
- (void)checkLike
{
    if (self.isLikedByCurrentUser)
    {
        [self setupNextPhoto];
        return;
    }
    else if (self.isDislikedByCurrentUser)
    {
        for (PFObject *activity in self.activities)
        {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveLike];
    }
    else
    {
        [self saveLike];
    }
}

- (void)checkDislike
{
    if (self.isDislikedByCurrentUser)
    {
        [self setupNextPhoto];
        return;
    }
    else if (self.isLikedByCurrentUser)
    {
        for (PFObject *activity in self.activities)
        {
            [activity deleteInBackground];
        }
        [self.activities removeLastObject];
        [self saveDislike];
    }
    else
    {
        [self saveDislike];
    }
}
//We need a method to check whether another user has liked you, the current user. If you subsequently like that user back, then a match will be created. So let's see how we check if the other user has liked our current user with Parse. We use constraints to only return liked activities between two users.
- (void)checkForPhotoUserLikes
{
    PFQuery *query = [PFQuery queryWithClassName:kMSActivityClassKey];
    [query whereKey:kMSActivityFromUserKey equalTo:self.userPhoto[kMSPhotoUserKey]];
    [query whereKey:kMSActivityToUserKey equalTo:[PFUser currentUser]];
    [query whereKey:kMSActivityTypeKey equalTo:kMSActivityTypeLikeKey];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if ([objects count] > 0)
        {
            [self createChatRoom];
        }
    }];
}
//In the last video you checked for likes. If there are likes then we need to open a chatroom between these two users. Parse makes chat extremely easy. The idea is that you are telling Parse to open a chatroom between two users (current user and the owner of the liked photo). Why do we need the inverse chatroom? For our chatrooms the current user can be in either the user1 or user2 columns, so we need to check both.
- (void)createChatRoom
{
    //NSLog(@"create called");
    PFQuery *queryForChatRoom = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoom whereKey:@"user1" equalTo:[PFUser currentUser]];
    [queryForChatRoom whereKey:@"user2" equalTo:self.userPhoto[kMSPhotoUserKey]];
    
    PFQuery *queryForChatRoomInverse = [PFQuery queryWithClassName:@"ChatRoom"];
    [queryForChatRoomInverse whereKey:@"user1" equalTo:self.userPhoto[kMSPhotoUserKey]];
    [queryForChatRoomInverse whereKey:@"user2" equalTo:[PFUser currentUser]];
    
    PFQuery *combinedQuery = [PFQuery orQueryWithSubqueries:@[queryForChatRoom, queryForChatRoomInverse]];
    [combinedQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if ([objects count] == 0)
        {
            PFObject *chatroom = [PFObject objectWithClassName:@"ChatRoom"];
            [chatroom setObject:[PFUser currentUser] forKey:@"user1"];
            [chatroom setObject:self.userPhoto[kMSPhotoUserKey] forKey:@"user2"];
            [chatroom saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                [self performSegueWithIdentifier:@"homeToMatchSegue" sender:nil];
            }];
        }
    }];
}

#pragma mark - MSMatchViewControllerDelegate

- (void)presentMatchesViewController
{
    [self dismissViewControllerAnimated:NO completion:^
    {
        [self performSegueWithIdentifier:@"homeToMatchesSegue" sender:nil];
    }];
}



@end
