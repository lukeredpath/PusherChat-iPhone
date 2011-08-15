//
//  PusherChatMonitor.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 16/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherChatMonitor.h"
#import "PTPusher.h"
#import "PTPusherChannel.h"
#import "PTPusherEvent.h"
#import "PusherChatService.h"
#import "PusherChatUser.h"
#import "PusherChatMessage.h"
#import "Macros.h"


@interface PusherChatMonitor ()
@property (nonatomic, readonly) PTPusher *pusher;
@property (nonatomic, retain) PTPusherChannel *channel;
- (void)bindToChatEvents;
@end

@implementation PusherChatMonitor

@synthesize pusher = _pusher;
@synthesize channel;

- (id)initWithPusher:(PTPusher *)aPusher chat:(PusherChat *)aChat
{
  if ((self = [super init])) {
    _pusher = [aPusher retain];
    _pusher.delegate = self;
    chat = [aChat retain];
  }
  return self;
}

- (void)dealloc 
{
  [_pusher disconnect];
  [_pusher release];
  [chat release];
  [super dealloc];
}

- (void)startMonitoring
{
  if ([self.pusher.connection isConnected]) {
    self.channel = [self.pusher subscribeToPresenceChannelNamed:chat.channel delegate:self];
    [self bindToChatEvents];
  }
  else {
    [self.pusher connect];
  }
}

#pragma mark - Pusher delegate methods

- (void)pusher:(PTPusher *)pusher connectionDidConnect:(PTPusherConnection *)connection
{
  self.channel = [pusher subscribeToPresenceChannelNamed:chat.channel delegate:self];
  [self bindToChatEvents];
}

#pragma mark - Event bindings

- (void)bindToChatEvents
{
  [self.channel bindToEventNamed:@"send_message" handleWithBlock:^(PTPusherEvent *event) {
    PusherChatMessage *message = [[PusherChatMessage alloc] initWithDictionaryFromService:event.data chat:chat];
    [chat receivedMessage:message];
    [message release];
  }];
}

#pragma mark - Presence events

- (void)presenceChannel:(PTPusherPresenceChannel *)channel didSubscribeWithMemberList:(NSArray *)members
{
  NSMutableArray *users = [NSMutableArray arrayWithCapacity:members.count];
  
  for (NSDictionary *userDictionary in members) {
    PusherChatUser *user = [[PusherChatUser alloc] initWithDictionaryFromService:userDictionary];
    [users addObject:user];
    [user release];
  }
  [chat didConnect:users];
}

- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberAdded:(NSDictionary *)memberData
{
  PusherChatUser *user = [[PusherChatUser alloc] initWithDictionaryFromService:memberData];
  [chat userDidJoin:user];
  [user release];
}

- (void)presenceChannel:(PTPusherPresenceChannel *)channel memberRemoved:(NSDictionary *)memberData
{
  NSInteger userID = [[memberData objectForKey:@"user_id"] integerValue];
  PusherChatUser *user = [chat userWithID:userID];
  [chat userDidLeave:user];
}

@end

#pragma mark -

@implementation PusherChatMonitorFactory

@synthesize key;

+ (id)defaultFactory
{
  DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
    return [[self alloc] init];
  });
}

- (PusherChatMonitor *)monitorForChat:(PusherChat *)chat
{
  PTPusher *pusher = [PTPusher pusherWithKey:self.key connectAutomatically:NO];
  return [[[PusherChatMonitor alloc] initWithPusher:pusher chat:chat] autorelease];
}

@end
