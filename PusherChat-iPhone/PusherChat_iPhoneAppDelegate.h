//
//  PusherChat_iPhoneAppDelegate.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ChatListViewController;

@interface PusherChat_iPhoneAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet ChatListViewController *chatListController;

@end
