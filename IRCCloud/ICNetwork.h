//
//  ICNetwork.h
//  IRCCloud
//
//  Created by Aditya KD on 21/11/12.
//  Copyright (c) 2012 HASHBANG Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICBuffer, ICChannel, ICNetwork;

@protocol ICNetworkDelegate <NSObject>
@optional
- (void)network:(ICNetwork *)network didAddChannel:(ICChannel *)channel;
- (void)network:(ICNetwork *)network willRemoveChannel:(ICChannel *)channel;
- (void)network:(ICNetwork *)network didRemoveChannel:(ICChannel *)channel;

- (void)network:(ICNetwork *)network didChangeStatus:(NSString *)oldStatus toStatus:(NSString *)newStatus;
- (void)network:(ICNetwork *)network disconnectedUnexpectedlyWithInfo:(NSDictionary *)info;
@end

@interface ICNetwork : NSObject
{
    __weak id<ICNetworkDelegate> _delegate;
}

@property (nonatomic, copy) NSString *networkName;
@property (nonatomic, copy) NSString *hostName;
@property (nonatomic, assign, getter = isSSL) BOOL SSL;
@property (nonatomic, copy) NSNumber *port;
@property (nonatomic, copy) NSNumber *cid;
@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSNumber *connectionLag; // lag in µs.

@property (nonatomic, weak) id delegate;

- (id)initWithNetworkNamed:(NSString *)networkName hostName:(NSString *)hostName SSL:(BOOL)isSSL port:(NSNumber *)port connectionID:(NSNumber *)cid;
- (void)disconnectedUnexepectedlyWithFailInfo:(NSDictionary *)info;


// Channels included in the OOB don't have as many properties as the dictionary sent along later
- (void)addOOBChannelFromDictionary:(NSDictionary *)dict;
- (void)addChannelFromDictionary:(NSDictionary *)dict;

// returns an array of all current ICChannel(s)
- (NSArray *)channels;

// sent along when the user uses another client to part.
- (void)removeChannelWithBID:(NSNumber *)channel;
// Sent *to* IRCCloud
- (void)userPartedChannelWithBID:(NSNumber *)bid;


// returns the appropriate ICChannel object
- (ICChannel *)channelWithBID:(NSNumber *)bid;

// add a notice to the notice buffer
- (void)addNotice:(NSDictionary *)notice;

@end
