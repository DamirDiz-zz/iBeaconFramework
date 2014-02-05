//
//  BeaconTracker.m
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 16.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import "BeaconTracker.h"
#import "BeaconDefaults.h"

@interface BeaconTracker()

@property (nonatomic, strong) NSArray *originalBeacons;
@property (nonatomic, strong) NSMutableDictionary *trackerBeacons;
@property (nonatomic, strong) NSMutableArray* delegates;
@property (nonatomic, assign) BOOL tracking;

@end

@implementation BeaconTracker
{
    CLLocationManager *_locationManager;
    NSMutableArray *_rangedRegions;
}

@synthesize tracking = _tracking;
@synthesize trackerBeacons = _trackerBeacons;
@synthesize delegates = _delegates;

- (id)init
{
    self = [super init];
    if(self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        
        _rangedRegions = [NSMutableArray array];
        [[BeaconDefaults sharedDefaults].supportedProximityUUIDs enumerateObjectsUsingBlock:^(id uuidObj, NSUInteger uuidIdx, BOOL *uuidStop) {
            NSUUID *uuid = (NSUUID *)uuidObj;
            CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:[uuid UUIDString]];
            [_rangedRegions addObject:region];
        }];
        
        self.originalBeacons = [[NSArray alloc] init];
        self.trackerBeacons = [[NSMutableDictionary alloc] init];
        self.delegates = [[NSMutableArray alloc] init];
        self.tracking = NO;
    }
    
    return self;
}

//Singelton Instance of the BeaconDefaults
+ (BeaconTracker *)sharedBeaconTracker
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void)addDelegate:(id<BeaconTrackerDelegate>)delegate
{
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<BeaconTrackerDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}

- (BOOL)isTracking{
    return self.tracking;
}
- (void)startTrackingBeacons
{
    if(!self.tracking) {
        self.tracking = YES;
        
        [_rangedRegions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            CLBeaconRegion *region = obj;
            [_locationManager startRangingBeaconsInRegion:region];
        }];        
    }
}

- (void)stopTrackingBeacons
{
    self.tracking = NO;

    [_rangedRegions enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CLBeaconRegion *region = obj;
        [_locationManager stopRangingBeaconsInRegion:region];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    for(CLBeacon *beacon in beacons) {
        NSUUID *uuid = beacon.proximityUUID;
        
        NSMutableDictionary *majorDictionary = [self.trackerBeacons objectForKey:uuid];
        NSMutableDictionary *minorDictionary;
        
        if(majorDictionary == nil) {
            //NSLog(@"Dictionary für UUID %@ wird angelegt", uuid.UUIDString);
            majorDictionary = [[NSMutableDictionary alloc] init];
            minorDictionary = [[NSMutableDictionary alloc] init];
            
            //NSLog(@"Dictionary für Major %@ wird angelegt", beacon.major);
            [minorDictionary setObject:beacon forKey:beacon.minor];
            [majorDictionary setObject:minorDictionary forKey:beacon.major];
            [self.trackerBeacons setObject:majorDictionary forKey:uuid];
            
        } else {
            minorDictionary = [majorDictionary objectForKey:beacon.major];
            
            if(minorDictionary == nil) {
                //NSLog(@"Dictionary für Major %@ wird angelegt", beacon.major);
                minorDictionary = [[NSMutableDictionary alloc] init];
            }
            
            [minorDictionary setObject:beacon forKey:beacon.minor];
            //NSLog(@"Beacon für Minor %@ wird gesetzt", beacon.major);
            [majorDictionary setObject:minorDictionary forKey:beacon.major];
        }
    }
    
    self.originalBeacons = beacons;
    
    [self.delegates enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [obj beaconTrackerUpdated];
        [obj beaconTrackerUpdatedWithBeacons:[[NSDictionary alloc] initWithDictionary:self.trackerBeacons]];
    }];
}

- (NSArray *)getOriginalBeacons
{
    return self.originalBeacons;
}

- (NSArray *)getAllBeacons
{
    NSMutableArray *allBeacons = [[NSMutableArray alloc] init];
    
    NSArray *uuidDictionariesKeys = [self.trackerBeacons allKeys];
    
    for(NSUUID *uuidDictKey in uuidDictionariesKeys)
    {
        NSDictionary *majorDictionary = [self.trackerBeacons objectForKey:uuidDictKey];
        NSArray *majorDictionaryKeys = [[majorDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        for(id majorDictionaryKey in majorDictionaryKeys)
        {
            NSDictionary *minorDictionary = [majorDictionary objectForKey:majorDictionaryKey];
            NSArray *minorDictionaryKeys = [[minorDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
            
            for(id minorDictionaryKey in minorDictionaryKeys)
            {
                CLBeacon *beacon = [minorDictionary objectForKey:minorDictionaryKey];
                [allBeacons addObject:beacon];
            }
        }
    }
    
    return [allBeacons copy];
}

- (NSArray *)getBeaconsWhereUUID:(NSUUID *)uuid
{
    NSMutableArray *beacons = [[NSMutableArray alloc] init];
    
    NSDictionary *majorDictionary = [self.trackerBeacons objectForKey:uuid];
    
    NSArray *majorDictionaryKeys = [[majorDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    for(id majorDictionaryKey in majorDictionaryKeys)
    {
        NSDictionary *minorDictionary = [majorDictionary objectForKey:majorDictionaryKey];
        NSArray *minorDictionaryKeys = [[minorDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        for(id minorDictionaryKey in minorDictionaryKeys)
        {
            CLBeacon *beacon = [minorDictionary objectForKey:minorDictionaryKey];
            [beacons addObject:beacon];
        }
    }
    
    return [beacons copy];

}

- (NSArray *)getBeaconsWhereUUID:(NSUUID *)uuid major:(NSNumber *)major
{
    NSMutableArray *beacons = [[NSMutableArray alloc] init];

    NSDictionary *majorDictionary = [self.trackerBeacons objectForKey:uuid];
    
    if(majorDictionary)
    {
        NSDictionary *minorDictionary = [majorDictionary objectForKey:major];
        
        NSArray *minorDictionaryKeys = [[minorDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)];
        
        for(id minorDictionaryKey in minorDictionaryKeys)
        {
            CLBeacon *beacon = [minorDictionary objectForKey:minorDictionaryKey];
            [beacons addObject:beacon];
        }

    }
    
    return [beacons copy];
}

- (CLBeacon *)getBeaconWhereUUID:(NSUUID *)uuid major:(NSNumber *)major minor:(NSNumber *)minor
{
    NSDictionary *majorDictionary = [self.trackerBeacons objectForKey:uuid];
    
    if(majorDictionary)
    {
        NSDictionary *minorDictionary = [majorDictionary objectForKey:major];
        
        if(minorDictionary)
        {
            CLBeacon *beacon = [minorDictionary objectForKey:minor];
            
            if(beacon)
            {
                return beacon;
            }
        }
    }
    
    return nil;
}

- (CLBeacon *)getClosestBeacon
{
    return [self.originalBeacons objectAtIndex:0];
}


@end
