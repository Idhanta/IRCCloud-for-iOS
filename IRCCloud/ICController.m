//
//  ICController.m
//  IRCCloud
//
//  Created by Aditya KD on 21/11/12.
//  Copyright (c) 2012 HASHBANG Productions. All rights reserved.
//

#import "ICController.h"
#import "ICNetwork.h"
#import "ICParser.h"

@implementation ICController
{
    __strong NSMutableDictionary *_connections;
}

+ (ICController *)sharedController
{
    static ICController *controller;
    if (!controller)
        controller = [[self alloc] init];
    return controller;
}

- (id)init
{
    self = [super init];
    if (self) {
        _connections = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addNetworkFromDictionary:(NSDictionary *)dict
{
    ICNetwork *network = [[ICNetwork alloc] initWithNetworkNamed:dict[@"name"]
                                                        hostName:dict[@"hostname"]
                                                             SSL:[(NSNumber *)dict[@"ssl"] boolValue]
                                                            port:(NSNumber *)dict[@"port"]
                                                    connectionID:(NSNumber *)dict[@"cid"]];
    network.status = dict[@"status"];
    [self addNetwork:network];
    
    if (_delegate && ![ICParser sharedParser].loadingOOB) {
        [_delegate controllerDidAddNetwork:network];
    }
}

- (void)addNetwork:(ICNetwork *)connection
{
    _connections[connection.cid] = connection;
    if (_delegate && ![ICParser sharedParser].loadingOOB) {
        [_delegate controllerDidAddNetwork:connection];
    }
        
    NSLog(@"connections: %@", _connections);
}

- (void)removeNetworkWithCID:(NSNumber *)cid
{
    if (_delegate && ![ICParser sharedParser].loadingOOB) {
        [_delegate controllerDidRemoveNetwork:_connections[cid]];
    }
    [_connections removeObjectForKey:cid];
}

- (ICNetwork *)networkForConnection:(NSNumber *)connectionID
{
    return _connections[connectionID];
}

- (NSArray *)networks
{
    return [_connections allValues];
}

- (void)finishedLoadingOOB
{
    if (_delegate && [_delegate class] == NSClassFromString(@"ICMasterViewController")) {
        [_delegate parserFinishedLoadingOOB];
    }
}

@end
