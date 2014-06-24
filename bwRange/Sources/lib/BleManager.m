//
//  BleManager.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-21.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "BleManager.h"

@implementation BleManager


-(id)init{
    self = [super init];
    if (self) {
        _centralManager = [[CBCentralManager alloc] initWithDelegate:(id<CBCentralManagerDelegate>)self queue:dispatch_get_main_queue()];
        [self initProperty];
    }
    return self;
    
}

-(void)initProperty{
    _blePeripherals = [[NSMutableArray alloc]init];
}


#pragma mark -
#pragma mark Scanning
/****************************************************************************/
/*   Scanning                                    */
/****************************************************************************/
// 按UUID进行扫描
-(void)startScanning{
    NSArray *uuidArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:_bleServiceUUID], nil];
    // CBCentralManagerScanOptionAllowDuplicatesKey | CBConnectPeripheralOptionNotifyOnConnectionKey | CBConnectPeripheralOptionNotifyOnDisconnectionKey | CBConnectPeripheralOptionNotifyOnNotificationKey
    NSDictionary *options = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:NO] forKey:CBCentralManagerScanOptionAllowDuplicatesKey];
    [_centralManager scanForPeripheralsWithServices:uuidArray options:options];
}

// 停止扫描
-(void)stopScanning{
    [_centralManager stopScan];
}

// 扫复位
-(void)resetScanning{
    [self stopScanning];
    [self startScanning];
}

#pragma mark -
#pragma mark Connection/Disconnection
/****************************************************************************/
/* Connection/Disconnection                            */
/****************************************************************************/
// 开始连接
-(void)connectPeripheral:(CBPeripheral*)peripheral
{
    if (![peripheral isConnected]){
        // 连接设备
        [_centralManager connectPeripheral:peripheral options:nil];
    }
    else{
        // 检测已连接Peripherals
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 6.0){
            [_centralManager retrieveConnectedPeripherals];
        }
    }
}

// 断开连接
-(void)disconnectPeripheral:(CBPeripheral*)peripheral
{
    // 主动断开
    [_centralManager cancelPeripheralConnection:peripheral];
    [self resetScanning];
}





@end
