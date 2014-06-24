//
//  BleFinderService.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-24.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "BleFinderService.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "AppDelegate.h"


#define DEBUG_CENTRAL NO
#define DEBUG_PERIPHERAL NO
#define DEBUG_PROXIMITY NO

#define UPDATE_INTERVAL 1.0f

@interface BleFinderService() <CBPeripheralManagerDelegate, CBCentralManagerDelegate>

@property (nonatomic, strong) NSMutableArray * nBleFinders;
@end

@implementation BleFinderService{
    CBCentralManager *centralManager;
    CBPeripheralManager *peripheralManager;
    
    NSTimer *detectorTimer;
    int connectDevices ;
}

//将设备相关信息清除
-(void) resetFinders{
    for (int i=0; i < self.nBleFinders.count; i++) {
         BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        NSLog(@"Reset %@",device);
        [device reset];
    }
        
}

- (void)startScanning
{
    
   [ centralManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    _isDetecting = YES;
}

- (void)stopDetecting
{
    _isDetecting = NO;
    
    [centralManager stopScan];
   // centralManager = nil;
    
    [detectorTimer invalidate];
    detectorTimer = nil;
}

#pragma mark -

//根据数据开始扫描各个finder
- (void)startDetectingFinders
{
    self.nBleFinders = [AppDelegate getManager].nBleFinders;
    
    [self resetFinders ];
    
    [self startScanning ];
    
    connectDevices = 0;
    
//    detectorTimer = [NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL target:self
//                                                   selector:@selector(reportRangesToDelegates:) userInfo:nil repeats:YES];

    
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self stopDetecting ];
        
        if(connectDevices > 0)
        [self connectFinders ];
//       
//        
//        
    });
}

//根据扫描结果开始联接设备
-(void)connectFinders{
    for (int i=0; i < self.nBleFinders.count; i++) {
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        CBPeripheral * peripheral = [ device getPeripheral ];
        
        [self connectPeripheral:peripheral ];
        
      
    }
}

// 开始连接
-(void)connectPeripheral:(CBPeripheral*)peripheral
{
    if(peripheral == nil)
        return ;
    
    NSLog(@"connectPeripheral %@",peripheral);
    
    if (![peripheral isConnected]){
        // 连接设备
        [centralManager connectPeripheral:peripheral options:nil];
    }
    else{
        // 检测已连接Peripherals
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 6.0){
            [centralManager retrieveConnectedPeripherals];
        }
    }
}

-(id)init{
    if (self=[super init]) {
        
        dispatch_queue_t centralQueue = dispatch_queue_create("cn.bluedrum.service", DISPATCH_QUEUE_SERIAL);
        centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:centralQueue];
      
        // centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
           }
    
    return self;
}
#pragma mark -


#pragma mark - CBCentralManagerDelegate


- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral
     advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
     [centralManager stopScan];
   
    
    
    NSString * newUUID = [ peripheral.identifier UUIDString ];
    
    NSLog(@"scan device %@",peripheral);
    
    // Match if we have this device from before
    for (int i=0; i < self.nBleFinders.count; i++) {
        
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        DLog(@"%@,",device);
        
        NSString * uuid = device.UUID;
        
    
        if ([ uuid isEqual:newUUID]) {
           
            [device setPeripheral:peripheral ];
            
            connectDevices ++;
            
            break;
        }
    }
  
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    //if (DEBUG_CENTRAL)
        DLog(@"-- central state changed: %d", centralManager.state);
    
    if (central.state == CBCentralManagerStatePoweredOn) {
        [self startScanning];
    }
    
}

-(BleFinder *)getFinder:(CBPeripheral *)peripheral{
    for (int i=0; i < self.nBleFinders.count; i++) {
        
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        if([ peripheral isEqual:[ device getPeripheral]])
            return device;
    }
            
     return nil;
}

// 中心设备连接外围设备
-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    
 //   DLog(@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.UUID);
    
    DLog(@"didConnectPeripheral %@",peripheral);

    if ([centralManager isEqual:central]){
        
       BleFinder * finder = [self getFinder:peripheral];
    [finder setDevRSSI:peripheral.RSSI];
        
    }
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
     BleFinder * finder = [self getFinder:peripheral];
    
    [finder setDevRSSI:peripheral.RSSI];
}
@end
