//
//  PusherChat_iPhoneAppDelegate.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherChat_iPhoneAppDelegate.h"

@implementation PusherChat_iPhoneAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  self.window.rootViewController = self.navigationController;
  
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)dealloc
{
  [_window release];
  [_navigationController release];
  [super dealloc];
}

@end
