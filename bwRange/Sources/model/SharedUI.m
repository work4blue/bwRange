//
//  SharedUI.m
//  ProximityApp
//
//  Copyright (c) 2012 Nordic Semiconductor. All rights reserved.
//
//

#import "SharedUI.h"

#import "AppDelegate.h"

@implementation SharedUI
+ (void) showFailedConnectDialog:(BleFinder*) finder
{
    UIAlertView *dialog = [[UIAlertView alloc] initWithTitle:@"物品联接失败" message:[NSString stringWithFormat:@"无法联接到 %@. \n\n可能是断线或超出范围.", [ finder getName ]] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
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
    
    [[AppDelegate getAudioPlayer ] play ];
}

+ (void) showOutOfRangeDialog
{
    
        UILocalNotification *alarm = [[UILocalNotification alloc] init];
        alarm.alertBody = [NSString stringWithFormat:@"%@ has moved out of range.", @"test" ];
        alarm.alertAction = @"OK";
        
    
         //   alarm.soundName = @"alarm-sound.wav";
    
        [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
    
    
        [[AppDelegate getAudioPlayer ] play ];
}


+ (void) showOutOfRangeDialog:(ProximityTagAlertLevel) alertLevel forTag:(BleFinder*) finder
{
    if (alertLevel != PROXIMITY_TAG_ALERT_LEVEL_NONE)
    {
        UILocalNotification *alarm = [[UILocalNotification alloc] init];
        alarm.alertBody = [NSString stringWithFormat:@"%@ has moved out of range.", [ finder getName ] ];
        alarm.alertAction = @"OK";
        
        if (alertLevel == PROXIMITY_TAG_ALERT_LEVEL_HIGH)
        {
            alarm.soundName = @"alarm-sound.wav";
        }
        else
        {
            alarm.soundName = UILocalNotificationDefaultSoundName;
        }
        [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
        
        [[AppDelegate getAudioPlayer ] play ];
    }
}

+ (void) showFindPhoneDialog:(ProximityTagAlertLevel) alertLevel forTag:(BleFinder*) finder
{
    UILocalNotification *alarm = [[UILocalNotification alloc] init];
    alarm.alertBody = [NSString stringWithFormat:@"%@ wants to find your phone.", [ finder getName ]];
    alarm.alertAction = @"OK";
    
    [[UIApplication sharedApplication] presentLocalNotificationNow:alarm];
}

@end
