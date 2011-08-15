//
//  PusherChatMessage.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PusherChat;
@class PusherChatUser;

@interface PusherChatMessage : NSObject {
  __weak PusherChat *chat;
}
@property (nonatomic, readonly) NSString *message;
@property (nonatomic, readonly) NSInteger userID;
@property (nonatomic, readonly) PusherChatUser *user;

- (id)initWithDictionaryFromService:(NSDictionary *)dictionary chat:(PusherChat *)aChat;
@end
