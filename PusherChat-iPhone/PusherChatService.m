//
//  PusherChatService.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherChatService.h"
#import "PusherChatUser.h"


@interface PusherChat ()
- (void)addUser:(PusherChatUser *)user;
- (void)removeUser:(PusherChatUser *)user;
@end

@implementation PusherChat

@synthesize chatID;
@synthesize channel;
@synthesize delegate;

- (id)initWithDictionaryFromService:(NSDictionary *)dictionary
{
  if ((self = [super init])) {
    chatID = [[dictionary objectForKey:@"id"] integerValue];
    channel = [[dictionary objectForKey:@"channel"] copy];
    users = [[NSMutableDictionary alloc] init];
    messages = [[NSMutableArray alloc] init];
  }
  return self;
}

- (void)dealloc 
{
  [users release];
  [messages release];
  [channel release];
  [super dealloc];
}

- (PusherChatUser *)userWithID:(NSInteger)userID
{
  return [users objectForKey:[PusherChatUser keyForUserWithID:userID]];
}

- (void)addUser:(PusherChatUser *)user
{
  [users setObject:user forKey:user.key];
}

- (void)removeUser:(PusherChatUser *)user
{
  [users removeObjectForKey:user.key];
}

#pragma mark - Handle pushed state changes)

- (void)didConnect:(NSArray *)currentUsers
{
  [users removeAllObjects];
  
  for (PusherChatUser *user in currentUsers) {
    
  }
  [self.delegate chatDidConnect:self];
}

- (void)receivedMessage:(PusherChatMessage *)message
{
  [messages addObject:message];
  [self.delegate chat:self didReceiveMessage:message];
}

- (void)userDidJoin:(PusherChatUser *)user
{
  [self addUser:user];
  [self.delegate chat:self userDidJoin:user];
}

- (void)userDidLeave:(PusherChatUser *)user
{
  [self removeUser:user];
  [self.delegate chat:self userDidLeave:user];
}

@end

@implementation PusherChatService

- (id)initWithServiceURL:(NSString *)URLString
{
  if ((self = [super init])) {
    serviceURL = [URLString copy];
  }
  return self;
}

- (void)dealloc 
{
  [serviceURL release];
  [super dealloc];
}

- (void)fetchAvailableChatsWithCompletionHandler:(void (^)(BOOL, NSArray *))completionHandler
{
  
}

- (void)sendMessage:(NSString *)message toChat:(PusherChat *)chat
{
  
}

@end
