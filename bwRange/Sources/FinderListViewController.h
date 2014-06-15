//
//  FinderListViewController.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-12.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FinderListViewController : UITableViewController<CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong,nonatomic) NSMutableArray *nFinders;
@property (nonatomic) int currentLine ;

@property (nonatomic, strong) CBCentralManager *bleManager;
@property (strong,nonatomic) CBPeripheral *blePeripheral; //当前联接设备



@end
