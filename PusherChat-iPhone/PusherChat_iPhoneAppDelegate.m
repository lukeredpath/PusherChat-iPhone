//
//  PusherChat_iPhoneAppDelegate.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherChat_iPhoneAppDelegate.h"
#import "PusherSettings.h"
#import "ChatListViewController.h"
#import "PusherChatService.h"


// assumes a local instance running using pow.cx
#define kPUSHER_CHAT_SERVICE_URL @"http://pusherchat.dev"

@implementation PusherChat_iPhoneAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize chatListController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  PusherChatService *chatService = [[PusherChatService alloc] initWithServiceURL:kPUSHER_CHAT_SERVICE_URL];
  self.chatListController.chatService = chatService;
  [chatService release];
  
  self.window.rootViewController = self.navigationController;  

  [self.window makeKeyAndVisible];
  
  return YES;
}

- (void)dealloc
{
  [chatListController release];
  [_window release];
  [_navigationController release];
  [super dealloc];
}

@end
