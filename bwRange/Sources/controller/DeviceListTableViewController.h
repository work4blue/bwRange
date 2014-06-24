//
//  DeviceListTableViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-10.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface DeviceListTableViewController : UITableViewController<CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *manager;
@property (nonatomic, strong) CBPeripheral *peripheral;



@property (strong ,nonatomic) CBCharacteristic *writeCharacteristic;

@property (strong,nonatomic) NSMutableArray *nDevices;





@property (strong,nonatomic) NSMutableArray *nServices;
@property (strong,nonatomic) NSMutableArray *nCharacteristics;
@property (nonatomic,strong) UIActivityIndicatorView *activity;

@property BOOL isRefreshing;
@property(nonatomic) float batteryValue;
@property (nonatomic) int count;


- (IBAction)rescanBle:(id)sender;


@end
