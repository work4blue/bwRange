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
@property(nonatomic) int mPlaySoundCount;
@property(nonatomic) int mPlayVibrateCount;

@end



static void playAudioCompletionCallback (SystemSoundID  mySSID, void* myself){
    
    SystemAudioPlayer * player = (__bridge SystemAudioPlayer *)myself;
    
    if(mySSID == kSystemSoundID_Vibrate){
        
        player.mPlayVibrateCount -- ;

        
        if(player.mPlayVibrateCount <= 0)
            return ;
        
        
        
    }
    else {
        player.mPlaySoundCount -- ;
        
        if(player.mPlaySoundCount <= 0)
            return ;
        
        
    }
    
    AudioServicesPlaySystemSound(mySSID);
}



@implementation SystemAudioPlayer

-(id)init{
    self = [super init];
    if (self) {
        _mPlaySoundCount = 0;
        _mPlayVibrateCount = 0;
         self.soundObjects = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
    
}





-(BOOL) start:(NSString*)filename {
    return [self start:filename repeat:60000];
}

-(BOOL) start:(NSString*)filename repeat:(int)repeat{
    
    if(_mPlaySoundCount >0)
        return NO;
    
   _mSoundId =  [SystemAudioPlayer createSystemAudioObject:filename];
//    if(_mSoundId < 0)
//        return NO;
//    
    
   
    AudioServicesAddSystemSoundCompletion (_mSoundId, NULL, NULL,playAudioCompletionCallback,(__bridge void*)self);
    

    AudioServicesPlayAlertSound (_mSoundId);
  
    
    _mPlaySoundCount = repeat;
    
    return YES;
    
}

-(BOOL) startById:(int)index{
    return [self startById:index repeat:60000];
}

-(BOOL) startById:(int)index repeat:(int)repeat
{
  
    
  
    if(_mPlaySoundCount >0)
        return NO;
    
    NSNumber *id = [ _soundObjects objectAtIndex:index];
    SystemSoundID soundID = (SystemSoundID)[id integerValue];
    
    
    AudioServicesAddSystemSoundCompletion (soundID, NULL, NULL,playAudioCompletionCallback,(__bridge void*)self);
    
    
    AudioServicesPlayAlertSound (soundID);
    
    
    _mPlaySoundCount = repeat;
    
    return YES;

}



-(void)stop{
    
    if(self.mPlaySoundCount > 0 )
       AudioServicesRemoveSystemSoundCompletion (_mSoundId);
    
    AudioServicesDisposeSystemSoundID(_mSoundId);
    
    _mPlaySoundCount = 0;
}

-(void)startVibrate{
    [self playVibrate:60000];
    
}

-(void)playVibrate:(int)repeat{
    if(self.mPlayVibrateCount > 0)
        return ;
    
    AudioServicesAddSystemSoundCompletion (kSystemSoundID_Vibrate, NULL, NULL,playAudioCompletionCallback,(__bridge void*)self);
    
    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
    
    
    _mPlayVibrateCount = repeat;
}

-(void)stopVibrate{
  //  if(self.mIsPlayVibrate == NO)
        AudioServicesRemoveSystemSoundCompletion (kSystemSoundID_Vibrate);
    
    AudioServicesDisposeSystemSoundID(kSystemSoundID_Vibrate);
    
    _mPlayVibrateCount = 0;
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

-(void)clearRingtoneList{
    for(int i= 0; i < _soundObjects.count ; i++){
        
        NSNumber *id = [ _soundObjects objectAtIndex:i];
        SystemSoundID soundID = (SystemSoundID)id;
        AudioServicesRemoveSystemSoundCompletion (soundID);
        
        AudioServicesDisposeSystemSoundID(soundID);
    }
    
     [self.soundObjects removeAllObjects];
    
    
    
}

-(void)initRingtoneList:(NSMutableArray *)array{
    
    [self clearRingtoneList];
    
    NSLog(@"initRingtoneList:array %@",array);
    
    for (NSDictionary *tone in array){
        NSString * fileName = [ tone objectForKey:@"RINGTONE"];
        
        SystemSoundID soundId = [ SystemAudioPlayer createSystemAudioObject:fileName ];
        
       // AudioServicesPlayAlertSound (soundId);
        
        NSLog(@"ringtine file %@ ",fileName);
        [ _soundObjects addObject:[ NSNumber numberWithInt:soundId] ];
        
        
        
    }

    
}
@end
