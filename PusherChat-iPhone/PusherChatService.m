//
//  PusherChatService.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherChatService.h"
#import "PusherChatUser.h"
#import <LRResty/LRResty.h>
#import "CJSONDeserializer.h"

@interface LRRestyResponse (PusherChatExtensions)
- (id)objectFromJSON;
@end

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

- (NSString *)description
{
  return [NSString stringWithFormat:@"Chat %d", self.chatID];
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

- (NSString *)resource:(NSString *)path
{
  return [serviceURL stringByAppendingPathComponent:path];
}

- (void)joinChat:(PusherChat *)chat withCompletionHandler:(void (^)(BOOL, PusherChatUser *))completionHandler
{
  [[LRResty client] post:[self resource:@"/api/join"] payload:nil withBlock:^(LRRestyResponse *response) {
    if (response.status == 201) {
      PusherChatUser *user = [[PusherChatUser alloc] initWithDictionaryFromService:[response objectFromJSON]];
      completionHandler(YES, user);
      [user release];
    }
    else {
      completionHandler(NO, nil);
    }
  }];
}

- (void)fetchAvailableChatsWithCompletionHandler:(void (^)(BOOL, NSArray *))completionHandler
{
  [[LRResty client] get:[self resource:@"/chats"] withBlock:^(LRRestyResponse *response) {
    if (response.status == 200) {
      NSMutableArray *chats = [NSMutableArray array];
      
      for (NSDictionary *chatDictionary in [response objectFromJSON]) {
        PusherChat *chat = [[PusherChat alloc] initWithDictionaryFromService:chatDictionary];
        [chats addObject:chat];
        [chat release];
      }
      completionHandler(YES, chats);
    }
    else {
      completionHandler(NO, nil);
    }
  }];
}

- (void)sendMessage:(NSString *)message toChat:(PusherChat *)chat
{
  NSMutableDictionary *parameters = [NSMutableDictionary dictionary];

  [parameters setObject:[NSNumber numberWithInteger:chat.chatID] forKey:@"chat_id"];
  [parameters setObject:message forKey:@"message"];
  
  // no need to handle the response to this, if it works we will receive an event from pusher
  [[LRResty client] post:[self resource:@"/api/post_message"] payload:parameters withBlock:nil];
}

@end

@implementation LRRestyResponse (PusherChatExtensions)

- (id)objectFromJSON
{
  return [[CJSONDeserializer deserializer] deserialize:[self responseData] error:nil];
}

@end
