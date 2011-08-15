//
//  PusherChatMessage.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherChatMessage.h"
#import "PusherChatService.h"


@implementation PusherChatMessage

@synthesize userID;
@synthesize message;

- (id)initWithDictionaryFromService:(NSDictionary *)dictionary chat:(PusherChat *)aChat
{
  if ((self = [super init])) {
    chat = aChat;
    message = [[dictionary objectForKey:@"message"] copy];
    userID = [[dictionary objectForKey:@"user_id"] integerValue];
  }
  return self;
}

- (void)dealloc 
{
  [message release];
  [super dealloc];
}

- (PusherChatUser *)user
{
  return [chat userWithID:self.userID];
}

@end
