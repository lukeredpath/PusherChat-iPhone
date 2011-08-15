//
//  PusherChatDelegate.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PusherChat;
@class PusherChatMessage;
@class PusherChatUser;

@protocol PusherChatDelegate <NSObject>

- (void)chatDidConnect:(PusherChat *)chat;
- (void)chat:(PusherChat *)chat didReceiveMessage:(PusherChatMessage *)message;
- (void)chat:(PusherChat *)chat userDidJoin:(PusherChatUser *)user;
- (void)chat:(PusherChat *)chat userDidLeave:(PusherChatUser *)user;

@end
