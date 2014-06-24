//
//  BleFinderService.h
//  bwRange
//
//  Created by  Andrew Huang on 14-6-24.
//  Copyright (c) 2014年  Andrew Huang. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BleFinderService : NSObject

@property (nonatomic, readonly) BOOL isDetecting;
@property (nonatomic, readonly) BOOL isBroadcasting;

-(void) startScanning;
-(void) stopScanning;

- (void)startDetectingFinders;

-(void)connectFinders;

-(id)init;


@end
