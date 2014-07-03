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

#define FINDER_STATUS_FAR (1)
#define FINDER_STATUS_NEAR (2)
#define FINDER_STATUS_LINKLOSS (3)

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

@interface BleFinder : BleDevice

@property (nonatomic) int finderType ; //wallet ,bag ...
@property (nonatomic) int status     ; //

@property (nonatomic) int range     ; //用户设定的距离



@property (nonatomic) int sensitivity     ;

@property (nonatomic) bool vibrate     ; //震动
@property (nonatomic) bool mute     ; //是否静音
@property (nonatomic, strong) NSDictionary * ringtone  ;

//远端警告通知
@property (nonatomic, strong) UILocalNotification * AlertNotification  ;


#define UUID_PROPERTY_ALERT_LEVEL         @"2A06"
#define UUID_PROPERTY_KEY_PRESS_STATE     @"FFE1"
#define UUID_PROPERTY_BATTERY_LEVEL       @"2A19"


#define REMOTE_KEY_ALERT_START     (0x01)
#define REMOTE_KEY_ALERT_STOP      (0x02)
#define REMOTE_KEY_ALERT_CAMERA    (0x04)




//用于向设备触发警报（比如设备蜂鸣器响）使用 Link Loss (0x1802)的 ALERT_LEVEL (0x2a06)
@property (strong ,nonatomic) CBCharacteristic *alertLevelCharacteristic;

//用于接收设备按钮信息，用于手机报警，远程拍照。 按键服务 0xFFE0  Key Press State (0xFFE1)
@property (strong ,nonatomic) CBCharacteristic *keyPressCharacteristic;

//电池服务 Battery Service ,0x180F,Battery Level ()
@property (strong ,nonatomic) CBCharacteristic *batteryLevelCharacteristic;




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




-(NSDictionary *)newDict;

-(void)startLocalAlarm;
-(void)stopLocalAlarm;

@end
