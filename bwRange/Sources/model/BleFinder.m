//
//  BleFinder.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-14.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "BleFinder.h"
#import "BleDevice.h"

#import "SharedUI.h"

#import "AppDelegate.h"
#import "Utils.h"

#import "LogViewController.h"

@interface BleFinder()



@end

@implementation BleFinder

-(id) init{

    if (self=[super init]) {
        [ self setType:FINDER_TYPE_BAG ];
         self.status  = FINDER_STATUS_LINKLOSS;
        
        self.range = 5;
        
        self.AlertNotification = [[UILocalNotification alloc]init];
        
        
        _linkLossAlertLevelOnTag = PROXIMITY_TAG_ALERT_LEVEL_HIGH;
        _linkLossAlertLevelOnPhone = PROXIMITY_TAG_ALERT_LEVEL_MILD;
        
        self.isFailAlarm = NO;
        self.isFirstRemoteKey = YES;
        
        self.vibrate = YES;
        self.ringtone = 0;
       
        self.isDeleting = NO;
       
        
        [self reset];
       
        
     }
    
    return self;

}
/*
 @property (nonatomic) int finderType ; //wallet ,bag ...
 @property (nonatomic) int status     ; //
 @property (nonatomic, strong) NSString * UUID ;
 @property (nonatomic) int range     ;
 @property (nonatomic) int sensitivity     ;
 
 @property (nonatomic) bool vibrate     ;
 @property (nonatomic, strong) Ringtone * ringtone  ;
 */

/*
 <key>UUID</key>
 <string>DEMO-UUID-1</string>
 <key>ALARM</key>
 <string>11</string>
 <key>NAME</key>
 <string>Keys</string>
 <key>RANGE</key>
 <string>0</string>
 <key>RINGTONE</key>
 <string>2</string>
 <key>SENSITIVITY</key>
 <string>5</string>
 <key>TYPE</key>
 <string>0</string>
 <key>VIBRATE</key>
 <string>0</string>
 */
-(NSDictionary *)newDict{
    
   
    
   
    NSDictionary * dic =   [NSDictionary dictionaryWithObjectsAndKeys:
                self.UUID,@"UUID", [self getName ],@"NAME",
                 [ NSString stringWithFormat:@"%d",self.range],@"RANGE",[ NSString stringWithFormat:@"%d",self.ringtone],@"RINGTONE",
                [ NSString stringWithFormat:@"%d",self.sensitivity],@"SENSITIVITY",
             [ NSString stringWithFormat:@"%d",self.finderType],@"TYPE",
             [ NSString stringWithFormat:@"%d",self.vibrate],@"VIBRATE" ,nil];
    
    DLog(@"new finder %@",dic);
    
    return dic;

    
    
//    return  [NSDictionary dictionaryWithObjectsAndKeys:
//                  self.UUID,@"UUID",@"公文包",11,@"ALARM", [self getName ],@"NAME",
//                  [ NSString stringWithFormat:@"%d",self.range],@"RANGE",tone,@"RINGTONE",
//                @"5",@"SENSITIVITY",[ NSString stringWithFormat:@"%d",self.finderType],@"TYPE",
//             @"0",@"VIBRATE" ,nil];
    
}

-(NSDictionary *)newDict2{
    
    
    return   [NSDictionary dictionaryWithObjectsAndKeys:@"近",@"text", nil];
    
}

-(NSString *) description{
    return [ NSString stringWithFormat:@"BleFinder:UUID %@, type %d, Name %@,range %d,status %d,rssi %f,distance %f tone %d",self.UUID,self.finderType,[self getName],self.range,self.status , self.rssiLevel,self.distance ,self.ringtone];
}

-(void) initWithDictionary:(NSDictionary *)map{
    
    self.UUID = [map objectForKey:@"UUID"];
    
    NSString * tmp = [map objectForKey:@"TYPE"];
    self.finderType = [tmp intValue];
    
    tmp = [map objectForKey:@"SENSITIVITY"];
    self.sensitivity = [tmp intValue];
    
    
    tmp = [map objectForKey:@"RANGE"];
    self.range = [tmp intValue];
    
    tmp = [map objectForKey:@"MUTE"];
    if([tmp intValue] == 0)
        self.mute = NO;
    else
        self.mute = YES;
    
    tmp = [map objectForKey:@"VIBRATE"];
    if([tmp intValue] == 0)
        self.vibrate = NO;
    else
        self.vibrate = YES;
    
    
    NSLog(@"%@",self);
       
}



+ (UIImage *)imageWithFinderType:(int)type
{
    NSString * imageName ;
    
    switch(type){
        case FINDER_TYPE_BAG: imageName =@"icon_bag"; break;
        case FINDER_TYPE_KEYS: imageName =@"icon_keys"; break;
        case FINDER_TYPE_LAPTOP: imageName =@"icon_laptop"; break;
        case FINDER_TYPE_WALLET: imageName =@"icon_wallet"; break;
            
    }
    
    return [UIImage imageNamed:imageName];
}

+ (NSString  *)stringWithFinderType:(int)type{
    
    
    switch(type){
        default:
        case FINDER_TYPE_BAG: return @"公文包"; break;
        case FINDER_TYPE_KEYS: return @"钥匙"; break;
        case FINDER_TYPE_LAPTOP: return @"笔记本"; break;
        case FINDER_TYPE_WALLET: return @"钱包"; break;
            
    }
}

+ (NSString  *)stringWithFinderDistance:(int)type{
    
    
    switch(type){
        default:
        case FINDER_RANGE_FAR: return @"远"; break;
        case FINDER_RANGE_NEAR: return @"近"; break;
            
            
    }
    
    
}

- (NSString  *)getName{
    return [ BleFinder stringWithFinderType:_finderType ];
    
}
- (UIImage  *)getImage{
     return [ BleFinder imageWithFinderType:_finderType ];
}

-(void) setType:(int)finderType{
    self.finderType = finderType ;
    
}

+ (UIImage *)imageWithStatus:(int)type
{
    NSString * imageName ;
    
    switch(type){
        
       // case FINDER_STATUS_FAR: imageName =@"status_far"; break;
        case FINDER_STATUS_FAR: imageName =@"status_near"; break;
        case FINDER_STATUS_NEAR: imageName =@"status_near"; break;
        case FINDER_STATUS_LINKLOSS: imageName =@"status_linkloss"; break;
            
    }
    
    return [UIImage imageNamed:imageName];
}

- (UIImage  *)getStatusImage{
    return [ BleFinder imageWithStatus:_status ];
}

-(UILocalNotification *)createNotification{
    //本地通知
    UILocalNotification *notification = [[UILocalNotification alloc]init];
    if (notification != nil) {
        NSDate *now = [NSDate new];
        notification.fireDate = [now dateByAddingTimeInterval:10];
        notification.timeZone = [NSTimeZone defaultTimeZone];
        notification.alertBody = @"报警";
        notification.soundName = @"beep1.mp3";
        notification.applicationIconBadgeNumber = 1;
        notification.alertAction = @"关闭";
        
        [[UIApplication sharedApplication]scheduleLocalNotification:notification];
        
    }
    
    return notification;
}

-(void) reset{
    self.status = FINDER_STATUS_LINKLOSS;
    
    
    
    
    
    self.linkLossAlertLevelCharacteristic = nil;
    self.keyPressCharacteristic = nil;
    
     _state = PROXIMITY_TAG_STATE_UNINITIALIZED;
    
    _rssiThreshold = -50.0f;
    _hasBeenBonded = NO;
    
    self.isFirstRemoteKey = YES; //用过过滤，上电后第一个按钮值，这是bug
    
    self.isDisconnecting = NO;
    self.isKeyPress = NO;
}

-(void)setDevRSSI:(NSNumber *)rssi{
    self.rssiLevel = [ rssi floatValue ];
    
    self.distance = [self detectDistance:abs([rssi intValue])];
    
    
  
    if (self.rangeMonitoringIsEnabled && self.isBonded)
    {
        [self handleRSSIReading:self.rssiLevel];
    }
    
//    CGFloat proximity  = [rssi floatValue];
//    if (proximity < -70)
//        self.status  = FINDER_STATUS_FAR;
//    else if (proximity < -55)
//        self.status  = FINDER_STATUS_NEAR;
//    else if (proximity < 0)
//        self.status  = FINDER_STATUS_LINKLOSS;
    
    CGFloat proximity  = abs([rssi floatValue]);
    
    int old_state = self.status;
    
    
        if (proximity == 0)
            self.status  = FINDER_STATUS_LINKLOSS;
        else if (proximity < 82)
            self.status  = FINDER_STATUS_NEAR;
        else if (proximity < 110)
            self.status  = FINDER_STATUS_FAR;
        else
           self.status  = FINDER_STATUS_LINKLOSS;
    
    NSLog(@"setDevRSSI %f (%f) status %d",self.rssiLevel,proximity,self.status);
    
    
    BW_INFO_LOG(@"Finder Status change %d to %d",old_state,self.status);
    
   if(old_state != self.status)
    [self.delegate FinderStateNotifyDelegateAction:self state:FINDER_NOTIFY_CONNECT];
    

    
}

//通知防丢器设备发出警报 start == YES 开始警报， NO 停止
-(void) trigeFinderAlert:(BOOL)start{
    unsigned char data;
    if(start)
        data = ALERT_FINDME; //
    else
        data = ALERT_STOP;
    
    [self findMeTag:data];
}

-(void) findMeTag:(unsigned char)data{
   
    if(self.linkLossAlertLevelCharacteristic == nil)
    {
        DLog(@"设备没有linkloss属性！！");
        return;
    }
        
    [  [ self getPeripheral ] writeValue:[NSData dataWithBytes:&data length:1] forCharacteristic:self.linkLossAlertLevelCharacteristic type:CBCharacteristicWriteWithoutResponse];
}




-(void)startLocalAlarm{

//    if(self.isFailAlarm ==YES)
//        return ;
    
    if(!self.mute)
        //[[AppDelegate getAudioPlayer ] play ];
        
        [[AppDelegate getSystemAudioPlayer ] startById:self.ringtone ];
        
    
    
    if(self.vibrate == YES){
        //[Utils playVibrate];
        
        [[AppDelegate getSystemAudioPlayer ] startVibrate];
        
        //[Utils playSystemSound]; //可以后台播放
    }
    
    
   // self.isFailAlarm =YES;
    
    
    
}

-(void)stopLocalAlarm{
    // [ [UIApplication sharedApplication] cancelLocalNotification:self.AlertNotification  ];
    
    //  if(!self.mute)
    //      [ [AppDelegate getAudioPlayer ] stop];
    
    [[AppDelegate getSystemAudioPlayer ] stop ] ;
    
    [[AppDelegate getSystemAudioPlayer ] stopVibrate ] ;
    
    self.isFailAlarm = NO;
}

#define OUTPUT_RANGE_ALARM_COUNT (1000)
-(void)startOutrangeAlarm{
    if(!self.mute)
        //[[AppDelegate getAudioPlayer ] play ];
        
        [[AppDelegate getSystemAudioPlayer ] startById:self.ringtone repeat:OUTPUT_RANGE_ALARM_COUNT ];
    
       // [[AppDelegate getSystemAudioPlayer ] startById:self.ringtone ];
    
    
    
    if(self.vibrate == YES){
        
        
        [[AppDelegate getSystemAudioPlayer ] playVibrate:OUTPUT_RANGE_ALARM_COUNT];
        
      
    }
    
}

-(void)stopOutrangeAlarm{
    
    
    [[AppDelegate getSystemAudioPlayer ] stop ] ;
    
    [[AppDelegate getSystemAudioPlayer ] stopVibrate ] ;
    
    self.isFailAlarm = NO;
}





-(void)startLocalAlarm2{
    
    DLog(@"start Alarm");
 //UILocalNotification *notification = self.AlertNotification ;
     UILocalNotification *notification = [[UILocalNotification alloc]init];
    notification.alertBody = [NSString stringWithFormat:@" %@ 报警",[self getName]];
   // notification.soundName = [self getRingtoneFile];
    notification.soundName = @"beep3.mp3";
    notification.applicationIconBadgeNumber = 1;
    notification.alertAction = @"关闭";
    
    NSDate *now = [NSDate new];
    notification.fireDate = [now dateByAddingTimeInterval:10];
    notification.timeZone = [NSTimeZone defaultTimeZone];

    [[UIApplication sharedApplication]scheduleLocalNotification:notification];
    
    
//    NSNotification *notification = [NSNotification notificationWithName:@"Alarm" object:nil];
//    
//    [[NSNotificationCenter defaultCenter] performSelectorOnMainThread:@selector(postNotification:) withObject:notification waitUntilDone:NO];
   
    
   // [[NSNotificationCenter defaultCenter] postNotification:notification];
}




- (void) startRangeMonitoringIfEnabled
{
    //if (self.rangeMonitoringIsEnabled)
//    {
//        [self startRangeMonitoring];
//    }
}

-(float)getRssiRange{
    switch(self.range){
        case FINDER_RANGE_FAR:
            return -70;
        case FINDER_RANGE_NEAR:
            return -55;
        default:
            return 0;
       
    }
   
}



- (BOOL) isConnected
{
    CBPeripheral  * per = [self getPeripheral];
    if(per == nil)
        return NO;
    
    if([per isConnected])
        return YES;
    
    return NO;
    
    // If we are initialized, not disconnected and not link lost, we are connected
//    return self.state != PROXIMITY_TAG_STATE_UNINITIALIZED &&
//    self.state != PROXIMITY_TAG_STATE_DISCONNECTED &&
//    self.state != PROXIMITY_TAG_STATE_LINK_LOST;
}

- (BOOL) isBonded
{
    // If we are connected and not bonding, we are bonded
    return self.isConnected && (self.state != PROXIMITY_TAG_STATE_BONDING);
}

- (void) setState:(ProximityTagState) newState
{
    NSLog(@"Set state of %@ to %d", [ self getName ], newState);
    switch (newState)
    {
        case PROXIMITY_TAG_STATE_BONDING:
            break;
            
        case PROXIMITY_TAG_STATE_BONDED:
            self.hasBeenBonded = YES;
          //  [self startRangeMonitoringIfEnabled];
            
            
    //        [self startLocationMonitoringIfEnabled];
            break;
            
        case PROXIMITY_TAG_STATE_DISCONNECTED:
        case PROXIMITY_TAG_STATE_LINK_LOST:
            self.rssiLevel = 0;
            self.status = FINDER_STATUS_LINKLOSS;
          //  [self stopRangeMonitoring];
    //        [self stopLocationMonitoring];
            
            // Only store the location if we are currently bonded (i.e. the link was lost now, and we are not just initializing this object)
            if ([self isBonded])
            {
          //      [self storeLocationIfEnabled];
                
                //[SharedUI showOutOfRangeDialog:self.linkLossAlertLevelOnPhone forTag:self];
                
                [self.delegate FinderStateNotifyDelegateAction:self state:FINDER_NOTIFY_OUTRANGE];
            }
            // If the tag has never been bonded, and then disconnected, this indicates a failed connect.
            else if (!self.hasBeenBonded)
            {
              // [SharedUI showFailedConnectDialog:self];
                [self.delegate FinderStateNotifyDelegateAction:self state:FINDER_NOTIFY_FAIL];
            }
            break;
            
        case PROXIMITY_TAG_STATE_CLOSE:
       //     [self startLocationMonitoringIfEnabled];
            break;
            
        case PROXIMITY_TAG_STATE_REMOTE:
         //   [self stopLocationMonitoring];
         //   [self storeLocationIfEnabled];
            
            //[SharedUI showOutOfRangeDialog:self.linkLossAlertLevelOnPhone forTag:self];
             [self.delegate FinderStateNotifyDelegateAction:self state:FINDER_NOTIFY_OUTRANGE];
            break;
            
        default:
            break;
    }
    _state = newState;
  //  [self.delegate didUpdateData:self];
}

- (void) readRSSI{
    
    DLog(@"Read RSSI");
    [[ self getPeripheral ] readRSSI];
}

- (void) readLinkLossAlert
{
    DLog(@"Read LinkLossAlert");
    if([ self getPeripheral ] == nil )
        return ;
    
    if(self.linkLossAlertLevelCharacteristic == nil )
        return ;
    
    
    [[ self getPeripheral ] readValueForCharacteristic:self.linkLossAlertLevelCharacteristic];
}

- (void) handleRSSIReading:(float)rssiValue
{
    if(self.rssiLevel == 0) {
        self.rssiLevel = rssiValue;
        if (self.rssiLevel > self.rssiThreshold)
        {
            [self setState:PROXIMITY_TAG_STATE_CLOSE];
        }
        else
        {
            [self setState:PROXIMITY_TAG_STATE_REMOTE];
        }
    }
    
    float requiredRSSIChange = 0.15 * ABS(self.rssiThreshold);
    NSLog(@"RSSI: %f, change: %f, limit: %f", self.rssiLevel, requiredRSSIChange, self.rssiThreshold);
    
    if ((self.rssiLevel < (self.rssiThreshold - requiredRSSIChange)) &&
        (self.state != PROXIMITY_TAG_STATE_REMOTE))
    {
        if(self.state == PROXIMITY_TAG_STATE_REMOTING)
        {
            [self setState:PROXIMITY_TAG_STATE_REMOTE];
            //[self findTag:PROXIMITY_TAG_ALERT_LEVEL_HIGH]; //通知对方报警
            [self findMeTag:ALERT_OUTRANGE];
        }
        else if (self.state != PROXIMITY_TAG_STATE_REMOTING)
        {
            [self setState:PROXIMITY_TAG_STATE_REMOTING];
        }
        else
        {
            [self setState:PROXIMITY_TAG_STATE_CLOSE];
        }
    }
    else if ((self.rssiLevel > (self.rssiThreshold + requiredRSSIChange)) &&
             (self.state != PROXIMITY_TAG_STATE_CLOSE))
    {
        if (self.state == PROXIMITY_TAG_STATE_CLOSING)
        {
            [self setState:PROXIMITY_TAG_STATE_CLOSE];
        //    [self findTag:PROXIMITY_TAG_ALERT_LEVEL_NONE];
            [self findMeTag:ALERT_STOP];
        }
        else if (self.state != PROXIMITY_TAG_STATE_CLOSING)
        {
            [self setState:PROXIMITY_TAG_STATE_CLOSING];
        }
        else
        {
            [self setState:PROXIMITY_TAG_STATE_REMOTE];
        }
    }
  //  [self.delegate didUpdateData:self];
}

-(void)didDisconnect{
    
    if(self.isDeleting)
        return ;
    
     [ self setState:PROXIMITY_TAG_STATE_DISCONNECTED ];
    
   
    
    [self reset];
    
    //[self setPeripheral:nil];
    
//    [[AppDelegate getSystemAudioPlayer] stopVibrate];
//     [[AppDelegate getSystemAudioPlayer] stop];
    
   // [self stopRangeMonitoring];
   
    
    
}

-(void)didConnect:(CBPeripheral *)peripheral {
    [self setState:PROXIMITY_TAG_STATE_BONDING];
    
    self.isDisconnecting = NO;
    
    
    if(self.isFailAlarm)
        [self stopLocalAlarm];
    
   
    [peripheral discoverServices:nil];
    
    
    [ peripheral readRSSI]; //强制读取rssi数据
    
 
    
   // [ self startRangeMonitoring];
}

+(void)cleanup:(CBCentralManager *)centralManager peripheral:(CBPeripheral*)peripheral{
    
    
    if (!peripheral.isConnected) {
        return;
    }
    
    if (peripheral.services != nil) {
        for (CBService *service in peripheral.services) {
            
            if (service.characteristics != nil) {
                for(CBCharacteristic * characteristic in service.characteristics)
                    [peripheral setNotifyValue:NO forCharacteristic:characteristic];
            }
        }
    }
    
    [centralManager cancelPeripheralConnection:peripheral];
}

-(void)disconnect:(CBCentralManager *)centralManager{
    [BleFinder cleanup:centralManager peripheral:[self getPeripheral] ];
}

-(BOOL)connect:(CBCentralManager *)centralManager{
    
     NSDictionary* connectOptions = [NSDictionary dictionaryWithObject:[NSNumber numberWithBool:YES] forKey:CBConnectPeripheralOptionNotifyOnDisconnectionKey];
    
     [ centralManager connectPeripheral:[self getPeripheral] options:connectOptions ];
    
    return YES;
}



@end


