//
//  DataManager.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-19.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "DataManager.h"
#import "BleFinder.h"
#import "Utils.h"

#import "LogViewController.h"

#import "SystemAudioPlayer.h"

#define FINDER_PLIST_NAME @"Finders.plist"

@interface DataManager ()

@property  BOOL isDemoData; //演示数据
@property  BOOL isModify; // 数据被修改，这样让界面重新联接

@end

@implementation DataManager



-(id) init{
    
    if (self=[super init]) {
       
        self.nBleFinders = [NSMutableArray arrayWithCapacity:0];
        
        
        [self load];
        
    }
    
    return self;
    
}

-(BOOL) isFinderPlistExists{
   return [Utils isSandboxFileExists:FINDER_PLIST_NAME];
}

-(NSString * )getFindersPlistPath{
    
    return [Utils getSandboxFilePath:FINDER_PLIST_NAME];
    //可以在沙盒中，
//    NSArray * appPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [appPaths objectAtIndex:0];
//    
//    return [documentsDirectory stringByAppendingString:@"/Finders.plist"];
    
    //也能在bundle中
   // return[[NSBundle mainBundle] pathForResource:@"Finders" ofType:@"plist"];
}
-(int)loadFinders{
    
    [ self.nBleFinders removeAllObjects];
    self.isDemoData = NO;
    
    NSMutableArray * temp = [Utils readFromSandboxFile:FINDER_PLIST_NAME];
    if((temp == nil) || (temp.count <=0) ){
        self.isDemoData = YES;
        
        NSString * plistPath = [[NSBundle mainBundle] pathForResource:@"DemoFinders" ofType:@"plist"];
        
        temp = [NSMutableArray arrayWithContentsOfFile:plistPath ];
    }
    
    DLog(@"finder plist %d :\n%@",temp.count,temp);
    
    for (NSDictionary *dic in temp){
        BleFinder * finder = [[ BleFinder alloc] init];
        
        [finder initWithDictionary:dic];
        
        finder.ringtone = [self getRingtone:[dic objectForKey:@"RINGTONE"]];
        
        
        [ self.nBleFinders addObject:finder];
        
        
    }
    
    self.isModify = YES;
    
    return temp.count;
    
}

-(int)loadFindersOld{
    
    [ self.nBleFinders removeAllObjects];
    
   //在应用中有一个空文件Finders.plist
    
    NSString *plistPath = [ self getFindersPlistPath ];
    if(plistPath == nil)
        return -1;
    
    self.isDemoData = NO;
    
    NSMutableArray * temp = [NSMutableArray arrayWithContentsOfFile:plistPath ];
    
    DLog(@"finder count %d,plist:%@",temp.count,temp);
    
    //if (![[NSFileManager defaultManager] fileExistsAtPath:plistPath])
    if(temp.count <=0)
    {
        //不存在，进入演示模式
        self.isDemoData = YES;
        
        plistPath = [[NSBundle mainBundle] pathForResource:@"DemoFinders" ofType:@"plist"];
        
        temp = [NSMutableArray arrayWithContentsOfFile:plistPath ];
        
    }
    
   
   
    
    for (NSDictionary *dic in temp){
        BleFinder * finder = [[ BleFinder alloc] init];
        
        [finder initWithDictionary:dic];
        
        finder.ringtone = [self getRingtone:[dic objectForKey:@"RINGTONE"]];
        
        
        [ self.nBleFinders addObject:finder];
        
        
    }
    
//    NSMutableArray *  temp3 = [NSMutableArray arrayWithCapacity:0];
//    
//    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"近",@"text", nil];
//    
//    [ temp3 addObject:dic];
//    
//    [Utils writeToSandboxFile:@"Finders2.plist" withData:temp3];
//    //NSMutableArray *  temp2 = [NSMutableArray arrayWithContentsOfFile:@"Finders2.plist" ];
//    
//    NSMutableArray *  temp2 = [Utils  readFromSandboxFile:@"Finders2.plist"  ];
//    
//    DLog(@"test file %@",temp2);
    
    
    
    
    
    

    
    
    return 0;
}

- (BOOL) removeFinder:(BleFinder *)finder{
    if([self isDemoMode])
        return NO;
    
     [ self stopRangeMonitoring ];
    
    NSLog(@"removeFinder befor %@",self.nBleFinders);
    
    [self.nBleFinders removeObject:finder];
    
    [self saveFinder ];
    
     NSLog(@"removeFinder after %@",self.nBleFinders);
    
    if(self.nBleFinders.count <= 0)
    {
        self.isDemoData = YES;
        [self loadFinders ];
        
    }
    
     [ self startRangeMonitoring ];
    
    self.isModify = YES;
    return YES;
}



-(int)loadFinderTypes{
     return 0;
}
-(int)loadRingtones{
    
     [ self.nRingtones removeAllObjects];
    
    NSString *fielPath = [[NSBundle mainBundle] pathForResource:@"Ringtones" ofType:@"plist"];
    self.nRingtones = [NSMutableArray arrayWithContentsOfFile:fielPath];
    
//    for (NSMutableDictionary *dic in self.nRingtones){
//        [dic setObject:[UIImage imageNamed:@"icon_bag"] forKey:@"image"];
//        
//    }
    
    //考虑与showList的兼容。可以直接联接
    
    NSLog(@"(%d),%@",self.nRingtones.count,self.nRingtones);
    
    
    
    
    
    return self.nRingtones.count;
    

}

-(NSDictionary * )getRingtone:(NSString *)toneId
{
    for (NSDictionary *tone in self.nRingtones){
        NSString * tmp = [ tone objectForKey:@"id"];
        if( [toneId isEqualToString:tmp] ){
            return tone;
        }
    }
             
    return nil;
}



-(void)load{
    //test
    
    
    
     [self   loadFinders     ];
     [self  loadFinderTypes ];
     [self  loadRingtones   ];
    
   
    
}

-(BOOL)isDemoMode{
    return  (self.isDemoData);
}

- (int) addFinder:(BleFinder *)finder{
    
    if( [self isDemoMode]){
        
        [self.nBleFinders removeAllObjects];
        
        self.isDemoData = NO;
    }
    
   // BleFinder * newFinder = [ finder copy]; //必须要实现 copyWithZone;
    
    [self.nBleFinders addObject:finder];
    
    self.isModify = YES;
    
    
    return (self.nBleFinders.count - 1);
}

- (void) saveFinder{
    
    
    if([self isDemoMode] == YES)
        return ;
    
    NSMutableArray * findersArray = [NSMutableArray arrayWithCapacity:4];
    
    for (BleFinder * f in self.nBleFinders){
        
        NSDictionary *dic = [ f newDict ];
        
        [ findersArray addObject:dic];
        
        
    }
    
    [Utils writeToSandboxFile:FINDER_PLIST_NAME withData:findersArray];
    
   // [ self loadFinders ];
    
    
}

//将设备相关信息清除
-(void) resetFinders{
    self.scanCount = 0;
    for (int i=0; i < self.nBleFinders.count; i++) {
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        NSLog(@"Reset %@",device);
        [device reset];
    }
    
}

//扫描到BLE设备，并检测是否防丢品，返回值，表示是防丢器
-(BOOL) scanedDevice:(CBPeripheral *)peripheral{
    
    for (int i=0; i < self.nBleFinders.count; i++) {
        
         NSString * newUUID = [ peripheral.identifier UUIDString ];
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        DLog(@"scanedDevice %@, per %@",device,peripheral);
        
        CBPeripheral * oldPer= [ device getPeripheral];
        if(oldPer!= nil){
            DLog(@"scanedDevice old device %@",peripheral);
        }
        
        NSString * uuid = device.UUID;
        
        
        if ([ uuid isEqual:newUUID]) {
            
            [device setPeripheral:peripheral ];
            
            self.scanCount ++;
            
            return YES;
        }
    }
    return NO;
}

//所有设备都扫描到
-(BOOL) isAllScaned{
    return (self.scanCount == self.nBleFinders.count);
}

-(BleFinder *)getFinderOld:(CBPeripheral *)peripheral{
    for (int i=0; i < self.nBleFinders.count; i++) {
        
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        if([ peripheral isEqual:[ device getPeripheral]])
            return device;
    }
    
    return nil;
}
-(BleFinder *)getFinder:(CBPeripheral *)peripheral{
    return [ self queryFinder:[ peripheral.identifier UUIDString ]];
}

-(BleFinder *)queryFinder:(NSString *)UUIDString{
    for (int i=0; i < self.nBleFinders.count; i++) {
        
       
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        DLog(@"%@,",device);
        
        NSString * uuid = device.UUID;
        
        
        if ([ uuid isEqual:UUIDString]) {
            
            return device;
        }
    }
    return nil;
}

-(int)queryFinderIndex:(NSString *)UUIDString{
    for (int i=0; i < self.nBleFinders.count; i++) {
        
        
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        DLog(@"%@,",device);
        
        NSString * uuid = device.UUID;
        
        
        if ([ uuid isEqual:UUIDString]) {
            
            return i;
        }
    }
    return -1;
}



-(int)replaceFinder:(BleFinder *)finder{
    int pos = [self queryFinderIndex:finder.UUID];
    
    if(pos >= 0){
        [self.nBleFinders replaceObjectAtIndex:(NSInteger)pos withObject:finder];
        //self.isModify = YES;
        return pos;
    }
    else
    {
       return  [self addFinder:finder];
    }
}

- (void)startDetect{
    
}

-(BOOL) isNeedRescan{
    
    if(self.isModify)
    {
        self.isModify = NO;
        return YES;
    }
    
    return NO;
}

-(BOOL)setFinderMute:(int)row mute:(BOOL)mute{
    if( (row < 0 ) || (row >= self.nBleFinders.count))
        return NO;
    BleFinder * finder = [self.nBleFinders objectAtIndex:row];
    if( finder.mute ==  mute )
        return NO;
    
    
    
    
    finder.mute =  mute ;
    self.isModify = YES;
    return YES;
    
    
}

-(void)setDelegate:(id<FinderStateNotifyDelegate>)delegate{
    for (int i=0; i < self.nBleFinders.count; i++) {
        
        
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        device.delegate = delegate;
    }
}

-(BleFinder *)getFinderByIndex:(int)index{
    return (BleFinder *)[ self.nBleFinders objectAtIndex:index];
}

//检测在打开应用前是否已经联接，返回值为联接数量
-(int)checkConnectedDevices:(CBCentralManager *)bleManager {
    NSMutableArray * Identifiers = [NSMutableArray array];
    
    
    for (int i=0; i < self.nBleFinders.count; i++){
        
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        NSUUID * identifier =  [[NSUUID alloc]initWithUUIDString: [ device UUID ]];
        
       [Identifiers addObject:identifier];
    }
    
    
    int count = 0;
    
  //  [self addLog:@"[self.cbCentralMgr retrievePeripheralsWithIdentifiers:self.PeripheralIdentifiers]"];
    NSArray * retrievePeripherals = [ bleManager retrievePeripheralsWithIdentifiers:Identifiers];
    
    for (CBPeripheral* peripheral in retrievePeripherals) {
        BW_INFO_LOG(@"检测到设备%@ name:%@ 已经配对",peripheral.name,peripheral);
        if([self scanedDevice:peripheral]){
           // DLog(@"检测到设备已经联接 %@ ",peripheral);
            count++;
        }
        
        
    }
    
    return count;

}
//判断是否需要打开BLE扫描
-(BOOL)isNeedScan{
    
   
        
    for (int i=0; i < self.nBleFinders.count; i++){
         BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        if( ([ device getPeripheral] == nil) )
            return YES;
        
        
    }
    
    return NO;
}

-(int)connectFinders:(CBCentralManager *)bleManager{
    
      NSDictionary* connectOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
    
    int count ;
    
    for (int i=0; i < self.nBleFinders.count; i++){
        BleFinder * device = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        CBPeripheral * per = [ device getPeripheral];
        if( ( per!= nil) ){
             BW_INFO_LOG(@"联接设备%@ name:%@ ",per.name,per);
//            if( [per isConnected]){
//                   [device didConnect:per];
//            }
//            else
                [ bleManager connectPeripheral:per options:connectOptions ];
            count++;
        }
            
        
        
    }
    
    return count;
}

-(void)readConnect{
    for(int i = 0 ; i < self.nBleFinders.count ; i++){
        
        BleFinder * finder = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        CBPeripheral * per = [ finder getPeripheral];
        if(per == nil)
            continue;
    
        if([per isConnected])
            [finder readRSSI ];
        
            
        
    }
}

-(void) readLinkLossAlert{
    
    for(int i = 0 ; i < self.nBleFinders.count ; i++){
        
        BleFinder * finder = (BleFinder *)[ self.nBleFinders objectAtIndex:i];
        
        CBPeripheral * per = [ finder getPeripheral];
        if(per == nil)
            continue;
        
        if([per isConnected])
            [finder readLinkLossAlert ];
        
        
        
    }
}
//开始进行
- (void) startRangeMonitoring
{
 
    NSLog(@"Start range monitoring of ");
    //self.rssiThreshold = [self getRssiRange];
    //NSLog(@"Starting range monitoring of %@,targe rssi %f", [self getName],self.rssiThreshold);
    
    
    
    [self.rssiTimer invalidate];
    //直接调用CBPeripheral readRssi 读取信号强度，如果没有联接，将自动联接。
    self.rssiTimer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(readConnect)    userInfo:nil repeats:YES];
    
    
    [[NSRunLoop currentRunLoop] addTimer:self.rssiTimer forMode:NSRunLoopCommonModes];
 
    
    //读远程按键定时器
    [self.readTimer invalidate];
    self.readTimer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(readLinkLossAlert) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.readTimer forMode:NSRunLoopCommonModes];
}

- (void) stopRangeMonitoring
{
    NSLog(@"Stopping range monitoring of ");
    [self.rssiTimer invalidate];
    [self.readTimer invalidate];
}


@end
