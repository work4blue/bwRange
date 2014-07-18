//
//  SystemAudioPlayer.h
//  bwRange
//
//  Created by  Andrew Huang on 14-7-16.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

//用于播放系统音频
#import <Foundation/Foundation.h>

@interface SystemAudioPlayer : NSObject

@property (nonatomic, strong) NSMutableArray *   soundObjects;

-(void) initAudioFile;

-(void)initRingtoneList:(NSMutableArray *)array;

-(void) stop;

//-(void) play:(NSString*)filename; //播放一次

-(BOOL) start:(NSString*)filename; //开始连续播放

-(BOOL) start:(NSString*)filename repeat:(int)repeat;

-(BOOL) startById:(int)index repeat:(int)repeat;
-(BOOL) startById:(int)index ;



//-(void)startById:(int)index; //播放指定音效

-(void)stop;

-(void)startVibrate; //开始连续震动

-(void)playVibrate:(int)repeat; //震动指定次数

-(void)stopVibrate;

-(void)playVibrateOnce; //震动一次




@end
