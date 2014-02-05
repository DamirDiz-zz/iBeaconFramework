//
//  BeaconTracker.h
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 16.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol BeaconTrackerDelegate <NSObject>

@optional

- (void)beaconTrackerUpdated;
//Returns a UUID based Dictionary filled with MAJOR based Dictionary filled with MINOR based Dictionaries filled with CLBeacon objects
- (void)beaconTrackerUpdatedWithBeacons:(NSDictionary *)beacons;

@end

@interface BeaconTracker : NSObject <CLLocationManagerDelegate>

+ (BeaconTracker *)sharedBeaconTracker;
- (void)addDelegate:(id<BeaconTrackerDelegate>)delegate;
- (void)removeDelegate:(id<BeaconTrackerDelegate>)delegate;

- (BOOL)isTracking;
- (void)startTrackingBeacons;
- (void)stopTrackingBeacons;

- (NSArray *)getAllBeacons;
- (NSArray *)getOriginalBeacons;
- (NSArray *)getBeaconsWhereUUID:(NSUUID *)uuid;
- (NSArray *)getBeaconsWhereUUID:(NSUUID *)uuid major:(NSNumber *)major;
- (CLBeacon *)getBeaconWhereUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor;
- (CLBeacon *)getClosestBeacon;

@end
