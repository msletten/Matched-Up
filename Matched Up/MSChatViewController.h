//
//  MSChatViewController.h
//  Matched Up
//
//  Created by Mat Sletten on 6/20/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "JSMessagesViewController.h"

@interface MSChatViewController : JSMessagesViewController <JSMessagesViewDelegate, JSMessagesViewDataSource>

@property (strong, nonatomic) PFObject *chatRoom;

@end
