//
//  BeaconOverviewCell.m
//  iBeaconFramwork
//
//  Created by Damir Dizdarevic on 21.12.13.
//  Copyright (c) 2013 Damir Dizdarevic. All rights reserved.
//

#import "BeaconOverviewCell.h"

@implementation BeaconOverviewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self setBackgroundColor:[BeaconOverviewCell getStandardCellColor]];
}

+ (UIColor *)getStandardCellColor
{
    return [UIColor colorWithRed:12.0f/255.0f green:49.0f/255.0f blue:76.0/255.0f alpha:1.0];
}

+ (UIColor *)getInactiveCellColor
{
    return [UIColor colorWithRed:72.0f/255.0f green:72.0f/255.0f blue:72.0/255.0f alpha:1.0];
}



@end
