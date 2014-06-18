//
//  MSConstants.m
//  Matched Up
//
//  Created by Mat Sletten on 6/4/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSConstants.h"

@implementation MSConstants

#pragma mark - User Class

NSString *const kMSUserTagLineKey = @"tagLine";

NSString *const kMSUserProfileKey = @"profile";
NSString *const kMSUserProfileNameKey = @"name";
NSString *const kMSUserProfileFirstNameKey = @"firstName";
NSString *const kMSUserProfileLocationKey = @"location";
NSString *const kMSUserProfileGenderKey = @"gender";
NSString *const kMSUserProfileBirthdayKey = @"birthday";
NSString *const kMSUserProfileInterestedInKey = @"interestedIn";
NSString *const kMSUserProfilePictureURL = @"pictureURL";
NSString *const kMSUserProfileRelationshipStatusKey = @"relationshipStatus";
NSString *const kMSUserProfileAgeKey = @"age";

#pragma mark - Photo Class

NSString *const kMSPhotoClassKey = @"Photo";
NSString *const kMSPhotoUserKey = @"user";
NSString *const kMSPhotoPictureKey = @"image";

#pragma mark - Activity

NSString *const kMSActivityClassKey = @"Activity";
NSString *const kMSActivityTypeKey = @"type";
NSString *const kMSActivityFromUserKey = @"fromUser";
NSString *const kMSActivityToUserKey = @"toUser";
NSString *const kMSActivityPhotoKey = @"photo";
NSString *const kMSActivityTypeLikeKey = @"like";
NSString *const kMSActivityTypeDislikeKey = @"dislike";

#pragma mark - Settings

NSString *const kMSMenEnabledKey = @"men";
NSString *const kMSWomenEnabledKey = @"women";
NSString *const kMSSingleEnabledKey = @"single";
NSString *const kMSAgeMaxKey = @"ageMax";

@end
