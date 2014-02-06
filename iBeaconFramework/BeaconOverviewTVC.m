//
//  BeaconOverviewTVC.m
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 16.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import "BeaconOverviewTVC.h"
#import "BeaconTracker.h"
#import "BeaconOverviewCell.h"
#import "BeaconDefaults.h"

@interface BeaconOverviewTVC () <UITableViewDataSource>

@property (strong,nonatomic) NSDictionary* currentBeacons;

@end

@implementation BeaconOverviewTVC

@synthesize currentBeacons = _currentBeacons;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView setDataSource:self];
    
    self.currentBeacons = [[NSDictionary alloc] init];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.156f green:0.466f blue:0.635f alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    self.navigationController.navigationBar.translucent = YES;
    
    self.title = @"Übersicht";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[BeaconTracker sharedBeaconTracker] startTrackingBeacons];
    [[BeaconTracker sharedBeaconTracker] addDelegate:self];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[BeaconTracker sharedBeaconTracker] removeDelegate:self];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BeaconTracker sharedBeaconTracker] getAllBeacons] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"beaconCell";
    BeaconOverviewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];

    NSArray *allBeacons = [[BeaconTracker sharedBeaconTracker] getAllBeacons];
    
    CLBeacon *beacon = [allBeacons objectAtIndex:indexPath.row];
    
    cell.majorValueLabel.text = [beacon.major stringValue];
    cell.minorValueLabel.text = [beacon.minor stringValue];

    UIColor *cellColor;
    if(beacon.proximity == CLProximityUnknown)
    {
        cell.distanceValueLabel.text = @"Unbekannte Entfernung";
        cell.accuracyValueLabel.text = @"";
        cellColor = [BeaconOverviewCell getInactiveCellColor];
    }
    else if(beacon.proximity == CLProximityImmediate)
    {
        cell.distanceValueLabel.text = @"Umittelbar";
        cell.accuracyValueLabel.text = [NSString stringWithFormat:@"%.2fm",beacon.accuracy];
        cellColor = [BeaconOverviewCell getStandardCellColor];
    }
    else if(beacon.proximity == CLProximityNear)
    {
        cell.distanceValueLabel.text = @"Nah";
        cell.accuracyValueLabel.text = [NSString stringWithFormat:@"%.2fm",beacon.accuracy];
        cellColor = [BeaconOverviewCell getStandardCellColor];
    }
    else if(beacon.proximity == CLProximityFar)
    {
        cell.distanceValueLabel.text = @"Weit entfernt";
        cell.accuracyValueLabel.text = [NSString stringWithFormat:@"%.2fm",beacon.accuracy];
        cellColor = [BeaconOverviewCell getStandardCellColor];
    }
    
    [UIView animateWithDuration:.5 animations:^{
        [cell setBackgroundColor:cellColor];
    } completion:NULL];

    
    return cell;
}

- (void)beaconTrackerUpdatedWithBeacons:(NSDictionary *)beacons {
    self.currentBeacons = beacons;
    
    [self.tableView reloadData];
}

@end
