//
//  NewDeviceViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-11.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BleFinder.h"
#import "BleDevice.h"

@interface FinderDetailViewController : UITableViewController

@property (nonatomic, strong) BleDevice * bleDevice;
@property (nonatomic, strong) BleFinder * bleFinder;

@property (nonatomic, strong) CBCentralManager *bleManager;


@property (strong, nonatomic) NSArray * typeOptions;
@property (strong, nonatomic) NSArray * distanceOptions;
@property (strong, nonatomic) NSArray * ringtoneOptions;



- (void)newFinder:(int)finderType atRange:(int)range;
- (void)setFinder:(BleFinder *)finder;

- (IBAction)finishClick:(id)sender;
-(IBAction)vibrateSwitchAction:(id)sender;
@end
