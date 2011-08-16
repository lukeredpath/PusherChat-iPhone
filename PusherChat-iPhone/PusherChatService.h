//
//  PusherChatService.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PusherChatDelegate.h"


@class PusherChatUser;
@class PusherChatMessage;

@interface PusherChat : NSObject {
  NSMutableDictionary *users;
  NSMutableArray *messages;
}
@property (nonatomic, readonly) NSInteger chatID;
@property (nonatomic, readonly) NSString *channel;
@property (nonatomic, assign) id<PusherChatDelegate> delegate;
@property (nonatomic, readonly) NSDictionary *users;

- (id)initWithDictionaryFromService:(NSDictionary *)dictionary;
- (PusherChatUser *)userWithID:(NSInteger)userID;

#pragma mark - Handling state changes

- (void)didConnect:(NSArray *)currentUsers;
- (void)receivedMessage:(PusherChatMessage *)message;
- (void)userDidJoin:(PusherChatUser *)user;
- (void)userDidLeave:(PusherChatUser *)user;

@end

@interface PusherChatService : NSObject {
  NSString *serviceURL;
}
- (id)initWithServiceURL:(NSString *)URLString;

- (void)joinChat:(PusherChat *)chat withCompletionHandler:(void (^)(BOOL, PusherChatUser *))completionHandler;
- (void)fetchAvailableChatsWithCompletionHandler:(void (^)(BOOL, NSArray *))completionHandler;
- (void)sendMessage:(NSString *)message toChat:(PusherChat *)chat;

@end
