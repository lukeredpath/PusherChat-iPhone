//
//  RootViewController.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "ChatListViewController.h"
#import "PusherChatService.h"
#import "PusherChatMonitor.h"
#import "ChatViewController.h"


@interface ChatListViewController ()
@property (nonatomic, retain) NSArray *chats;
@end

@implementation ChatListViewController

@synthesize chatService;
@synthesize chats = _chats;

- (void)awakeFromNib
{
  self.chats = [NSArray array];
}

- (void)dealloc 
{
  [_chats release];
  [super dealloc];
}

- (void)setChats:(NSArray *)chats
{
  [_chats autorelease];
  _chats = [chats retain];
  
  [self.tableView reloadData];
}

#pragma mark - Actions

- (void)refreshChats
{
  [self.chatService fetchAvailableChatsWithCompletionHandler:^(BOOL successful, NSArray *chats) {
    if (successful) {
      self.chats = chats;
    }
    else {
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Connection Failed" message:@"Could not connect to chat server." delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
      [alert show];
      [alert release];
    }
  }];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // create a refresh button so users can reload chats whenever they want
  UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshChats)];
  [self.navigationItem setRightBarButtonItem:refreshButton];
  [refreshButton release];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  [self refreshChats];
}

#pragma mark - UITableView data/delegate methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.chats.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *ChatCellIdentifier = @"ChatCell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ChatCellIdentifier];
  
  if (cell == nil) {
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ChatCellIdentifier] autorelease];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
  }
  PusherChat *chat = [self.chats objectAtIndex:indexPath.row];
  cell.textLabel.text = chat.description;
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  PusherChat *chat = [self.chats objectAtIndex:indexPath.row];
  ChatViewController *chatController = [[ChatViewController alloc] init];
  chatController.chat = chat;
  chatController.chatService = self.chatService;
  chatController.chatMonitor = [[PusherChatMonitorFactory defaultFactory] monitorForChat:chat];
  [self.navigationController pushViewController:chatController animated:YES];
  [chatController release];
}

@end
