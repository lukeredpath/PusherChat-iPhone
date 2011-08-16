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
#import <SSToolKit/SSTextField.h>


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

  // configure the messages input controls
  [self.sendButton addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
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
  NSString *messageText = self.textField.text;
  
  if (![messageText isEqualToString:@""]) {
    [self.chatService sendMessage:messageText toChat:self.chat];
  }
  [self.textField resignFirstResponder];
  [self.textField setText:nil];
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
  NSIndexPath *indexPathForMessage = [NSIndexPath indexPathForRow:[chat.messages indexOfObject:message] inSection:0];
  
  [self.tableView beginUpdates];
  [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPathForMessage] withRowAnimation:UITableViewRowAnimationFade];
  [self.tableView endUpdates];
}

#pragma mark - SSMessagesViewController customisation

- (SSMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  PusherChatMessage *message = [self.chat.messages objectAtIndex:indexPath.row];
  
  if (message.user.userID == self.user.userID) {
    return SSMessageStyleLeft;
  }
  return SSMessageStyleRight;
}

- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath;
{
  PusherChatMessage *message = [self.chat.messages objectAtIndex:indexPath.row];
  return message.message;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.chat.messages.count;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  [self sendMessage:nil];
  [textField resignFirstResponder];
  return YES;
}

@end
