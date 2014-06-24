//
//  BleCentralManager.h
//  bwRange 封装蓝牙服务器操作
//
//  Created by  Andrew Huang on 14-6-21.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

#define bleCentralDelegateStateCentralManagerPoweredOff (1)
#define bleCentralDelegateStateCentralManagerUnauthorized (2)
#define bleCentralDelegateStateCentralManagerUnknown (3)
#define bleCentralDelegateStateCentralManagerUnsupported (4)
#define bleCentralDelegateStateCentralManagerPoweredOn (5)
#define  bleCentralDelegateStateCentralManagerResetting (6)
#define  bleCentralDelegateStateRetrieveConnectedPeripherals (7)
#define bleCentralDelegateStateConnectPeripheral (8)
#define bleCentralDelegateStateDiscoverPeripheral (9)

#define nCentralStateChange 

@interface BleCentralManager : NSObject

@property (nonatomic, strong) CBCentralManager * activeCentralManager;
@property (nonatomic, strong) NSMutableArray *   blePeripheralArray;

@property (nonatomic) int currentCentralManagerState;

-(id)init;
-(void)initProperty;


@end
