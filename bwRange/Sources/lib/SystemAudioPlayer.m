//
//  SystemAudioPlayer.m
//  bwRange
//
//  Created by  Andrew Huang on 14-7-16.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "SystemAudioPlayer.h"

#import <AudioToolbox/AudioToolbox.h>

@interface SystemAudioPlayer()

@property(nonatomic) SystemSoundID mSoundId;
@property(nonatomic) BOOL mIsPlaySound;
@property(nonatomic) BOOL mIsPlayVibrate;

@end



static void playAudioCompletionCallback (SystemSoundID  mySSID, void* myself){
    
       
        AudioServicesPlaySystemSound(mySSID);
}



@implementation SystemAudioPlayer

-(id)init{
    self = [super init];
    if (self) {
        _mIsPlaySound = NO;
        _mIsPlayVibrate = NO;
    }
    return self;
    
}

-(void) initAudioFile{
    
}



-(BOOL) start:(NSString*)filename {
    
    if(_mIsPlaySound == YES)
        return YES;
    
   _mSoundId =  [SystemAudioPlayer createSystemAudioObject:filename];
//    if(_mSoundId < 0)
//        return NO;
//    
    
   
        AudioServicesAddSystemSoundCompletion (_mSoundId, NULL, NULL,playAudioCompletionCallback,NULL);
    
    
    
    
    AudioServicesPlayAlertSound (_mSoundId);
    
    _mIsPlaySound  = YES;
    
    return YES;
    
}

-(void)stop{
    
    if(self.mIsPlaySound == YES)
       AudioServicesRemoveSystemSoundCompletion (_mSoundId);
    
    AudioServicesDisposeSystemSoundID(_mSoundId);
    
    _mIsPlaySound = NO;
}

-(void)startVibrate{
    if(self.mIsPlayVibrate == YES)
        return ;
    
     AudioServicesAddSystemSoundCompletion (kSystemSoundID_Vibrate, NULL, NULL,playAudioCompletionCallback,NULL);
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
    
    _mIsPlayVibrate = YES;
    
}

-(void)stopVibrate{
  //  if(self.mIsPlayVibrate == NO)
        AudioServicesRemoveSystemSoundCompletion (kSystemSoundID_Vibrate);
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    
    _mIsPlayVibrate = NO;
}

-(void)playVibrateOnce{
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
}

+(SystemSoundID)createSystemAudioObject:(NSString *)fileName{
    
    SystemSoundID        soundFileObject;
    NSString *Path=[[NSBundle mainBundle] bundlePath];
    NSURL *soundfileURL=[NSURL fileURLWithPath:[Path stringByAppendingPathComponent:fileName]];
    
    //建立音效对象
    OSStatus error =  AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundfileURL, &soundFileObject);
    
    if (error != kAudioServicesNoError)
    {
        DLog(@"error sound file %@",fileName);
        return -3000;
    }

    
    return soundFileObject;
}
@end
