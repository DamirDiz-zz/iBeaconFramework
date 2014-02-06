//
//  BeaconDefaults.m
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 16.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import "BeaconDefaults.h"

@implementation BeaconDefaults

#pragma mark CONSTANTS

int const BEACON_PURPLE_MAJOR = 37861;
int const BEACON_PURPLE_MINOR = 9251;
int const BEACON_BLUE_MAJOR   = 6868;
int const BEACON_BLUE_MINOR   = 42222;
int const BEACON_GREEN_MAJOR  = 27887;
int const BEACON_GREEN_MINOR  = 24905;

- (id)init
{
    self = [super init];
    if(self) {
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"B9407F30-F5F8-466E-AFF9-25556B57FE6D"], //STANDARD UUID FOR ESTIMOTE
                                     [[NSUUID alloc] initWithUUIDString:@"85EEEB46-A5FE-4DCE-A9F2-A6C364451E08"]];
    }
    
    return self;
}

//Singelton Instance of the BeaconDefaults
+ (BeaconDefaults *)sharedDefaults
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (NSUUID *)defaultProximityUUID
{
    return [_supportedProximityUUIDs objectAtIndex:0];
}

@end
