//
//  BleDevice.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-15.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

@interface BleDevice : NSObject



@property (nonatomic, strong) NSString  * UUID; //对应外部设备
@property (nonatomic, strong) NSString  * DevName;
@property (nonatomic, strong) NSNumber  * RSSI;

-(id) init;

-(void) setPeripheral:(CBPeripheral *)peripheral;
-(CBPeripheral *)getPeripheral;



-(int) detectDistance:(int)rssi;
@end
