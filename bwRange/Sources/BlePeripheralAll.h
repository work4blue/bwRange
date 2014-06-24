//
//  BlePeripheral.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-21.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BlePeripheral : NSObject

@property (nonatomic, strong) CBPeripheral * activePeripheral;
@property (nonatomic, strong) NSString * nameString;
@property (nonatomic, strong) NSString * uuidString;
@property (nonatomic, strong) NSString * staticString;
@end
