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

extern NSString *const kMSUserTagLineKey;
extern NSString *const kMSUserProfileKey;
extern NSString *const kMSUserProfileNameKey;
extern NSString *const kMSUserProfileFirstNameKey;
extern NSString *const kMSUserProfileLocationKey;
extern NSString *const kMSUserProfileGenderKey;
extern NSString *const kMSUserProfileBirthdayKey;
extern NSString *const kMSUserProfileInterestedInKey;
extern NSString *const kMSUserProfilePictureURL;
extern NSString *const kMSUserProfileRelationshipStatusKey;
extern NSString *const kMSUserProfileAgeKey;

#pragma mark - Photo Class

extern NSString *const kMSPhotoClassKey;
extern NSString *const kMSPhotoUserKey;
extern NSString *const kMSPhotoPictureKey;

#pragma mark - Activity Class

extern NSString *const kMSActivityClassKey;
extern NSString *const kMSActivityTypeKey;
extern NSString *const kMSActivityFromUserKey;
extern NSString *const kMSActivityToUserKey;
extern NSString *const kMSActivityPhotoKey;
extern NSString *const kMSActivityTypeLikeKey;
extern NSString *const kMSActivityTypeDislikeKey;

#pragma mark - Settings

extern NSString *const kMSMenEnabledKey;
extern NSString *const kMSWomenEnabledKey;
extern NSString *const kMSSingleEnabledKey;
extern NSString *const kMSAgeMaxKey;


#pragma mark - ChatRoom

extern NSString *const kMSChatRoomClassKey;
extern NSString *const kMSChatRoomUser1Key;
extern NSString *const kMSChatRoomUser2Key;

#pragma mark - Chat

extern NSString *const kMSChatClassKey;
extern NSString *const kMSChatChatroomKey;
extern NSString *const kMSChatFromUserKey;
extern NSString *const kMSChatToUserKey;
extern NSString *const kMSChatTextKey;

@end
