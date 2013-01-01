//
//  ICWebSocketDelegate.h
//  IRCCloud
//
//  Created by Adam D on 2/10/12.
//  Copyright (c) 2012 HASHBANG Productions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebSocket.h"

@interface ICWebSocketDelegate : NSObject <WebSocketDelegate>
{
	WebSocket *webSocket;
}

@property (nonatomic, strong) WebSocket *webSocket;

- (void)open;
- (void)close;
- (void)sendJSONFromDictionary:(NSDictionary *)dict;

@end
