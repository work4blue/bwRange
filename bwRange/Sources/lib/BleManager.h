//
//  BleManager.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-21.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BleManager : NSObject<CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager * centralManager;

@property (nonatomic, strong) NSMutableArray *   blePeripherals;

@property (nonatomic, strong) NSString *   bleServiceUUID;


-(id)init;
-(void)initProperty;
@end
