//
//  MSProfileViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/9/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSProfileViewController.h"

@interface MSProfileViewController ()

@property (strong, nonatomic) IBOutlet UIImageView *profilePictureImageView;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (strong, nonatomic) IBOutlet UILabel *ageLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;
@property (strong, nonatomic) IBOutlet UILabel *tagLineLabel;

@end

@implementation MSProfileViewController

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
    PFFile *pictureFile = self.profilePhoto[kMSPhotoPictureKey];
    [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error)
    {
        self.profilePictureImageView.image = [UIImage imageWithData:data];
    }];
    
    PFUser *user = self.profilePhoto[kMSPhotoUserKey];
    self.locationLabel.text = user[kMSUserProfileKey][kMSUserProfileLocationKey];
    self.ageLabel.text = [NSString stringWithFormat:@"%@", user[kMSUserProfileKey][kMSUserProfileAgeKey]];
    self.statusLabel.text = user[kMSUserProfileKey][kMSUserProfileRelationshipStatusKey];
    self.tagLineLabel.text = user[kMSUserTagLineKey];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
