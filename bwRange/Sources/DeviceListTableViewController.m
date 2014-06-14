//
//  DeviceListTableViewController.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-10.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "DeviceListTableViewController.h"
#import <CoreBluetooth/CoreBluetooth.h>

#import "NewDeviceViewController.h"

@interface DeviceListTableViewController ()



@end

@implementation DeviceListTableViewController

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
    
    
    //采用iOS6 的自带的UIRefreshControl控制下拉刷新
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor lightGrayColor];
    //refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to Refresh"] ;
    [refresh addTarget:self action:@selector(refreshView:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    
    self.count = 0;
    //没有这一句，无法加入记录
    self.nDevices = [NSMutableArray arrayWithCapacity:16];
   
    
     //创建蓝牙服务
     self.manager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    
}

-(void)handleData
{
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMM d, h:mm:ss a"];
//    NSString *lastUpdated = [NSString stringWithFormat:@"Last updated on %@", [formatter stringFromDate:[NSDate date]]];
//    
//    
//    self.refreshControl.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated] ;
//    self.count++;
//    
//    
//    NSString *rowString = [NSString stringWithFormat:@"%d.keyfob updated on %@", self.count,[formatter stringFromDate:[NSDate date]]];
//    
//    [self.nDevices addObject:rowString];
//    
//    DLog("@handleData String %@ ,count %d",rowString,self.nDevices.count);
//    
//    [self.refreshControl endRefreshing];
//    [self.tableView reloadData];
}


-(void)refreshView:(UIRefreshControl *)refresh
{
    if (refresh.refreshing) {
        refresh.attributedTitle = [[NSAttributedString alloc]initWithString:@"正在查找设备..."] ;
        
        //开始扫描
        [self scanClick ];
        
      //  [self performSelector:@selector(handleData) withObject:nil afterDelay:0];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//扫描
-(void)scanClick
{
    [self updateLog:@"正在扫描外设..."];
    //[_activity startAnimating];
    
    //扫描BLE设备
    [ self.manager scanForPeripheralsWithServices:nil options:@{CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
    
    //30.0 秒超时定时器
    double delayInSeconds = 30.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.manager stopScan];
        [self.activity stopAnimating];
        [self updateLog:@"扫描超时,停止扫描"];
    });
}

-(void)updateLog:(NSString *)s
{
    // [_textView setText:[NSString stringWithFormat:@"[ %d ]  %@\r\n%@",count,s,_textView.text]];
  //  NSString * tmp = [ NSString stringWithFormat:@"[ %d ]  %@\r\n",count,s] ;
    DLog(@"%@",s);

}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    DLog(@"tableView self.nDevices.count %d,count %d",self.nDevices.count,self.count);
    return self.nDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
  //  cell.textLabel.text = [self.nDevices objectAtIndex:indexPath.row];
    
    NSDictionary *device = [ self.nDevices objectAtIndex:indexPath.row];
    CBPeripheral *p = [device objectForKey:@"peripheral"];
    cell.textLabel.text = p.name;

    cell.textLabel.font = [UIFont systemFontOfSize:17];
    
    return cell;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"已扫描到的设备:";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.refreshControl beginRefreshing];
}


//蓝牙打开 开始查看服务，蓝牙开启
-(void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            [self updateLog:@"蓝牙已打开,请扫描外设"];
            break;
        default:
            break;
    }
}

//查到外设后的处理事件，停止扫描，连接设备
-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    [self updateLog:[NSString stringWithFormat:@"已发现 peripheral: %@ rssi: %@, UUID: %@ advertisementData: %@ ", peripheral, RSSI, peripheral.identifier, advertisementData]];
    self.peripheral = peripheral;
    DLog(@"%@",self.peripheral);
    [self.manager stopScan];
    //[_activity stopAnimating];
    
    NSDictionary *device;
    
    device = [NSDictionary dictionaryWithObjectsAndKeys:
                    peripheral, @"peripheral",
                    peripheral.identifier, @"uuid",
                    RSSI, @"RSSI",
                    advertisementData, @"advertisementData", nil];

    BOOL replace = NO;
    // Match if we have this device from before
    for (int i=0; i < self.nDevices.count; i++) {
         NSDictionary *dev = [ self.nDevices objectAtIndex:i];
        CBPeripheral *p = [device objectForKey:@"peripheral"];
        if ([p isEqual:peripheral]) {
            [ self.nDevices replaceObjectAtIndex:i withObject:device];
            replace = YES;
        }
    }
    if (!replace) {
        
       //[self performSelector:@selector(handleData) withObject:nil afterDelay:0];
        [ self.refreshControl endRefreshing];
        
        [ self.nDevices addObject:device];
        [ self.tableView reloadData];
    }
}




//向新设备窗口传输数据
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"newDevice"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        NSDictionary *device = [ self.nDevices objectAtIndex:indexPath.row];
        
        NewDeviceViewController *destViewController = segue.destinationViewController;
        
        
        destViewController.bleDevice = device;
    }
}


// TODO: 未测试

//连接外设成功，开始发现服务
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [self updateLog:[NSString stringWithFormat:@"成功连接 peripheral: %@ with UUID: %@",peripheral,peripheral.identifier]];
    
    [self.peripheral setDelegate:self];
    [self.peripheral discoverServices:nil];
    [self updateLog:@"扫描服务"];
    
}
//连接外设失败
-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"%@",error);
}

-(void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(NSError *)error
{
    //NSLog(@"%s,%@",__PRETTY_FUNCTION__,peripheral);
   
    int rssi = abs([peripheral.RSSI intValue]);
    CGFloat ci = (rssi - 49) / (10 * 4.);
    NSString *length = [NSString stringWithFormat:@"发现BLT4.0热点:%@,距离:%.1fm",_peripheral,pow(10,ci)];
    NSLog(@"距离：%@",length);
}
//已发现服务
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    
    [self updateLog:@"发现服务."];
    int i=0;
    for (CBService *s in peripheral.services) {
        [self.nServices addObject:s];
    }
    for (CBService *s in peripheral.services) {
        [self updateLog:[NSString stringWithFormat:@"%d :服务 UUID: %@(%@)",i,s.UUID.data,s.UUID]];
        i++;
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

//已搜索到Characteristics
-(void) peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    [self updateLog:[NSString stringWithFormat:@"发现特征的服务:%@ (%@)",service.UUID.data ,service.UUID]];
    
    for (CBCharacteristic *c in service.characteristics) {
        [self updateLog:[NSString stringWithFormat:@"特征 UUID: %@ (%@)",c.UUID.data,c.UUID]];
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A06"]]) {
            _writeCharacteristic = c;
        }
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
            [_peripheral readValueForCharacteristic:c];
        }
        
        if ([c.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
            [_peripheral readRSSI];
        }
        [_nCharacteristics addObject:c];
    }
}


//获取外设发来的数据，不论是read和notify,获取数据都是从这个方法中读取。
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // BOOL isSaveSuccess;
    
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"2A19"]]) {
        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        self.batteryValue = [value floatValue];
        NSLog(@"电量%f",self.batteryValue);
    }
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFA1"]]) {
        NSString *value = [[NSString alloc]initWithData:characteristic.value encoding:NSUTF8StringEncoding];
        //_batteryValue = [value floatValue];
        NSLog(@"信号%@",value);
    }
    
    else
        NSLog(@"didUpdateValueForCharacteristic%@",[[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding]);
}

//中心读取外设实时数据
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    // Notification has started
    if (characteristic.isNotifying) {
        [peripheral readValueForCharacteristic:characteristic];
        
    } else { // Notification has stopped
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.manager cancelPeripheralConnection:self.peripheral];
    }
}
//用于检测中心向外设写数据是否成功
-(void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if (error) {
        NSLog(@"=======%@",error.userInfo);
    }else{
        NSLog(@"发送数据成功");
    }
}

@end
