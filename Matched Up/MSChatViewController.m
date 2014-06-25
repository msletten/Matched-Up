//
//  MSChatViewController.m
//  Matched Up
//
//  Created by Mat Sletten on 6/20/14.
//  Copyright (c) 2014 Mat Sletten. All rights reserved.
//

#import "MSChatViewController.h"

@interface MSChatViewController ()

@property (strong, nonatomic) PFUser *withUser;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *chats;
@property (strong, nonatomic) NSTimer *chatsTimer;
@property (nonatomic) BOOL initialLoadComplete;

@end

@implementation MSChatViewController

- (NSMutableArray *)chats
{
    if (!_chats)
    {
        _chats = [[NSMutableArray alloc] init];
    }
    return _chats;
}

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
    self.delegate = self;
    self.dataSource = self;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [[JSBubbleView appearance] setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0f]];
    self.messageInputView.textView.placeHolder = @"New Message";
    [self setBackgroundColor:[UIColor colorWithRed:218/255.0f green:165/255.0f blue:32/255.0f alpha:1/1.0f]];
    self.currentUser = [PFUser currentUser];
    PFUser *testUser1 = self.chatRoom[kMSChatRoomUser1Key];
    if ([testUser1.objectId isEqual:self.currentUser.objectId])
    {
        self.withUser = self.chatRoom[kMSChatRoomUser2Key];
    }
    else
    {
        self.withUser = self.chatRoom[kMSChatRoomUser1Key];
    }
    self.title = self.withUser[kMSUserProfileKey][kMSUserProfileFirstNameKey];
    self.initialLoadComplete = NO;
    
    [self checkForNewChats];
    
    self.chatsTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(checkForNewChats) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//We only want to check every 15 seconds when the user is on this view. When they leave this view, we need to stop the timer.
- (void)viewDidDisappear:(BOOL)animated
{
    [self.chatsTimer invalidate];
    self.chatsTimer = nil;
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.chats count];
}

#pragma mark - TableView Delegate Required

- (void)didSendText:(NSString *)text
{
    if (text.length != 0)
    {
        PFObject *chat = [PFObject objectWithClassName:kMSChatClassKey];
        [chat setObject:self.chatRoom forKey:kMSChatChatroomKey];
        [chat setObject:self.currentUser forKey:kMSChatFromUserKey];
        [chat setObject:self.withUser forKey:kMSChatToUserKey];
        [chat setObject:text forKey:kMSChatTextKey];
        [chat saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
        {
            //NSLog(@"save complete");
            [self.chats addObject:chat];
            [JSMessageSoundEffect playMessageSentSound];
            [self.tableView reloadData];
            [self finishSend];
            [self scrollToBottomAnimated:YES];
        }];
    }
}

- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kMSChatFromUserKey];
    if ([testFromUser.objectId isEqual:self.currentUser.objectId])
    {
        return JSBubbleMessageTypeOutgoing;
    }
    else
    {
        return JSBubbleMessageTypeIncoming;
    }
}

- (UIImageView *)bubbleImageViewWithType:(JSBubbleMessageType)type forRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    PFUser *testFromUser = chat[kMSChatFromUserKey];
    if ([testFromUser.objectId isEqual:self.currentUser.objectId])
    {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleGreenColor]];
    }
    else
    {
        return [JSBubbleImageViewFactory bubbleImageViewForType:type color:[UIColor js_bubbleLightGrayColor]];
    }
}

//JSMessageViewController has more delegate methods to implement that allow you to customize things like timestamps, style, etc. You can play with some of these in the extra credit. Let's add them now with some basic return values.

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyAll;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    return JSMessagesViewAvatarPolicyNone;
}

- (JSMessagesViewSubtitlePolicy)subtitlePolicy
{
    return JSMessagesViewSubtitlePolicyNone;
}

- (JSMessageInputViewStyle)inputViewStyle
{
    return JSMessageInputViewStyleFlat;
}

#pragma mark - Messages View Delegate Optional
//We've now implemented all required delegate methods. However, there are also optional delegate methods that we can implement. configureCell: allows us to customize what the cells look like. We'll customize our cells to have differing text colors depending on whether the message is incoming or outgoing.

- (void)configureCell:(JSBubbleMessageCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell messageType] == JSBubbleMessageTypeOutgoing)
    {
        cell.bubbleView.textView.textColor = [UIColor whiteColor];
    }
}

- (BOOL)shouldPreventScrollToBottomWhileUserScrolling
{
    return YES;
}

#pragma mark - Messages view data source: Required
//we need to determine what should be displayed in each cell. We simply set the text for each row to the chat text in the corresponding array index.

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *chat = self.chats[indexPath.row];
    NSString *message = chat[kMSChatTextKey];
    return message;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (UIImageView *)avatarImageViewForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (NSString *)subtitleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - Helper methods
//Implement a helper method to check for new chats. If there are new chats then we download them. Otherwise we do nothing at all.
- (void) checkForNewChats
{
    int oldChatCount = [self.chats count];
    PFQuery *queryForChats = [PFQuery queryWithClassName:kMSChatClassKey];
    [queryForChats whereKey:kMSChatChatroomKey equalTo:self.chatRoom];
    [queryForChats orderByAscending:@"createdAt"];
    [queryForChats findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            if (self.initialLoadComplete == NO || oldChatCount != [objects count])
            {
                self.chats = [objects mutableCopy];
                [self.tableView reloadData];
                if (self.initialLoadComplete == YES)
                {
                    [JSMessageSoundEffect playMessageReceivedSound];
                }
                self.initialLoadComplete = YES;
                [self scrollToBottomAnimated:YES];
            }
        }
    }];
}



@end
