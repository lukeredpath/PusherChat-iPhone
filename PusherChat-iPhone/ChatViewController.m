//
//  ChatViewController.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 16/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "ChatViewController.h"
#import "PusherChatService.h"
#import "PusherChatMonitor.h"
#import "PusherChatUser.h"
#import "PusherChatMessage.h"


@implementation ChatViewController

@synthesize user = _user;
@synthesize chat = _chat;
@synthesize chatMonitor;
@synthesize chatService;

- (void)setChat:(PusherChat *)chat
{
  [_chat autorelease];
  _chat = [chat retain];
  _chat.delegate = self;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  self.title = self.chat.description;
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  
  __block ChatViewController *blockSelf = self;
  
  // we need to join to create a new user session on the server
  [self.chatService joinChat:self.chat withCompletionHandler:^(BOOL success, PusherChatUser *user) {
    if (success) {
      blockSelf.user = user;
      
      // need to configure the authentication URL before continuing
      [blockSelf.chatMonitor setUser:user];
      
      NSLog(@"Joined %@ as %@, starting chat monitor...", blockSelf.chat, user);
      
      [blockSelf.chatMonitor startMonitoring];
    }
    else {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Couldn't join chat!" message:@"A new chat session could not be established." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
      [alert show];
      [alert release];
    }
  }];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.chatMonitor stopMonitoring];
}

#pragma mark - Actions

- (IBAction)sendMessage:(id)sender
{
  
}

#pragma mark - PusherChat delegate methods

- (void)chatDidConnect:(PusherChat *)chat
{
  NSLog(@"Connected to %@, current users: %@", chat, chat.users);
}

- (void)chat:(PusherChat *)chat userDidJoin:(PusherChatUser *)user
{
  NSLog(@"User %@ joined %@", user, chat);
}

- (void)chat:(PusherChat *)chat userDidLeave:(PusherChatUser *)user
{
  NSLog(@"User %@ left %@", user, chat);
}

- (void)chat:(PusherChat *)chat didReceiveMessage:(PusherChatMessage *)message
{
  NSLog(@"Message from user %@: %@", message.user, message.message);
}

@end
