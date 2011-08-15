//
//  PusherChatUser.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PusherChatUser : NSObject

@property (nonatomic, readonly) NSInteger userID;
@property (nonatomic, readonly) id key;
@property (nonatomic, readonly) NSString *nickname;

- (id)initWithDictionaryFromService:(NSDictionary *)dictionary;
+ (id)keyForUserWithID:(NSInteger)userID;

@end
