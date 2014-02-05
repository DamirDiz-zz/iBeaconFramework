//
//  BeaconOverviewCell.h
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 21.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BeaconOverviewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *majorValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *minorValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *distanceValueLabel;

+ (UIColor *)getStandardCellColor;
+ (UIColor *)getInactiveCellColor;

@end
