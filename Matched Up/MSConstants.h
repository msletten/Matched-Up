//
//  MSConstants.h
//  Matched Up
//
//  Created by Mat Sletten on 6/4/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MSConstants : NSObject

//The app will have some global constants that will be useful to reference keys. These are below and work after importing this file into the project pch file.
#pragma mark - User Class

extern NSString *const kMSUserProfileKey;
extern NSString *const kMSUserProfileNameKey;
extern NSString *const kMSUserProfileFirstNameKey;
extern NSString *const kMSUserProfileLocationKey;
extern NSString *const kMSUserProfileGenderKey;
extern NSString *const kMSUserProfileBirthdayKey;
extern NSString *const kMSUserProfileInterestedInKey;
extern NSString *const kMSUserProfilePictureURL;

#pragma mark - Photo Class

extern NSString *const kMSPhotoClassKey;
extern NSString *const kMSPhotoUserKey;
extern NSString *const kMSPhotoPictureKey;

@end
