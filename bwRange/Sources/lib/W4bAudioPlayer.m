//
//  W4bAudioPlayer.m
//  bwRange
//
//  Created by  Andrew Huang on 14-7-3.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import "W4bAudioPlayer.h"



@implementation W4bAudioPlayer

+ (void)initBackgroudMode{
    //后台播放音频设置
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
}

-(id) init{
    
    if (self=[super init]) {
        self.player = nil;
    }
    
    return self;
    
}

-(void)play:(NSString*)filename{
    NSString *soundFilePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename ] ;
    
    [self playAudio:soundFilePath];
}

-(void)play{
    
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource: @"alarm-sound"
                                    ofType: @".wav"];
    
    [self playAudio:soundFilePath];
    
    
}

-(void) playAudio:(NSString *)soundFilePath{
    if( (self.player) && [self.player isPlaying])
        return ;
    
   
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    
    
    
    self.player = newPlayer;
    
    [self.player prepareToPlay];
    
    // [self.player setDelegate: self];
    self.player.numberOfLoops = -1;    // Loop playback until invoke stop method
    [self.player play];
}


- (void) play:(NSString *)name type:(NSString*)type {
    
    if( (self.player) && [self.player isPlaying])
        return ;
    
    NSString *soundFilePath =
    [[NSBundle mainBundle] pathForResource: name
                                    ofType: type];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
    AVAudioPlayer *newPlayer =
    [[AVAudioPlayer alloc] initWithContentsOfURL: fileURL
                                           error: nil];
    
    self.player = newPlayer;
    
    [self.player prepareToPlay];
    
   // [self.player setDelegate: self];
    self.player.numberOfLoops = -1;    // Loop playback until invoke stop method
    [self.player play];
}

-(void) pause{
    [self.player pause ];

}
-(void) stop{
    [self.player stop ];
}



@end
