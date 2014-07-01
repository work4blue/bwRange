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
@property (nonatomic, strong) NSNumber  * RSSI;  //实际信号强度，可以推算远/近和距离。
@property (nonatomic) CGFloat  distance;  //实际距离，米为单位

@property (strong,nonatomic) NSMutableArray *nServices;
@property (strong,nonatomic) NSMutableArray *nCharacteristics;
@property(nonatomic) float batteryValue;

-(id) init;

-(void) setPeripheral:(CBPeripheral *)peripheral;
-(CBPeripheral *)getPeripheral;



-(int) detectDistance:(int)rssi;
@end
