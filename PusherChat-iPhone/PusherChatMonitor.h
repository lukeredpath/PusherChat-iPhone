//
//  PusherChatMonitor.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 16/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PTPusherDelegate.h"
#import "PTPusherPresenceChannelDelegate.h"


@class PTPusher;
@class PTPusherChannel;
@class PusherChat;

@interface PusherChatMonitorFactory : NSObject
@property (nonatomic, copy) NSString *pusherKey;

+ (id)defaultFactory;
- (void)monitorForChat:(PusherChat *)chat;
@end

@interface PusherChatMonitor : NSObject <PTPusherDelegate, PTPusherPresenceChannelDelegate> {
  PusherChat *chat;
}
- (id)initWithPusher:(PTPusher *)aPusher chat:(PusherChat *)aChat;
- (void)startMonitoring;
@end
