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

  }
  return self;
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
