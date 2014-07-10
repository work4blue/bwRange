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
    
    //[ self scanBleFinder ];

}

-(void)viewDidAppear{
    DLog(@"Main Table viewDidAppear....");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
