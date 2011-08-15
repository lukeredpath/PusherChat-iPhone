//
//  RootViewController.h
//  PusherChat-iPhone
//
//  Created by Luke Redpath on 15/08/2011.
//  Copyright 2011 LJR Software Limited. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PusherChatService;

@interface ChatListViewController : UITableViewController {

}
@property (nonatomic, retain) PusherChatService *chatService;
@end
