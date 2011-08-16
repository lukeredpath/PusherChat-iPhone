//
//  PusherChatUser.m
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import "PusherChatUser.h"

@implementation PusherChatUser

@synthesize userID;
@synthesize nickname;

- (id)initWithDictionaryFromService:(NSDictionary *)dictionary
{
  if ((self = [super init])) {
    userID = [[dictionary objectForKey:@"id"] integerValue];
    nickname = [[dictionary objectForKey:@"nickname"] copy];
  }
  return self;
}

- (void)dealloc 
{
  [nickname release];
  [super dealloc];
}

- (NSString *)description
{
  return [NSString stringWithFormat:@"User %d", self.userID];
}

+ (id)keyForUserWithID:(NSInteger)userID
{
  return [NSNumber numberWithInteger:userID];
}

- (id)key
{
  return [[self class] keyForUserWithID:self.userID];
}

@end
