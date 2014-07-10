//
//  W4bAudioPlayer.h
//  bwRange
//
//  Created by  Andrew Huang on 14-7-3.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface W4bAudioPlayer : NSObject

@property (nonatomic, strong) AVAudioPlayer * player;

+ (void)initBackgroudMode;
- (void) play:(NSString *)name type:(NSString*)type;

-(void)play;
-(void)play:(NSString*)filename;

-(void) pause;
-(void) stop;

@end
