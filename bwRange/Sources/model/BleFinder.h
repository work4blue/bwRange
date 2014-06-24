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

@property (nonatomic) int range     ;
@property (nonatomic) int sensitivity     ;

@property (nonatomic) bool vibrate     ; //震动
@property (nonatomic) bool mute     ; //是否静音
@property (nonatomic, strong) NSDictionary * ringtone  ;



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




-(NSDictionary *)newDict;
@end
