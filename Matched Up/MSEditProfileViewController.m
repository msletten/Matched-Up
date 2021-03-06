//
//  MSEditProfileViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/9/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSEditProfileViewController.h"

@interface MSEditProfileViewController () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *tagLineTextView;
@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *saveBarButton;


@end

@implementation MSEditProfileViewController

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
    
    //The EditProfileViewController needs the ability to update our tag line and show our picture. Let's query for the photo, set it in our image view, and also set the tag line.
    self.tagLineTextView.delegate = self;
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1/1.0];
    
    PFQuery *query = [PFQuery queryWithClassName:kMSPhotoClassKey];
    [query whereKey:kMSPhotoUserKey equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if ([objects count] > 0)
        {
            PFObject *photo = objects[0];
            PFFile *pictureFile = photo[kMSPhotoPictureKey];
            [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
            {
                self.profilePictureImageView.image = [UIImage imageWithData:data];
            }];
        }
    }];
    self.tagLineTextView.text = [[PFUser currentUser] objectForKey:kMSUserTagLineKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        [[PFUser currentUser] setObject:self.tagLineTextView.text forKey:kMSUserTagLineKey];
        [[PFUser currentUser] saveInBackground];
        [self.navigationController popViewControllerAnimated:YES];
        return NO;
    }
    else
    {
        return YES;
    }
}


@end
