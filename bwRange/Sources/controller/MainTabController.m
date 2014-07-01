//
//  MainTabController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-7-1.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "MainTabController.h"

#import "LogViewController.h"

#import "AppDelegate.h"

@interface MainTabController ()

@property (nonatomic) BOOL isScanning;

@end

@implementation MainTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
        _activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _activity.frame = CGRectMake(145, 13, 30, 30);
        _activity.hidesWhenStopped = YES;
        [self.view addSubview:_activity];
    
     BW_INFO_LOG(@"服务正运行...");
    
    DLog(@"Main Table View Load....");
    
   // [ self scanBleFinder ];

}

-(void)viewDidAppear{
    DLog(@"Main Table viewDidAppear....");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initBle{
    _bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    
}

-(void)stopScan{
    [self.bleManager stopScan];
    [_activity stopAnimating];
    BW_INFO_LOG(@"停止扫描");
    
    self.isScanning = NO;
}


-(void)scanBleFinder
{
    
    if(self.isScanning){
        [self stopScan];
    }
    
    BW_INFO_LOG(@"正在扫描外设...");
    
    
    self.isScanning = YES;
    
    //[_activity startAnimating];
    [_bleManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    double delayInSeconds = 10.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSLog(@"scan timeout");
        if(self.isScanning){
             BW_INFO_LOG(@"扫描超时,扫描到%d个设备",[ AppDelegate getManager].scanCount);
             [ self stopScan ];
             [ self connectFinders];
        }
    });
}

// 开始连接
-(void)connectPeripheral:(CBPeripheral*)peripheral
{
    if(peripheral == nil)
        return ;
    
    NSLog(@"connectPeripheral %@",peripheral);
    
    if (![peripheral isConnected]){
        // 连接设备
         BW_INFO_LOG(@"联接设备 %s ",[ peripheral.identifier UUIDString]);
        [_bleManager connectPeripheral:peripheral options:nil];
    }
    else{
        // 检测已连接Peripherals
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 6.0){
            BW_INFO_LOG(@"设备 %s 重连",[ peripheral.identifier UUIDString ]);
          //  [_bleManager retrieveConnectedPeripherals];
        }
    }
    
}





-(int)connectFinders{
    
    int count = 0;
    for (int i=0; i < [ AppDelegate getManager].nBleFinders.count; i++) {
        BleFinder * device = (BleFinder *)[ [ AppDelegate getManager].nBleFinders objectAtIndex:i];
        
        CBPeripheral * peripheral = [ device getPeripheral ];
        
        if(peripheral != nil)
        {
            count ++;
            [self connectPeripheral:peripheral ];
        }
        
        
    }
    
    return count;
    
}

//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            BW_INFO_LOG(@"蓝牙已打开,请扫描外设");
            break;
        default:
            break;
    }
}

//查到外设后，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    BW_INFO_LOG(@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, [ peripheral.identifier UUIDString ], advertisementData);
    
    [[ AppDelegate getManager] scanedDevice:peripheral];
    
    if([[ AppDelegate getManager] isAllScaned])
    {
         [ self stopScan ];
        
        [ self connectFinders];
    }
    
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    
    NSString * uuid = [ peripheral.identifier UUIDString ];
    BW_INFO_LOG(@"成功连接 peripheral: %@ with UUID: %@",peripheral,uuid);
    
    
    BleFinder * finder = [[ AppDelegate getManager]  getFinder:peripheral];
    
    if(finder == nil){
        BW_INFO_LOG(@"成功连接%s,但不是防丢器",uuid);
    }
    
    [ peripheral setDelegate:self];
    [ peripheral discoverServices:nil];
    BW_INFO_LOG(@"扫描服务:%s",uuid);
    
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    BW_INFO_LOG(@"连接 peripheral失败: %@ with UUID: %@",peripheral,[ peripheral.identifier UUIDString ]);
}


//扫描外设服务成功
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    BW_INFO_LOG(@"发现服务.");
    
    BleFinder * finder = [[ AppDelegate getManager]  getFinder:peripheral];
    if(finder == nil)
        return ;
    
    int i=0;
    
    for (CBService *s in peripheral.services) {
        [finder.nServices addObject:s];
    }
    for (CBService *s in peripheral.services) {
        BW_INFO_LOG(@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID);
        i++;
        [peripheral discoverCharacteristics:nil forService:s];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
