//
//  ICController.h
//  IRCCloud
//
//  Created by Aditya KD on 21/11/12.
//  Copyright (c) 2012 HASHBANG Productions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ICNetwork;

@protocol IControllerDelegate <NSObject>
@required
- (void)parserFinishedLoadingOOB;
- (void)controllerDidAddNetwork:(ICNetwork *)network;
- (void)controllerDidRemoveNetwork:(ICNetwork *)network;
@end

@interface ICController : NSObject
{
    __weak id<IControllerDelegate> _delegate;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSDictionary *preferences;
@property (nonatomic, strong) NSArray *highlights;
@property (nonatomic, strong) NSNumber *lastSelectedBID;

+ (ICController *)sharedController;

- (void)addNetworkFromDictionary:(NSDictionary *)dict;
- (void)addNetwork:(ICNetwork *)connection;
- (void)removeNetworkWithCID:(NSNumber *)cid;
- (NSArray *)networks;

- (ICNetwork *)networkForConnection:(NSNumber *)connectionID;
- (void)finishedLoadingOOB;

@end
