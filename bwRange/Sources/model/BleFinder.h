//
//  BleFinder.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-14.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BleDevice.h"

#define FINDER_TYPE_KEYS   (0)
#define FINDER_TYPE_WALLET  (1)
#define FINDER_TYPE_BAG    (2)

#define FINDER_TYPE_LAPTOP (3)



#define FINDER_RANGE_NEAR (0)
#define FINDER_RANGE_FAR (1)

#define FINDER_STATUS_FAR (1)  // (10-20)米 RSSI = -70
#define FINDER_STATUS_NEAR (2) // (1-10)米  RSSI = -50;
#define FINDER_STATUS_LINKLOSS (3)

#define ALERT_STOP (0)
#define ALERT_FINDME (1)
#define ALERT_OUTRANGE (4)

#define FINDER_NOTIFY_CONNECT  (0)
#define FINDER_NOTIFY_OUTRANGE (1)
#define FINDER_NOTIFY_FAIL     (2)

typedef enum {
    PROXIMITY_TAG_ALERT_LEVEL_NONE = 0,
    PROXIMITY_TAG_ALERT_LEVEL_MILD = 2,
    PROXIMITY_TAG_ALERT_LEVEL_HIGH = 1,
} ProximityTagAlertLevel;

typedef enum {
    PROXIMITY_TAG_STATE_UNINITIALIZED,
    PROXIMITY_TAG_STATE_BONDING,    //设备已经联上，但未发生数据传输
    PROXIMITY_TAG_STATE_BONDED,     //产生联接
    PROXIMITY_TAG_STATE_CLOSING,
    PROXIMITY_TAG_STATE_CLOSE,       //
    PROXIMITY_TAG_STATE_REMOTING,    //正在远离
    PROXIMITY_TAG_STATE_REMOTE,      //较远距离
    PROXIMITY_TAG_STATE_LINK_LOST,   //链接丢失，如设备关电
    PROXIMITY_TAG_STATE_DISCONNECTED, //主动切断
} ProximityTagState;

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
 <dict>
 <key>ID</key>
 <string>beep1.mp3</string>
 <key>TITLE</key>
 <string>Beep 1</string>
 </dict>
 <key>SENSITIVITY</key>
 <string>5</string>
 <key>TYPE</key>
 <string>0</string>
 <key>VIBRATE</key>
 <string>0</string>
 */

@protocol FinderStateNotifyDelegate;

@interface BleFinder : BleDevice

@property (nonatomic) int finderType ; //wallet ,bag ...
@property (nonatomic) int status     ; //

@property (nonatomic) int range     ; //用户设定的距离



@property (nonatomic) int sensitivity     ;

@property (nonatomic) BOOL vibrate     ; //震动
@property (nonatomic) BOOL mute     ; //是否静音
@property (nonatomic, strong) NSDictionary * ringtone  ;

@property (nonatomic) ProximityTagState state;

//远端警告通知
@property (nonatomic, strong) UILocalNotification * AlertNotification  ;


#define UUID_SERIVCE_ALERT_LEVEL          @"1802"
#define UUID_PROPERTY_ALERT_LEVEL         @"2A06"

#define UUID_SERIVCE_KEY_PRESS_STATE      @"FFE0"
#define UUID_PROPERTY_KEY_PRESS_STATE     @"FFE1"

#define UUID_PROPERTY_BATTERY_LEVEL       @"2A19"


#define REMOTE_KEY_ALERT_START     (0x01)
#define REMOTE_KEY_ALERT_STOP      (0x02)
#define REMOTE_KEY_ALERT_CAMERA    (0x04)




//用于向设备触发警报（比如设备蜂鸣器响）使用 Link Loss (0x1802)的 ALERT_LEVEL (0x2a06)
@property (strong ,nonatomic) CBCharacteristic *linkLossAlertLevelCharacteristic;


//用于接收设备按钮信息，用于手机报警，远程拍照。 按键服务 0xFFE0  Key Press State (0xFFE1)
@property (strong ,nonatomic) CBCharacteristic *keyPressCharacteristic;

//电池服务 Battery Service ,0x180F,Battery Level ()
@property (strong ,nonatomic) CBCharacteristic *batteryLevelCharacteristic;

@property float rssiThreshold;

@property (nonatomic) ProximityTagAlertLevel linkLossAlertLevelOnTag;
@property (nonatomic) ProximityTagAlertLevel linkLossAlertLevelOnPhone;

@property (nonatomic) BOOL locationTrackingIsEnabled;
@property (nonatomic) BOOL rangeMonitoringIsEnabled;
@property BOOL hasBeenBonded;

@property BOOL isFailAlarm; //在失败振铃

@property BOOL isFirstRemoteKey;

@property (nonatomic, weak) id<FinderStateNotifyDelegate> delegate;




- (BOOL) isConnected;
- (BOOL) isBonded;







-(id) init;

-(void) reset;

-(void) setType:(int)finderType;

- (NSString  *)getName;
- (UIImage  *)getImage;
- (UIImage  *)getStatusImage;

-(void)setDevRSSI:(NSNumber *)rssi;

-(void) initWithDictionary:(NSDictionary *)map;


+ (UIImage *)imageWithFinderType:(int)type;
+ (UIImage *)imageWithStatus:(int)type;

+ (NSString  *)stringWithFinderType:(int)type;

+ (NSString  *)stringWithFinderDistance:(int)type;

-(void) trigeFinderAlert:(BOOL)start;

- (void) readRSSI;
- (void) readLinkLossAlert;


- (void) startRangeMonitoring;

- (void) stopRangeMonitoring;




-(NSDictionary *)newDict;

-(void)startLocalAlarm;
-(void)stopLocalAlarm;

-(void)didDisconnect;

-(void)didConnect:(CBPeripheral *)peripheral ;

+(void)cleanup:(CBCentralManager *)centralManager peripheral:(CBPeripheral*)peripheral;



@end

@protocol FinderStateNotifyDelegate <NSObject>
- (void) FinderStateNotifyDelegateAction:(BleFinder* ) finder state:(int)state;
@end
