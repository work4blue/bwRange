//
//  FinderListViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-12.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "FinderListViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import "UIView+Toast.h"
#import "BleFinder.h"
#import "Utils.h"
#import "AppDelegate.h"
#import "FinderStatusViewController.h"
#import "CustomImagePickerController.h"

#import "LogViewController.h"
#import "MainTabController.h"
#import "CameraViewController.h"

#import "ti_ble.h"

// BleFinder:UUID B8A0EC41-8C1F-6C2B-DDCB-7B6EA9A8BE1F, type 0, Name 钥匙,range 1,status 2,rssi -62.000000,distance 2.000000
/*
 // Proximity Profile Service UUIDs
 #define LINK_LOSS_SERVICE_UUID          0x1803
 #define IMMEDIATE_ALERT_SERVICE_UUID    0x1802
 #define TX_PWR_LEVEL_SERVICE_UUID       0x1804
 
 // Proximity Profile Attribute UUIDs
 #define PROXIMITY_ALERT_LEVEL_UUID      0x2A06
 #define PROXIMITY_TX_PWR_LEVEL_UUID     0x2A07
 */


@interface FinderListViewController ()

@property (nonatomic) BOOL isScanning;




@end

@implementation FinderListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
   // self.bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

   //新版本，从plist装入数据
    self.nFinders = [AppDelegate sharedInstance].dataManager.nBleFinders ;
    
//  本地测试数据
//    self.nFinders = [NSMutableArray arrayWithCapacity:16];
//    
//    [ self initFinderData ];
    
    self.navigationController.delegate = self ;
    
    if([self isDemoMode]){
        self.navigationItem.title  = @"演示模式";
        self.navigationItem.leftBarButtonItem.title = @"退出";
    }
    
    [self initBle ];
    DLog(@"FinderList Page Loading....");
    
    // [ self scanBleFinder ];
    
    
    
   
    
    
    
    [self initObserver];
    
    
    
    
}

-(void) refreshUI{
    DLog(@"refresh Finder List Status");
    [self.tableView reloadData];
}
#pragma mark -- Finder State Notification
- (void) refreshFinderState: (NSNotification*) aNotification
{
    //self.userProfile = [aNotification object];
    
    [self refreshUI];
   
    
   
}
//触发消息
//[[NSNotificationCenter defaultCenter] postNotificationName:NotificationFinderStateChanged object:finder_index userInfo:nil];

-(void) initObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshFinderState:) name:NotificationFinderStateChanged object:nil];
}

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewWillAppear:animated];
}

- (void)navigationController:(UINavigationController *)navigationController
       didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [viewController viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
    if(![self isDemoMode]){
        //[ [ AppDelegate getFinderService ] startDetectingFinders ];
        
        
     if([[AppDelegate getManager] isNeedRescan])
        [ self scanBleFinder ];
        
        DLog(@"FinderList Page willApper....");
    }
    
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    
}

- (BOOL)isDemoMode{
    return [[AppDelegate sharedInstance].dataManager isDemoMode];
}

-(void)initBle{
    _bleManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    [[AppDelegate getManager] setDelegate:self];
    
   
    
    
    
}

-(void)stopScan{
    [self.bleManager stopScan];
    //[_activity stopAnimating];
    BW_INFO_LOG(@"停止扫描");
    
    self.isScanning = NO;
}


-(void)scanBleFinder
{
    
//    if(self.isScanning){
//        [self stopScan];
//    }
    
    BW_INFO_LOG(@"正在扫描外设...");
    
    
    self.isScanning = YES;
    
    //[_activity startAnimating];
    [_bleManager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    
    double delayInSeconds = 30.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        
        NSLog(@"scan timeout");
        if(self.isScanning){
            BW_INFO_LOG(@"扫描超时,扫描到%d个设备",[ AppDelegate getManager].scanCount);
            [ self stopScan ];
           // [ self connectFinders];
        }
    });
}



// 开始连接
-(void)connectPeripheralOld:(CBPeripheral*)peripheral
{
    if(peripheral == nil)
        return ;
    
    NSLog(@"connectPeripheral %@",peripheral);
    
    if (![peripheral isConnected]){
        // 连接设备
        BW_INFO_LOG(@"联接设备 %@ ",[ peripheral.identifier UUIDString]);
        [_bleManager connectPeripheral:peripheral options:nil];
    }
    else{
        // 检测已连接Peripherals
        float version = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (version >= 6.0){
            BW_INFO_LOG(@"设备 %@ 重连",[ peripheral.identifier UUIDString ]);
            //  [_bleManager retrieveConnectedPeripherals];
        }
    }
    
}

-(void)connectPeripheral:(CBPeripheral*)peripheral
{

    NSDictionary* connectOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];

//NSLog(@"Connecting to tag %@...", [tag name]);
    [_bleManager connectPeripheral:peripheral options:connectOptions];

}
//
//
//
//-(int)connectFinders{
//    
//    [[AppDelegate getAudioPlayer ] stop ];
//    int count = 0;
//    for (int i=0; i < [ AppDelegate getManager].nBleFinders.count; i++) {
//        BleFinder * device = (BleFinder *)[ [ AppDelegate getManager].nBleFinders objectAtIndex:i];
//        
//        CBPeripheral * peripheral = [ device getPeripheral ];
//        
//        if(peripheral != nil)
//        {
//            count ++;
//            [self connectPeripheral:peripheral ];
//        }
//        
//        
//    }
//    
//    return count;
//    
//}






- (void)initFinderData
{
    
    BleFinder *finder1;
    
    finder1 = [[ BleFinder alloc] init];
    finder1.finderType = FINDER_TYPE_KEYS;
    finder1.status = FINDER_STATUS_LINKLOSS;
    
    [ self.nFinders addObject:finder1 ];
    
    BleFinder *finder2;
    finder2 = [[ BleFinder alloc] init];
    finder2.finderType = FINDER_TYPE_BAG;
    finder2.status = FINDER_STATUS_NEAR;
    
     [ self.nFinders addObject:finder2 ];
    
    BleFinder *finder3;
    finder3 = [[ BleFinder alloc] init];
    finder3.finderType = FINDER_TYPE_WALLET;
    finder3.status = FINDER_STATUS_FAR;
    
    [ self.nFinders addObject:finder3 ];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [ self.nFinders count ];
}


//静音开关，目前只把当成一个开关
-(IBAction)connectSwitchAction:(id)sender {
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    
    
    UITableViewCell* cell= [Utils getCellBySender:sender ];
    
    UIImageView * image = (UIImageView *)[ cell viewWithTag:106 ];
    
    
    
    [ image setHidden:isButtonOn ];
    
    NSIndexPath* indexPath= [self.tableView indexPathForCell:cell];
    
    self.currentLine = indexPath.row; //取得当前行
    
    BOOL isMute =!isButtonOn;
    
    BW_INFO_LOG(@" row %d set Mute %d",self.currentLine,isMute);
    
    
    [[AppDelegate getManager] setFinderMute:indexPath.row mute:isMute ];
    
    
    
    
//    if(isButtonOn)
//        [self.bleManager cancelPeripheralConnection:peripheral];
//    else
//        [self.bleManager connectPeripheral:peripheral options:nil];
    
    

}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex{
//    NSString *string=[NSString stringWithFormat:@"你点击了 %@,%d",[actionSheet buttonTitleAtIndex:buttonIndex],buttonIndex];
//    [ self.view makeToast:string
//                 duration:3.0
//                 position:@"bottom"
//                   ];
    
    if([self isDemoMode]){
        if(buttonIndex == 0){
            //[self dismissModalViewControllerAnimated:YES ]; //'dismissModalViewControllerAnimated:' is deprecated: first deprecated in iOS 6.0
            
            [self dismissViewControllerAnimated:YES completion:nil];

           // [self.delegate showBorderDetectionView];

        }
    }
    
}


    
    
-(IBAction) funcClicked:(id)sender {
    
    if([self isDemoMode]){
         [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
       [self performSegueWithIdentifier:@"newDevice" sender:self];
    }
    
   
    
}



-(IBAction) refreshClicked:(id)sender{
    [ self scanBleFinder ];
}

-(void) showMessage:(NSString *)title {
    
//    if(finder.mute ==YES){
//        return;
//    }
  //  NSString * title = [ NSString stringWithFormat:@"%@%@%@", @"bwRange 标签 ",[ finder getName ],@"抱警."];
    
    
    [ self.view makeToast:title
                 duration:3.0
                 position:@"bottom"
                    image:[UIImage imageNamed:@"leash_default_icon_bg"]];
}

-(void) showAlarmMessage:(BleFinder *)finder {
    
   
      NSString * title = [ NSString stringWithFormat:@"%@%@%@", @"bwRange 标签 ",[ finder getName ],@"抱警."];
    
    [self showMessage:title];
    
}

-(IBAction) disconnectClicked:(id)sender {
    UITableViewCell* cell= [Utils getCellBySender:sender ];
    NSIndexPath* indexPath= [self.tableView indexPathForCell:cell];
    
    BW_INFO_LOG(@"断线 %d",indexPath.row);
    
     BleFinder *finder = [ self.nFinders objectAtIndex:indexPath.row];
    
    NSString * title = [NSString stringWithFormat:@"确定断开%@?",[finder getName]];
    
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"断开", nil];
    
    alert.tag = 1;
    [alert show];
}

-(IBAction) AlarmClicked:(id)sender {
    
    
   
    UITableViewCell* cell= [Utils getCellBySender:sender ];
    NSIndexPath* indexPath= [self.tableView indexPathForCell:cell];
    
    
    BW_INFO_LOG(@"报警 row %d",indexPath.row);
    
     BleFinder *finder = [ self.nFinders objectAtIndex:indexPath.row];
    
    
    
    
    
   
    if ( [self isDemoMode ])
    {
    
        NSString * title = [ NSString stringWithFormat:@"%@%@%@", @"bwRange 标签 ",[ finder getName ],@"发出哔的声音."];
    
    
        [ self.view makeToast:title
                duration:3.0
                position:@"bottom"
                   image:[UIImage imageNamed:@"leash_default_icon_bg"]];
    }
    else{
        
        CBPeripheral * perpheral = [finder getPeripheral ];
        
        DLog(@"AlarmClicked %@",perpheral);
        
        if( /*(perpheral== nil) ||*/ ![perpheral isConnected]){
            //[ self scanBleFinder ]  ;
            
             [self connectPeripheral:perpheral];
            
   //         [self.bleManager connectPeripheral:<#(CBPeripheral *)#> options:<#(NSDictionary *)#>]
            
            
            BW_INFO_LOG(@"强制重新扫描");
           // [ self showMessage:[ NSString stringWithFormat:@"%@未联接",[ finder getName ] ]];
            
            [self.tableView reloadData];
            return ;
        }
        
        
        
         BW_INFO_LOG(@"报警 %@,%@",[ finder getName ],[finder UUID ]);
        UIButton * checkbox = (UIButton *)sender;
        if(checkbox.tag == 0){
            [checkbox setSelected:YES];
            checkbox.tag = 1;
            [ finder trigeFinderAlert:YES ];
        }
        else {
            [checkbox setSelected:NO];
            checkbox.tag = 0;
            [ finder trigeFinderAlert:NO ];
        }
        //调用蓝牙发送函数
       
        
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Finder";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    BleFinder *finder = [ self.nFinders objectAtIndex:indexPath.row];
    
    
    
    UIImageView * ImageView = (UIImageView *)[cell viewWithTag:101];
    
  
    ImageView.image = [finder getImage ];
    
    UILabel *label = (UILabel *)[cell viewWithTag:102];
   
    [ label setText:[finder getName ]];
    

    
  //  UIImageView * ImageState = (UIImageView *)[cell viewWithTag:104];
  
   // ImageState.image = [finder getStatusImage];
    
    UIButton * btnDisconnect = (UIButton *)[cell viewWithTag:104];
    
   
    
     [btnDisconnect setImage:[finder getStatusImage] forState:UIControlStateNormal];
    
    UIButton * button = (UIButton *)[cell viewWithTag:105];
    
  //  [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //加入长按处理
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(btnLongPress:)];
    
    
    
    longPress.minimumPressDuration = 0.5; //定义按的时间
     [button addGestureRecognizer:longPress];
    
    UISwitch * connectSwitch = (UISwitch *)[cell viewWithTag:103];
     [connectSwitch addTarget:self action:@selector(connectSwitchAction:) forControlEvents:UIControlEventValueChanged];
    
    
    return cell;
}

-(void)btnLongPress:(UILongPressGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan) {
        DLog(@"长按事件");
        
        UITableViewCell* cell= [Utils getCellBySender:gestureRecognizer.view ];
        NSIndexPath* indexPath= [self.tableView indexPathForCell:cell];
        
        self.currentLine = indexPath.row;
        
        BleFinder * finder = [[AppDelegate getManager] getFinderByIndex:self.currentLine ];
        
        NSString * title = [NSString stringWithFormat:@"确定断开%@?",[finder getName]];
        
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"消息" message:title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"断开", nil];
        
        alert.tag = 1;
        [alert show];
    }
}

#pragma mark - CoreBluetooth Delegate

//开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            BW_INFO_LOG(@"蓝牙已打开,请重联或检测外设");
            
            if(![[AppDelegate getManager] isDemoMode]){
             //[self retrieveKnownPeripherals];
            //检测已经联接
            if([[AppDelegate getManager] checkConnectedDevices:[self bleManager] ] > 0){
                [ [AppDelegate getManager] connectFinders:[self bleManager]];
                //[_bleManager retrieveConnectedPeripherals];
            }
            
        //if([[AppDelegate getManager] isNeedScan])
                [ self scanBleFinder ];
            }
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
    
    BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
    [ finder setDevRSSI:RSSI];
    
    if(![[ AppDelegate getManager] isNeedScan ])
    {
        [ self stopScan ];
        
       // [ self connectFinders];
        [[ AppDelegate getManager] connectFinders:self.bleManager];
    }
    
}

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
     BW_INFO_LOG(@"成功连接 peripheral: %@ with UUID: %@",peripheral,[peripheral.identifier UUIDString]);
    
    BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
    
    [finder showSerivces];
    
    [peripheral setDelegate:self];
    
    [finder didConnect:peripheral];
    
       BW_INFO_LOG(@"开始扫描设备service");
    
}

- (void) centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
    if (!finder) {
        NSLog(@"Disconnected %@, but couldn't find a tag for this peripheral. Will not reconnect.", [peripheral name]);
        return;
    }
  //  [_delegate didUpdateData:tag];
   // [tag didDisconnect];
    
    NSLog(@"didDisconnectPeripheral %@",peripheral);
    
    [finder didDisconnect];
    
   
    
    NSLog(@"Did disconnect peripheral, %@ with error %@. Trying to reconnect...", [peripheral name], error);
    
    [self connectPeripheral:peripheral];
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}


//由CBPeripheral readRssi 触发
-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
     [ finder setDevRSSI:peripheral.RSSI];
       BW_INFO_LOG(@"%@ 状态 ，%d",[finder getName],finder.status );
    
    
    
      [ self.tableView reloadData ];
    
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    BW_INFO_LOG(@"RSSI %@更新:%f,距离:%.1fm",[finder getName],[ peripheral.RSSI floatValue ] ,pow(10,ci));
    
     NSLog(@"RSSI %@更新:%f,距离:%.1fm",[finder getName],[ peripheral.RSSI floatValue ] ,pow(10,ci));
    
   
   }
//已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    BW_INFO_LOG(@"发现服务.");
    
    BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
    
    

    int i=0;
    for (CBService *s in peripheral.services) {
        [finder.nServices addObject:s];
    }
    for (CBService *s in peripheral.services) {
        BW_INFO_LOG(@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID);
        i++;
        //开始查找服务中属性
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    BW_INFO_LOG(@"发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID);
    
     BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
    
    for (CBCharacteristic *c in service.characteristics) {
        BW_INFO_LOG(@"特征 UUID: %@ (%@)",c.UUID.data,c.UUID);
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUID_SERIVCE_ALERT_LEVEL]] && [c.UUID isEqual:[CBUUID UUIDWithString:UUID_PROPERTY_ALERT_LEVEL]]) {
            finder.linkLossAlertLevelCharacteristic = c; //警告触发按钮
        }
        
        if ([service.UUID isEqual:[CBUUID UUIDWithString:UUID_SERIVCE_KEY_PRESS_STATE]] &&   [c.UUID isEqual:[CBUUID UUIDWithString:UUID_PROPERTY_KEY_PRESS_STATE]]) {
            //订阅设备按钮值
            [peripheral setNotifyValue:YES forCharacteristic:c];
            finder.keyPressCharacteristic = c; //远程按钮
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:UUID_PROPERTY_BATTERY_LEVEL]]) {
            finder.batteryLevelCharacteristic = c;
            [peripheral readValueForCharacteristic:c];
        }
//
//        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
//            [peripheral readRSSI];
//        }
       
        
        [ finder.nCharacteristics addObject:c];
    }
}


//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // BOOL isSaveSuccess;
     BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
    
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_PROPERTY_BATTERY_LEVEL]]) {
       // NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
       
        char batlevel;
        [characteristic.value getBytes:&batlevel length:TI_KEYFOB_LEVEL_SERVICE_READ_LEN];
        
        finder.batteryValue = batlevel;
        BW_INFO_LOG(@"电量 %@,%f",characteristic.value,finder.batteryValue);
        
     
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:UUID_PROPERTY_KEY_PRESS_STATE]]){
        NSLog(@"value %@",characteristic.value);
       
        char keys;
        [characteristic.value getBytes:&keys length:TI_KEYFOB_KEYS_NOTIFICATION_READ_LEN];
        
//        if (keys & 0x01) self.key1 = YES;
//        else self.key1 = NO;
//        if (keys & 0x02) self.key2 = YES;
//        else self.key2 = NO;
       

        [self handleRemoteKey:finder key:keys];
    }
    else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        //_batteryValue = [value floatValue];
      //  NSLog(@"信号%@",value);
    }
    
    
        BW_INFO_LOG(@"读取属性%@ %@",characteristic,[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
}

//中心读取外设实时数据
//它由特征的值用setNotifyValue:forCharacteristic: 触发，更新后，外设就会通知它的delegate。
//外设的 delegate 就会接收到

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        BW_INFO_LOG(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        BW_INFO_LOG(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.bleManager cancelPeripheralConnection:peripheral];
    }
}
//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"发送失败=%@%@",characteristic,error.userInfo);
    }else{
        BW_INFO_LOG(@"发送数据成功 %@",characteristic);
        
         BleFinder * finder = [[ AppDelegate getManager] getFinder:peripheral];
        
        // If we have successfully written something, bonding has been successful
        if (finder.state == PROXIMITY_TAG_STATE_BONDING)
        {
            [finder setState:PROXIMITY_TAG_STATE_BONDED];
        }
    }
}

- (void) centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    //    for (CBPeripheral* p in peripherals){
    //
    //    }
    
    // [AppDelegate getManager] scanedDevice:<#(CBPeripheral *)#>
    
    BW_INFO_LOG(@"centralManager didRetrievePeripherals %@",peripherals);
    
    for (CBPeripheral *peripheral in peripherals){
        DLog(@" didRetrievePeripherals %@",peripheral);
    }
}





-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"FinderStatus"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
       // NSDictionary *device = [ self.nDevices objectAtIndex:indexPath.row];
        
        BleFinder * finder = [[ AppDelegate getManager].nBleFinders objectAtIndex:indexPath.row ];
        
        FinderStatusViewController *destViewController = segue.destinationViewController;
        
        
        destViewController.bleFinder = finder;
    }
}

-(void)handleRemoteKey:(BleFinder *)finder key:(int)key{
    BW_INFO_LOG(@"远程按键 %d",key);
    
//    if( finder.isFirstRemoteKey ==YES)
//    {
//        finder.isFirstRemoteKey =NO; //每次重启都会收到上一次联接的远程按键，只能用软件逻辑去掉。
//        return ;
//    }
    
    switch(key){
        case REMOTE_KEY_ALERT_START:
            [ self showAlarmMessage:finder ];
            [ finder startLocalAlarm ];
            
           
           
            break;
        case REMOTE_KEY_ALERT_STOP:
            [ finder stopLocalAlarm ];
            
          
            break;
            
        case REMOTE_KEY_ALERT_CAMERA:
            
        {
            
           CustomImagePickerController * ctrl =  (CustomImagePickerController *)([ AppDelegate sharedInstance].cameraView);
            
            
            if(ctrl != nil)
            {
               
                
                [ ctrl takePicture ];
            }
        
        else
        {
            
//          UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"请打开照机" message:@"需手工打照相机，并长按后拍照" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//                
//                [dialog show];
            
            
//
              CameraViewController * view =  [ Utils getOtherPageController:self index:MAIN_TAB_CAMERA];
            
               view.needTake = YES;
            
               MAIN_TAB_CONTROLLER.selectedIndex = MAIN_TAB_CAMERA;
            
            [ view showCameraView];
            
            }
        }
        break;
    }
}
#pragma mark -- Finder Notitfy

- (void) showFailedConnectDialog:(BleFinder*) finder
{
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"物品联接失败" message:[NSString stringWithFormat:@"无法联接到 %@. \n\n可能是断线或超出范围.", [ finder getName ]] delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    
    dialog.tag = 2;
    
    [dialog show];
    
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.alertBody = [NSString stringWithFormat:@"> %@ 断线.", [ finder getName ] ];
    alarm.alertAction = @"确定";
    
    
    
    
    
    
    int number = 1;
    
    alarm.soundName = @"alarm-sound.wav";
    alarm.applicationIconBadgeNumber = number;
    
    
    
    // alarm.soundName = UILocalNotificationDefaultSoundName;
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
    
   
    // [[UIApplication sharedApplication] setApplicationIconBadgeNumber:number];
    
//    if(finder.vibrate == YES)
//        [Utils playVibrate];
//    [[AppDelegate getAudioPlayer ] play ];
    
    [ finder startLocalAlarm ];
}

- (void) showOutOfRangeDialog:(BleFinder*) finder
{
   // if (alertLevel != PROXIMITY_TAG_ALERT_LEVEL_NONE)
    {
        UILocalNotification *alarm = [[UILocalNotification alloc] init];
        alarm.alertBody = [NSString stringWithFormat:@"%@ 已经超过范围.", [ finder getName ] ];
        alarm.alertAction = @"确认";
        
//        if (alertLevel == PROXIMITY_TAG_ALERT_LEVEL_HIGH)
//        {
//            alarm.soundName = @"alarm-sound.wav";
//        }
//        else
//        {
//            alarm.soundName = UILocalNotificationDefaultSoundName;
//        }
        
         [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
        
   //     [ finder startLocalAlarm ];
        
//        if(finder.vibrate == YES)
//            [Utils playVibrate];
//        
//       
//        
//        [[AppDelegate getAudioPlayer ] play ];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   // NSLog(@"clickButtonAtIndex:%d",0);
    if(alertView.tag == 1)
    {
        
        BleFinder * finder = [[ AppDelegate getManager] getFinderByIndex:self.currentLine];
        
        
        
        CBPeripheral * per = [finder getPeripheral];
        
        if(per!=nil){
            [ per setDelegate:self];
            
         [self.bleManager cancelPeripheralConnection:per];
            
            DLog(@"Disconnect device %@!!!",per);
            
        }
    }
    else if(alertView.tag == 2){
         BleFinder * finder = [[ AppDelegate getManager] getFinderByIndex:self.currentLine];
        
        [ finder stopLocalAlarm];
     // [[AppDelegate getAudioPlayer ] stop ];
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView
{
    NSLog(@"alertViewCancel");
}

-(void) FinderStateNotifyDelegateAction:(BleFinder* ) finder state:(int)state{
    
     [self.tableView reloadData];
    
    switch(state){
        case   FINDER_NOTIFY_CONNECT :
           
            break;
        case   FINDER_NOTIFY_FAIL :
            [self showFailedConnectDialog:finder];
            break;
        case   FINDER_NOTIFY_OUTRANGE :
            [self showOutOfRangeDialog:finder];
            break;
            
            
    }
}





//回退事件

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//    [self.tableView reloadData ];
//}
//
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated;
//{
//    [self.tableView reloadData ];
//
//    
//}





/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/





@end
