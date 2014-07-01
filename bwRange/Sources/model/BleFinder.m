//
//  BleFinder.m
//  bwRange
//
//  Created by  Andrew Huang on 14-6-14.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "BleFinder.h"
#import "BleDevice.h"

@interface BleFinder()

@end

@implementation BleFinder

-(id) init{

    if (self=[super init]) {
        [ self setType:FINDER_TYPE_BAG ];
         self.status  = FINDER_STATUS_LINKLOSS;
        
        self.range = 5;
        
       
        
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
    
    NSString * tone =@"0";
    if(self.ringtone != nil)
        tone =[ self.ringtone objectForKey:@"id"];
    
   
    NSDictionary * dic =   [NSDictionary dictionaryWithObjectsAndKeys:
                self.UUID,@"UUID", [self getName ],@"NAME",
                 [ NSString stringWithFormat:@"%d",self.range],@"RANGE",tone,@"RINGTONE",
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
    return [ NSString stringWithFormat:@"BleFinder:UUID %@, type %d, Name %@,range %d,status %d,rssi %f,distance %f",self.UUID,self.finderType,[self getName],self.range,self.status , [self.RSSI  floatValue],self.distance ];
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
        
        case FINDER_STATUS_FAR: imageName =@"status_far"; break;
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
    [  self setPeripheral:nil ];
    
}

-(void)setDevRSSI:(NSNumber *)rssi{
    self.RSSI = rssi;
    
    self.distance = [self detectDistance:abs([rssi intValue])];
    
    CGFloat proximity  = [rssi floatValue];
    if (proximity < -70)
         self.status  = FINDER_STATUS_FAR;
    else if (proximity < -55)
        self.status  = FINDER_STATUS_NEAR;
    else if (proximity < 0)
        self.status  = FINDER_STATUS_LINKLOSS;

    
}


@end


