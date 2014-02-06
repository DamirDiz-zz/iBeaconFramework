//
//  BeaconDefaults.h
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 16.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeaconDefaults : NSObject

+ (BeaconDefaults *)sharedDefaults;

@property (nonatomic, copy, readonly) NSArray *supportedProximityUUIDs;
@property (nonatomic, copy, readonly) NSUUID *defaultProximityUUID;

#pragma mark CONSTANTS

extern int const BEACON_PURPLE_MAJOR;
extern int const BEACON_PURPLE_MINOR;
extern int const BEACON_BLUE_MAJOR;
extern int const BEACON_BLUE_MINOR;
extern int const BEACON_GREEN_MAJOR;
extern int const BEACON_GREEN_MINOR;

@end
