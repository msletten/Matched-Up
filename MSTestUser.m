//
//  MSTestUser.m
//  Matched Up
//
//  Created by Mat Sletten on 6/12/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSTestUser.h"

@implementation MSTestUser

+ (void)saveTestUserToParse
{
    PFUser *newUser = [PFUser user];
    newUser.username = @"user1";
    newUser.password = @"password1";
    
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if(!error)
        {
        //NSLog(@"sign up %@", error);
        NSDictionary *profile = @{@"age" : @28, @"birthday" : @"11/22/1983", @"firstName" : @"Otto", @"gender" : @"female", @"location" : @"Stockholm, Sweden", @"name" : @"Otto Hjalmarsson"};
        [newUser setObject:profile forKey:@"profile"];
        [newUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            UIImage *profileImage = [UIImage imageNamed:@"Haberdash.jpg"];
            NSData *imageData = UIImageJPEGRepresentation(profileImage, 0.8);
            PFFile *photoFile = [PFFile fileWithData:imageData];
            [photoFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
            {
                if (succeeded)
                {
                    PFObject *photo = [PFObject objectWithClassName:kMSPhotoClassKey];
                    [photo setObject:newUser forKey:kMSPhotoUserKey];
                    [photo setObject:photoFile forKey:kMSPhotoPictureKey];
                    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
                    {
                        NSLog(@"Photo save successfully");
                    }];
                }
            }];
        }];
        }
    }];
}

@end
