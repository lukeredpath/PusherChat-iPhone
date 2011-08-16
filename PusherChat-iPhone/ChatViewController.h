//
//  ChatViewController.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 16/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PusherChatDelegate.h"
#import "SSMessagesViewController.h"


@class PusherChat;
@class PusherChatMonitor;
@class PusherChatUser;
@class PusherChatService;

@interface ChatViewController : SSMessagesViewController <PusherChatDelegate>

@property (nonatomic, retain) PusherChatUser *user;
@property (nonatomic, retain) PusherChat *chat;
@property (nonatomic, retain) PusherChatMonitor *chatMonitor;
@property (nonatomic, retain) PusherChatService *chatService;

- (IBAction)sendMessage:(id)sender;

@end
