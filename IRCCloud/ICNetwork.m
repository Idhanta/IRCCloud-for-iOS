//
//  ICNetwork.m
//  IRCCloud
//
//  Created by Aditya KD on 21/11/12.
//  Copyright (c) 2012 HASHBANG Productions. All rights reserved.
//

#import "ICNetwork.h"
#import "ICChannel.h"
#import "ICAppDelegate.h"
#import "ICWebSocketDelegate.h"

@implementation ICNetwork
{
    NSMutableDictionary *_channels;
}

#pragma mark Basic Settings -
- (id)initWithNetworkNamed:(NSString *)networkName hostName:(NSString *)hostName SSL:(BOOL)isSSL port:(NSNumber *)port connectionID:(NSNumber *)cid
{
    self = [super init];
    if (self){
        _networkName = networkName;
        _hostName = hostName;
        _SSL      = isSSL;
        _port     = port;
        _cid      = cid;
        _channels = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (id)description
{
    return [NSString stringWithFormat:@"Network name: %@ Port: %@, SSL: %@, CID: %@", self.networkName, self.port, ((self.isSSL) ? @"ON":@"OFF"), self.cid];
}

#pragma mark Channel Management -
- (void)addOOBChannelFromDictionary:(NSDictionary *)dict
{
    ICChannel *channel   = [[ICChannel alloc] initWithName:dict[@"name"] andBufferID:dict[@"bid"]];
    channel.cid          = dict[@"cid"];
    channel.creationDate = dict[@"created"];
    [_channels setObject:channel forKey:channel.bid];
}

- (void)addChannelFromDictionary:(NSDictionary *)dict
{
    __strong ICChannel *channel = [_channels objectForKey:dict[@"bid"]];
    if (!channel) {
        channel = [[ICChannel alloc] initWithName:dict[@"chan"] andBufferID:dict[@"bid"]];
        channel.cid = dict[@"created"];
    }
    channel.members      = dict[@"members"];
    channel.topic        = dict[@"topic"];
    channel.type         = dict[@"channel_type"];
    channel.mode         = dict[@"mode"];
    channel.ops          = dict[@"ops"];
    if (_delegate)
        [self.delegate network:self didAddChannel:channel];
    if (!channel)
        [_channels setObject:channel forKey:channel.bid];
}

- (void)addChannel:(ICChannel *)channel
{
    [_channels setObject:channel forKey:channel.bid];
    if (_delegate)
        [self.delegate network:self didAddChannel:channel];
    NSLog(@"%@", _channels);
}

- (void)removeChannelWithBID:(NSNumber *)bid
{
    if (_delegate)
        [self.delegate network:self didRemoveChannel:[_channels objectForKey:bid]];
    [_channels removeObjectForKey:bid];
}

// called when the user uses the app to part.
- (void)userPartedChannelWithBID:(NSNumber *)bid
{
    NSDictionary *removalDict = @{@"reqid"   : [NSNumber numberWithInt:arc4random()],
                                  @"_method" : @"part",
                                  @"cid"     : [(ICChannel *)[_channels objectForKey:bid] cid],
                                  @"channel" : [(ICChannel *)[_channels objectForKey:bid] name],
                                  @"msg"     : @"IRCCloud app for iOS"};
    [[(ICAppDelegate *)[UIApplication sharedApplication].delegate webSocket] sendJSONFromDictionary:removalDict];
    [_channels removeObjectForKey:bid];
}

- (NSArray *)channels
{
    return [_channels allValues];
}

@end

